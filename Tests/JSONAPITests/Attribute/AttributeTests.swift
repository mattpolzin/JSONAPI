//
//  AttributeTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/27/18.
//

import XCTest
import JSONAPI

class AttributeTests: XCTestCase {

	func test_AttributeIsTransformedAttribute() {
		XCTAssertEqual(try TransformedAttribute<String, IdentityTransformer<String>>(rawValue: "hello"), try Attribute<String>(rawValue: "hello"))
	}

	func test_AttributeNonThrowingConstructor() {
		XCTAssertEqual(try Attribute<String>(rawValue: "hello"), Attribute<String>(value: "hello"))
	}

	func test_TransformedAttributeNoThrow() {
		XCTAssertNoThrow(try TransformedAttribute<String, TestTransformer>(rawValue: "10"))
	}

	func test_TransformedAttributeThrows() {
		XCTAssertThrowsError(try TransformedAttribute<String, TestTransformer>(rawValue: "10.3"))
	}

	func test_TransformedAttributeReversNoThrow() {
		XCTAssertNoThrow(try TransformedAttribute<String, TestTransformer>(transformedValue: 10))
	}
}

// MARK: Test types
extension AttributeTests {
	enum TestTransformer: ReversibleTransformer {
		public static func transform(_ value: String) throws -> Int {
			guard let ret = Int(value) else {
				throw DecodingError.typeMismatch(Int.self, .init(codingPath: [], debugDescription: "Expected Int from String."))
			}
			return ret
		}

		public static func reverse(_ value: Int) throws -> String {
			return String(value)
		}
	}
}
