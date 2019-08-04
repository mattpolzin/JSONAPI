//
//  File.swift
//  
//
//  Created by Mathew Polzin on 8/2/19.
//

import XCTest
@testable import JSONAPI

class EmptyObjectDecoderTests: XCTestCase {
    func testEmptyStruct() {
        XCTAssertNoThrow(try EmptyStruct.init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try EmptyStructWithCodingKeys.init(from: EmptyObjectDecoder()))
    }

    func testEmptyArray() {
        XCTAssertNoThrow(try [EmptyStruct].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [String].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [Int].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [Double].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [Bool].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [Float].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [Int8].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [Int16].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [Int32].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [Int64].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [UInt].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [UInt8].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [UInt16].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [UInt32].init(from: EmptyObjectDecoder()))
        XCTAssertNoThrow(try [UInt64].init(from: EmptyObjectDecoder()))
    }

    func testNonEmptyArray() {
        XCTAssertThrowsError(try NonEmptyArray<EmptyStruct>.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayString.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayInt.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayDouble.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayBool.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayFloat.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayInt8.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayInt16.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayInt32.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayInt64.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayUInt.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayUInt8.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayUInt16.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayUInt32.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyArrayUInt64.init(from: EmptyObjectDecoder()))
    }

    func testNonEmptyStruct() {
        XCTAssertThrowsError(try NonEmptyStruct<EmptyStruct>.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructString.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructInt.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructDouble.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructBool.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructFloat.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructInt8.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructInt16.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructInt32.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructInt64.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructUInt.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructUInt8.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructUInt16.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructUInt32.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try NonEmptyStructUInt64.init(from: EmptyObjectDecoder()))
    }

    func testWantingNil() {
        XCTAssertThrowsError(try StructWithNil.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try ArrayWithNil.init(from: EmptyObjectDecoder()))
    }

    func testWantingSingleValue() {
        XCTAssertThrowsError(try StructWithSingleValue.init(from: EmptyObjectDecoder()))
    }

    func testWantingNestedKeyed() {
        XCTAssertThrowsError(try StructWithNestedKeyedCall.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try ArrayWithNestedKeyedCall.init(from: EmptyObjectDecoder()))
    }

    func testWantingNestedUnkeyed() {
        XCTAssertThrowsError(try StructWithNestedUnkeyedCall.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try ArrayWithNestedUnkeyedCall.init(from: EmptyObjectDecoder()))
    }

    func testWantsSuper() {
        XCTAssertThrowsError(try StructWithUnkeyedSuper.init(from: EmptyObjectDecoder()))
        XCTAssertThrowsError(try StructWithKeyedSuper.init(from: EmptyObjectDecoder()))

        XCTAssertThrowsError(try ArrayWithUnkeyedSuper.init(from: EmptyObjectDecoder()))
    }

    func testKeysAndCodingPath() {
        XCTAssertEqual(try? EmptyObjectDecoder().container(keyedBy: EmptyStructWithCodingKeys.CodingKeys.self).allKeys.count, 0)
        XCTAssertEqual(try? EmptyObjectDecoder().container(keyedBy: EmptyStructWithCodingKeys.CodingKeys.self).codingPath.count, 0)

        XCTAssertEqual(try? EmptyObjectDecoder().unkeyedContainer().codingPath.count, 0)
        XCTAssertEqual(try? EmptyObjectDecoder().unkeyedContainer().currentIndex, 0)
        XCTAssertEqual(try? EmptyObjectDecoder().unkeyedContainer().count, 0)
    }
}

// MARK: - struct

struct EmptyStruct: Decodable {

}

struct EmptyStructWithCodingKeys: Decodable {
    enum CodingKeys: String, CodingKey {
        case hello
    }

    init(from decoder: Decoder) throws {}
}

struct NonEmptyStruct<T: Decodable>: Decodable {
    let value: T
}

struct NonEmptyStructString: Decodable {
    let value: String
}

struct NonEmptyStructInt: Decodable {
    let value: Int
}

struct NonEmptyStructDouble: Decodable {
    let value: Double
}

struct NonEmptyStructBool: Decodable {
    let value: Bool
}

struct NonEmptyStructFloat: Decodable {
    let value: Float
}

struct NonEmptyStructInt8: Decodable {
    let value: Int8
}

struct NonEmptyStructInt16: Decodable {
    let value: Int16
}

struct NonEmptyStructInt32: Decodable {
    let value: Int32
}

struct NonEmptyStructInt64: Decodable {
    let value: Int64
}

struct NonEmptyStructUInt: Decodable {
    let value: UInt
}

struct NonEmptyStructUInt8: Decodable {
    let value: UInt8
}

struct NonEmptyStructUInt16: Decodable {
    let value: UInt16
}

struct NonEmptyStructUInt32: Decodable {
    let value: UInt32
}

struct NonEmptyStructUInt64: Decodable {
    let value: UInt64
}

struct StructWithNil: Decodable {
    enum CodingKeys: String, CodingKey {
        case hello
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let _ = try container.decodeNil(forKey: .hello)
    }
}

struct StructWithSingleValue: Decodable {
    let value: String

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(String.self)
    }
}

struct StructWithNestedKeyedCall: Decodable {
    enum CodingKeys: String, CodingKey {
        case hello
    }

    enum NestedKeys: String, CodingKey {
        case world
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let _ = try container.nestedContainer(keyedBy: NestedKeys.self, forKey: .hello)
    }
}

struct StructWithNestedUnkeyedCall: Decodable {
    enum CodingKeys: String, CodingKey {
        case hello
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let _ = try container.nestedUnkeyedContainer(forKey: .hello)
    }
}

struct StructWithUnkeyedSuper: Decodable {
    enum CodingKeys: String, CodingKey {
        case hello
    }

    init(from decoder: Decoder) throws {
        let _ = try decoder.container(keyedBy: CodingKeys.self).superDecoder()
    }
}

struct StructWithKeyedSuper: Decodable {
    enum CodingKeys: String, CodingKey {
        case hello
    }

    init(from decoder: Decoder) throws {
        let _ = try decoder.container(keyedBy: CodingKeys.self).superDecoder(forKey: .hello)
    }
}

// MARK: - array

struct NonEmptyArray<T: Decodable>: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(T.self)
    }
}

struct NonEmptyArrayString: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(String.self)
    }
}

struct NonEmptyArrayInt: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(Int.self)
    }
}

struct NonEmptyArrayDouble: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(Double.self)
    }
}

struct NonEmptyArrayBool: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(Bool.self)
    }
}

struct NonEmptyArrayFloat: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(Float.self)
    }
}

struct NonEmptyArrayInt8: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(Int8.self)
    }
}

struct NonEmptyArrayInt16: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(Int16.self)
    }
}

struct NonEmptyArrayInt32: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(Int32.self)
    }
}

struct NonEmptyArrayInt64: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(Int64.self)
    }
}

struct NonEmptyArrayUInt: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(UInt.self)
    }
}

struct NonEmptyArrayUInt8: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(UInt8.self)
    }
}

struct NonEmptyArrayUInt16: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(UInt16.self)
    }
}

struct NonEmptyArrayUInt32: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(UInt32.self)
    }
}

struct NonEmptyArrayUInt64: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.decode(UInt64.self)
    }
}

struct ArrayWithNil: Decodable {

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        let _ = try container.decodeNil()
    }
}

struct ArrayWithNestedKeyedCall: Decodable {

    enum NestedKeys: String, CodingKey {
        case world
    }

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        let _ = try container.nestedContainer(keyedBy: NestedKeys.self)
    }
}

struct ArrayWithNestedUnkeyedCall: Decodable {

    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        let _ = try container.nestedUnkeyedContainer()
    }
}

struct ArrayWithUnkeyedSuper: Decodable {
    init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let _ = try container.superDecoder()
    }
}
