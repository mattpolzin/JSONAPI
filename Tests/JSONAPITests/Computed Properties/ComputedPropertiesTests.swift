//
//  ComputedPropertiesTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/28/18.
//

import XCTest
import JSONAPI
import JSONAPITestLib

class ComputedPropertiesTests: XCTestCase {
	func test_DecodeIgnoresComputed() {
		let entity = decoded(type: TestType.self, data: computed_property_attribute)

		XCTAssertEqual(entity.id, "1234")
		XCTAssertEqual(entity[\.name], "Sarah")
		XCTAssertEqual(entity ~> \.other, "5678")
		XCTAssertNoThrow(try TestType.check(entity))
	}

	func test_EncodeIgnoresComputed() {
		test_DecodeEncodeEquality(type: TestType.self, data: computed_property_attribute)
	}

	func test_ComputedAttributeAccess() {
		let entity = decoded(type: TestType.self, data: computed_property_attribute)

		XCTAssertEqual(entity[\.computed], "Sarah")
	}

	func test_ComputedRelationshipAccess() {
		let entity = decoded(type: TestType.self, data: computed_property_attribute)

		XCTAssertEqual(entity ~> \.computed, "5678")
	}
}

// MARK: Test types
extension ComputedPropertiesTests {
	public enum TestTypeDescription: EntityDescription {
		public static var type: String { return "test" }

		public struct Attributes: JSONAPI.Attributes {
			public let name: Attribute<String>
			public var computed: Attribute<String> {
				return name
			}
		}

		public struct Relationships: JSONAPI.Relationships {
			public let other: ToOneRelationship<TestType>

			public var computed: ToOneRelationship<TestType> {
				return other
			}
		}
	}

	public typealias TestType = Entity<TestTypeDescription>
}
