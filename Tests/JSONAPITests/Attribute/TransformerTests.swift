//
//  TransformerTests.swift
//  
//
//  Created by Mathew Polzin on 8/2/19.
//

import XCTest
import JSONAPI
import JSONAPITesting

struct T1: Encodable {
    @Attr(serializer: IntToString.self)
    var x: Int

    init(x: Int) {
        self._x = .init(wrappedValue: x)
    }
}

struct T2: Decodable {
    @Attr(deserializer: IntToString.self)
    var y: String
}

struct Tmp {
    @Attr(serializer: IntToString.self)
    var x: Int = 5

    @Attr(deserializer: IntToString.self)
    var y: String = "2"
}

struct T3: Codable {
    @Attr(serializer: StringToInt.self, deserializer: IntToString.self)
    var y: String = "1"
}

struct T4: Encodable {
    @Attr(serializer: StringToInt?.self)
    var w: String?
}

struct T5: Codable {
    @Attr(serializer: StringToInt?.self, deserializer: IntToString?.self)
    var x: String?
}

struct T6: Decodable {
    @Omittable
    @Attr(deserializer: IntToString?.self)
    var y: String?
}

class TransformerTests: XCTestCase {
    func test_tmp() {
        let t1 = T1(x: 2)
        print(encodable: t1)

        let t3 = T3(y: "3")
        print(encodable: t3)

        let t2 = decoded(type: T2.self, data: #"{"y":63}"#.data(using: .utf8)!)
        print(t2.y)

        let t4 = T4(w: .init(wrappedValue: nil))
        let t4_2 = T4(w: .init(wrappedValue: "12"))
        print(encodable: t4)
        print(encodable: t4_2)

        let t5 = decoded(type: T5.self, data: #"{"x":null}"#.data(using: .utf8)!)
        let t5_2 = decoded(type: T5.self, data: #"{"x":10}"#.data(using: .utf8)!)
        XCTAssertThrowsError(try JSONDecoder().decode(T5.self, from: #"{}"#.data(using: .utf8)!))
        print(t5.x)
        print(t5_2.x)

        let t6 = decoded(type: T6.self, data: #"{}"#.data(using: .utf8)!)
    }

    func testIdentityTransform() {
        let inString = "hello world"

        XCTAssertNoThrow(try IdentityTransformer.transform(inString))
        XCTAssertEqual(inString, try? IdentityTransformer.transform(inString))

        XCTAssertNoThrow(try IdentityTransformer.reverse(inString))
        XCTAssertEqual(inString, try? IdentityTransformer.reverse(inString))
    }

    func testValidator() {
        let string1 = "hello"
        let string2 = "hello world"

        XCTAssertThrowsError(try MoreThanFiveCharValidator.validate(string1))
        XCTAssertThrowsError(try MoreThanFiveCharValidator.transform(string1))
        XCTAssertThrowsError(try MoreThanFiveCharValidator.reverse(string1))

        XCTAssertNoThrow(try MoreThanFiveCharValidator.validate(string2))
        XCTAssertNoThrow(try MoreThanFiveCharValidator.transform(string2))
        XCTAssertNoThrow(try MoreThanFiveCharValidator.reverse(string2))

        XCTAssertEqual(string2, try MoreThanFiveCharValidator.transform(string2))
        XCTAssertEqual(string2, try MoreThanFiveCharValidator.reverse(string2))
    }
}

enum MoreThanFiveCharValidator: Validator {
    public static func transform(_ value: String) throws -> String {
        guard value.count > 5 else {
            throw Error.fewerThanFiveChars
        }
        return value
    }

    enum Error: Swift.Error {
        case fewerThanFiveChars
    }
}

enum StringToInt: Transformer {
    public static func transform(_ value: String) throws -> Int {
        let res = Int(value)
        guard let ret = res else {
            throw Error.nonIntegerString
        }
        return ret
    }

    enum Error: Swift.Error {
        case nonIntegerString
    }
}

enum IntToString: Transformer {
    public static func transform(_ value: Int) throws -> String {
        return String(value)
    }
}
