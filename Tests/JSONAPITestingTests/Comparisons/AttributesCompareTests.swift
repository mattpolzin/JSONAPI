//
//  File.swift
//  
//
//  Created by Mathew Polzin on 11/3/19.
//

import XCTest
import JSONAPI
import JSONAPITesting

final class AttributesCompareTests: XCTestCase {
    func test_sameAttributes() {
        let attr1 = TestAttributes(
            string: "hello world",
            int: 10,
            bool: true,
            double: 105.4,
            struct: .init(value: .init())
        )
        let attr2 = attr1

        XCTAssertEqual(attr1.compare(to: attr2), [
            "string": .same,
            "int": .same,
            "bool": .same,
            "double": .same,
            "struct": .same
        ])
    }

    func test_differentAttributes() {
        let attr1 = TestAttributes(
            string: "hello world",
            int: 10,
            bool: true,
            double: 105.4,
            struct: .init(value: .init())
        )
        let attr2 = TestAttributes(
            string: "hello",
            int: 11,
            bool: false,
            double: 1.4,
            struct: .init(value: .init(val: "there"))
        )

        XCTAssertEqual(attr1.compare(to: attr2), [
            "string": .different("hello world", "hello"),
            "int": .different("10", "11"),
            "bool": .different("true", "false"),
            "double": .different("105.4", "1.4"),
            "struct": .different("string: hello", "string: there")
        ])
    }
}

private struct TestAttributes: JSONAPI.Attributes {
    let string: Attribute<String>
    let int: Attribute<Int>
    let bool: Attribute<Bool>
    let double: Attribute<Double>
    let `struct`: Attribute<Struct>

    struct Struct: Equatable, Codable, CustomStringConvertible {
        let string: String

        init(val: String = "hello") {
            self.string = val
        }

        var description: String { return "string: \(string)" }
    }
}
