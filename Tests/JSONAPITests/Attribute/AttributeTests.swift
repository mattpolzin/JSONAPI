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

	func test_NullableIsNullIfNil() {
		struct Wrapper: Codable {
			let dummy: Attribute<String?>
		}
		let data = encoded(value: Wrapper(dummy: .init(value: nil)))
		let string = String(data: data, encoding: .utf8)!

		XCTAssertEqual(string, "{\"dummy\":null}")
	}

	func test_NullableIsEqualToNonNullableIfNotNil() {
		struct Wrapper1: Codable {
			let dummy: Attribute<String?>
		}
		struct Wrapper2: Codable {
			let dummy: Attribute<String>
		}
		let data1 = encoded(value: Wrapper1(dummy: .init(value: "hello")))
		let data2 = encoded(value: Wrapper2(dummy: .init(value: "hello")))

		XCTAssertEqual(data1, data2)
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
