//
//  CustomAttributesTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 12/27/18.
//

import XCTest
@testable import JSONAPI
import JSONAPITesting

class CustomAttributesTests: XCTestCase {
	func test_customDecode() {
		let entity = decoded(type: CustomAttributeEntity.self, data: customAttributeEntityData)

        XCTAssertEqual(entity.firstName, "Cool")
        XCTAssertEqual(entity.name, "Cool Name")
		XCTAssertNoThrow(try CustomAttributeEntity.check(entity))
	}

	func test_customEncode() {
		test_DecodeEncodeEquality(type: CustomAttributeEntity.self,
								  data: customAttributeEntityData)
	}

	func test_customKeysDecode() {
		let entity = decoded(type: CustomKeysEntity.self, data: customAttributeEntityData)

        XCTAssertEqual(entity.firstNameSilly, "Cool")
        XCTAssertEqual(entity.lastNameSilly, "Name")
		XCTAssertNoThrow(try CustomKeysEntity.check(entity))
	}

	func test_customKeysEncode() {
		test_DecodeEncodeEquality(type: CustomKeysEntity.self,
								  data: customAttributeEntityData)
	}
}

// MARK: - Test Types
extension CustomAttributesTests {
	enum CustomAttributeEntityDescription: ResourceObjectDescription {
		public static var jsonType: String { return "test1" }

		public struct Attributes: JSONAPI.Attributes {
			let firstName: Attribute<String>
			public let name: Attribute<String>

			private enum CodingKeys: String, CodingKey {
				case firstName
				case lastName
			}
		}

		public typealias Relationships = NoRelationships
	}

	typealias CustomAttributeEntity = BasicEntity<CustomAttributeEntityDescription>

	enum CustomKeysEntityDescription: ResourceObjectDescription {
		public static var jsonType: String { return "test1" }

		public struct Attributes: JSONAPI.Attributes {
			public let firstNameSilly: Attribute<String>
			public let lastNameSilly: Attribute<String>

			enum CodingKeys: String, CodingKey {
				case firstNameSilly = "firstName"
				case lastNameSilly = "lastName"
			}
		}

		public typealias Relationships = NoRelationships
	}

	typealias CustomKeysEntity = BasicEntity<CustomKeysEntityDescription>
}

extension CustomAttributesTests.CustomAttributeEntityDescription.Attributes {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		firstName = try .defaultDecoding(from: container, forKey: .firstName)
		let lastName = try container.decode(String.self, forKey: .lastName)

		name = firstName.map { "\($0) \(lastName)" }
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(firstName, forKey: .firstName)
		let lastName = String(name.value.split(separator: " ")[1])
		try container.encode(lastName, forKey: .lastName)
	}
}

// MARK: - Test Data
private let customAttributeEntityData = """
{
	"type": "test1",
	"id": "1",
	"attributes": {
		"firstName": "Cool",
		"lastName": "Name"
	}
}
""".data(using: .utf8)!
