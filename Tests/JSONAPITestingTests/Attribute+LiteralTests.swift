//
//  Attribute+LiteralTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/27/18.
//

import XCTest
import JSONAPI
import JSONAPITesting

class Attribute_LiteralTests: XCTestCase {

	func test_StringLiteral() {
		XCTAssertEqual(Attribute<String>(value: "hello"), "hello")
	}

	func test_NullableStringLiteral() {
		XCTAssertEqual(Attribute<String?>(value: "world"), "world")
	}

	func test_OptionalStringLiteral() {
		let x: Attribute<String>? = .init(value: "ok")
		XCTAssertEqual(x, "ok")
	}

	func test_NullableOptionalStringLiteral() {
		let x: Attribute<String?>? = .init(value: "hello")
		XCTAssertEqual(x, "hello")
	}

	func test_BooleanLiteral() {
		XCTAssertEqual(Attribute<Bool>(value: false), false)
	}

	func test_NullableBooleanLiteral() {
		XCTAssertEqual(Attribute<Bool?>(value: true), true)
	}

	func test_OptionalBooleanLiteral() {
		let x: Attribute<Bool>? = .init(value: false)
		XCTAssertEqual(x, false)
	}

	func test_NullableOptionalBooleanLiteral() {
		let x: Attribute<Bool?>? = .init(value: true)
		XCTAssertEqual(x, true)
	}

	func test_IntegerLiteral() {
		XCTAssertEqual(Attribute<Int>(value: 12), 12)
	}

	func test_NullableIntegerLiteral() {
		XCTAssertEqual(Attribute<Int?>(value: 13), 13)
	}

	func test_OptionalIntegerLiteral() {
		let x: Attribute<Int>? = .init(value: 14)
		XCTAssertEqual(x, 14)
	}

	func test_NullableOptionalIntegerLiteral() {
		let x: Attribute<Int?>? = .init(value: 15)
		XCTAssertEqual(x, 15)
	}

	func test_FloatLiteral() {
		XCTAssertEqual(Attribute<Float>(value: 1.2), 1.2)
		XCTAssertEqual(Attribute<Double>(value: 1.2), 1.2)
	}

	func test_NullableFloatLiteral() {
		XCTAssertEqual(Attribute<Float?>(value: 2.3), 2.3)
		XCTAssertEqual(Attribute<Double?>(value: 3.4), 3.4)
	}

	func test_OptionalFloatLiteral() {
		let x: Attribute<Float>? = .init(value: 2.3)
		let y: Attribute<Double>? = .init(value: 3.4)
		XCTAssertEqual(x, 2.3)
		XCTAssertEqual(y, 3.4)
	}

	func test_NullableOptionalFloatLiteral() {
		let x: Attribute<Float?>? = .init(value: 2.3)
		let y: Attribute<Double?>? = .init(value: 3.4)
		XCTAssertEqual(x, 2.3)
		XCTAssertEqual(y, 3.4)
	}

	func test_ArrayLiteral() {
		XCTAssertEqual(Attribute<[String]>(value: ["hello", "world"]), ["hello", "world"])
	}

	func test_NullableArrayLiteral() {
		XCTAssertEqual(Attribute<[String]?>(value: ["hello", "world"]), ["hello", "world"])
	}

	func test_OptionalArrayLiteral() {
		let x: Attribute<[String]>? = .init(value: ["hello", "world"])
		XCTAssertEqual(x, ["hello", "world"])
	}

	func test_NullableOptionalArrayLiteral() {
		let x: Attribute<[String]?>? = .init(value: ["hello", "world"])
		XCTAssertEqual(x, ["hello", "world"])
	}

	func test_DictionaryLiteral() {
		XCTAssertEqual(Attribute<[String : Int]>(value: ["hello": 1]), ["hello": 1])
	}

	func test_NullableDictionaryLiteral() {
		XCTAssertEqual(Attribute<[String: Int]?>(value: ["hello": 1]), ["hello": 1])
	}

	func test_OptionalDictionaryLiteral() {
		let x: Attribute<[String: Int]>? = .init(value: ["hello": 1])
		XCTAssertEqual(x, ["hello": 1])
	}

	func test_NullableOptionalDictionaryLiteral() {
		let x: Attribute<[String: Int]?>? = .init(value: ["hello": 1])
		XCTAssertEqual(x, ["hello": 1])
	}

	func test_NilLiteral() {
		XCTAssertEqual(Attribute<String?>(value: nil), nil)
	}

	func test_OptionalNilLiteral() {
		let _: Attribute<String?>? = nil
	}
}
