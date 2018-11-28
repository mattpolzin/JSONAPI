//
//  Attribute+LiteralTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/27/18.
//

import XCTest
import JSONAPI
import JSONAPITestLib

class Attribute_LiteralTests: XCTestCase {

	func test_StringLiteral() {
		XCTAssertEqual(Attribute<String>(value: "hello"), "hello")
	}

	func test_BooleanLiteral() {
		XCTAssertEqual(Attribute<Bool>(value: false), false)
	}

	func test_IntegerLiteral() {
		XCTAssertEqual(Attribute<Int>(value: 12), 12)
	}

	func test_FloatLiteral() {
		XCTAssertEqual(Attribute<Float>(value: 1.2), 1.2)
		XCTAssertEqual(Attribute<Double>(value: 1.2), 1.2)
	}

	func test_ArrayLiteral() {
		XCTAssertEqual(Attribute<[String]>(value: ["hello", "world"]), ["hello", "world"])
	}

	func test_DictionaryLiteral() {
		XCTAssertEqual(Attribute<[String : Int]>(value: ["hello": 1]), ["hello": 1])
	}

	func test_NilLiteral() {
		XCTAssertEqual(Attribute<String?>(value: nil), nil)
	}
}
