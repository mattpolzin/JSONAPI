//
//  ComputedPropertiesTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/28/18.
//

import XCTest
import JSONAPI
import JSONAPITesting

class ComputedPropertiesTests: XCTestCase {
	func test_DecodeIgnoresComputed() {
		let entity = decoded(type: TestType.self, data: computed_property_attribute)

		XCTAssertEqual(entity.id, "1234")
        XCTAssertEqual(entity.name, "Sarah")
		XCTAssertEqual(entity ~> \.other, "5678")
		XCTAssertNoThrow(try TestType.check(entity))
	}

	func test_EncodeIgnoresComputed() {
		test_DecodeEncodeEquality(type: TestType.self, data: computed_property_attribute)
	}

	func test_ComputedAttributeAccess() {
		let entity = decoded(type: TestType.self, data: computed_property_attribute)

        XCTAssertEqual(entity.computed, "Sarah2")
        XCTAssertEqual(entity[direct: \.directSecretsOut], "shhhh")
	}

	func test_ComputedNonAttributeAccess() {
		let entity = decoded(type: TestType.self, data: computed_property_attribute)

        XCTAssertEqual(entity[direct: \.directComputed], "Sarah2")
	}

	func test_ComputedRelationshipAccess() {
		let entity = decoded(type: TestType.self, data: computed_property_attribute)

		XCTAssertEqual(entity ~> \.computed, "5678")
	}
}

// MARK: Test types
extension ComputedPropertiesTests {
	public enum TestTypeDescription: ResourceObjectDescription {
		public static var jsonType: String { return "test" }

		public struct Attributes: JSONAPI.Attributes {
			public let name: Attribute<String>
			private let secret: Attribute<String>

			public var computed: Attribute<String> {
				return name.map { $0 + "2" }
			}

			public var directComputed: String {
				return computed.value
			}

			public var directSecretsOut: String {
				return secret.value
			}
		}

		public struct Relationships: JSONAPI.Relationships {
			public let other: ToOneRelationship<TestType, NoIdMetadata, NoMetadata, NoLinks>

			public var computed: ToOneRelationship<TestType, NoIdMetadata, NoMetadata, NoLinks> {
				return other
			}
		}
	}

	public typealias TestType = BasicEntity<TestTypeDescription>
}
