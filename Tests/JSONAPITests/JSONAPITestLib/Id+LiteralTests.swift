//
//  Id+LiteralTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/27/18.
//

import XCTest
import JSONAPI
import JSONAPITestLib

extension Int: RawIdType {}

class Id_LiteralTests: XCTestCase {

	func test_StringLiteral() {
		XCTAssertEqual(Id<String, TestEntity>(rawValue: "hello"), "hello")
	}

	func test_IntegerLiteral() {
		XCTAssertEqual(Id<Int, TestEntity>(rawValue: 121), 121)
	}
}

// MARK: - Test types
extension Id_LiteralTests {
	enum TestDescription: EntityDescription {
		public static var type: String { return "test" }

		public typealias Attributes = NoAttributes
		public typealias Relationships = NoRelationships
	}

	typealias TestEntity = Entity<TestDescription>
}
