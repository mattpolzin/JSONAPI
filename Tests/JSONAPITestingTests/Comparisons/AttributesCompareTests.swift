//
//  AttributesCompareTests.swift
//  
//
//  Created by Mathew Polzin on 11/3/19.
//

import XCTest
import JSONAPI
import JSONAPITesting

final class AttributesCompareTests: XCTestCase {
    func test_sameAttributes() throws {
        let attr1 = TestAttributes(
            string: "hello world",
            int: 10,
            bool: true,
            double: 105.4,
            struct: .init(value: .init()),
            transformed: try .init(rawValue: 10),
            optional: .init(value: 20),
            optionalTransformed: try .init(rawValue: 10)
        )
        let attr2 = attr1

        XCTAssertEqual(attr1.compare(to: attr2), [
            "string": .same,
            "int": .same,
            "bool": .same,
            "double": .same,
            "struct": .same,
            "transformed": .same,
            "optional": .same,
            "optionalTransformed": .same
        ])
    }

    func test_differentAttributes() throws {
        let attr1 = TestAttributes(
            string: "hello world",
            int: 10,
            bool: true,
            double: 105.4,
            struct: .init(value: .init()),
            transformed: try .init(rawValue: 10),
            optional: nil,
            optionalTransformed: nil
        )
        let attr2 = TestAttributes(
            string: "hello",
            int: 11,
            bool: false,
            double: 1.4,
            struct: .init(value: .init(val: "there")),
            transformed: try .init(rawValue: 11),
            optional: .init(value: 20.5),
            optionalTransformed: try .init(rawValue: 10)
        )

        XCTAssertEqual(attr1.compare(to: attr2), [
            "string": .different("hello world", "hello"),
            "int": .different("10", "11"),
            "bool": .different("true", "false"),
            "double": .different("105.4", "1.4"),
            "struct": .different("string: hello", "string: there"),
            "transformed": .different("10", "11"),
            "optional": .different("nil", "20.5"),
            "optionalTransformed": .different("nil", "10")
        ])
    }

    func test_nonAttributeTypes() {
        let attr1 = NonAttributeTest(
            string: "hello",
            int: 10,
            double: 11.2,
            bool: true,
            struct: .init(),
            optional: nil
        )

        XCTAssertEqual(attr1.compare(to: attr1), [
            "string": .prebuilt("comparison on non-JSON:API Attribute type (String) not supported."),
            "int": .prebuilt("comparison on non-JSON:API Attribute type (Int) not supported."),
            "double": .prebuilt("comparison on non-JSON:API Attribute type (Double) not supported."),
            "bool": .prebuilt("comparison on non-JSON:API Attribute type (Bool) not supported."),
            "struct": .prebuilt("comparison on non-JSON:API Attribute type (Struct) not supported."),
            "optional": .prebuilt("comparison on non-JSON:API Attribute type (Optional<Int>) not supported.")
        ])
    }
}

private struct TestAttributes: JSONAPI.Attributes {
    let string: Attribute<String>
    let int: Attribute<Int>
    let bool: Attribute<Bool>
    let double: Attribute<Double>
    let `struct`: Attribute<Struct>
    let transformed: TransformedAttribute<Int, TestTransformer>
    let optional: Attribute<Double>?
    let optionalTransformed: TransformedAttribute<Int, TestTransformer>?
}

private struct Struct: Equatable, Codable, CustomStringConvertible {
    let string: String

    init(val: String = "hello") {
        self.string = val
    }

    var description: String { return "string: \(string)" }
}

private enum TestTransformer: Transformer {
    static func transform(_ value: Int) throws -> String {
        return "\(value)"
    }
}

private struct NonAttributeTest: JSONAPI.Attributes {
    let string: String
    let int: Int
    let double: Double
    let bool: Bool
    let `struct`: Struct
    let optional: Int?
}
