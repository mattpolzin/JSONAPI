//
//  Relationship+LiteralTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/27/18.
//

import XCTest
import JSONAPI
import JSONAPITestLib

class Relationship_LiteralTests: XCTestCase {

	func test_NilLiteral() {
		XCTAssertEqual(ToOneRelationship<TestEntity?>(id: nil), nil)
	}
}

// MARK: - Test types
extension Relationship_LiteralTests {
	enum TestDescription: EntityDescription {
		public static var type: String { return "test" }

		public typealias Attributes = NoAttributes
		public typealias Relationships = NoRelationships
	}

	typealias TestEntity = Entity<TestDescription>
}
