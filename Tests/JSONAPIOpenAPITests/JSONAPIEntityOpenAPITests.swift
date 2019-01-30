//
//  JSONAPIEntityOpenAPITests.swift
//  JSONAPIOpenAPITests
//
//  Created by Mathew Polzin on 1/15/19.
//

import XCTest
import JSONAPI
import JSONAPIOpenAPI
import AnyCodable
import Sampleable

class JSONAPIEntityOpenAPITests: XCTestCase {
	func test_EmptyEntity() {
		let node = try! TestType1.openAPINode(using: JSONEncoder())

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .object(.generic))

		guard case let .object(contextA, objectContext1) = node else {
			XCTFail("Expected Object node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(objectContext1.minProperties, 2)
		XCTAssertEqual(Set(objectContext1.requiredProperties), Set(["id", "type"]))
		XCTAssertEqual(Set(objectContext1.properties.keys), Set(["id", "type"]))
		XCTAssertEqual(objectContext1.properties["id"], .string(.init(format: .generic,
																	  required: true),
																.init()))
		XCTAssertEqual(objectContext1.properties["type"], .string(.init(format: .generic,
																	  required: true,
																	  allowedValues: [.init(TestType1.jsonType)]),
																.init()))
	}

	func test_UnidentifiedEmptyEntity() {
		let node = try! UnidentifiedTestType1.openAPINode(using: JSONEncoder())

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .object(.generic))

		guard case let .object(contextA, objectContext1) = node else {
			XCTFail("Expected Object node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(objectContext1.minProperties, 1)
		XCTAssertEqual(Set(objectContext1.requiredProperties), Set(["type"]))
		XCTAssertEqual(Set(objectContext1.properties.keys), Set(["type"]))
		XCTAssertEqual(objectContext1.properties["type"], .string(.init(format: .generic,
																		required: true,
																		allowedValues: [.init(TestType1.jsonType)]),
																  .init()))
	}

	func test_AttributesEntity() {

		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		dateFormatter.locale = Locale(identifier: "en_US")

		let encoder = JSONEncoder()
		encoder.dateEncodingStrategy = .formatted(dateFormatter)

		let node = try! TestType2.openAPINode(using: encoder)

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .object(.generic))

		guard case let .object(contextA, objectContext1) = node else {
			XCTFail("Expected Object node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(objectContext1.minProperties, 3)
		XCTAssertEqual(Set(objectContext1.requiredProperties), Set(["id", "type", "attributes"]))
		XCTAssertEqual(Set(objectContext1.properties.keys), Set(["id", "type", "attributes"]))

		XCTAssertEqual(objectContext1.properties["id"], .string(.init(format: .generic,
																	  required: true),
																.init()))
		XCTAssertEqual(objectContext1.properties["type"], .string(.init(format: .generic,
																		required: true,
																		allowedValues: [.init(TestType2.jsonType)]),
																  .init()))

		let attributesNode = objectContext1.properties["attributes"]

		XCTAssertNotNil(attributesNode)
		XCTAssertTrue(attributesNode?.required ?? false)
		XCTAssertEqual(attributesNode?.jsonTypeFormat, .object(.generic))

		guard case let .object(contextB, attributesContext)? = attributesNode else {
			XCTFail("Expected Object node for attributes")
			return
		}

		XCTAssertEqual(contextB, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(attributesContext.minProperties, 4)
		XCTAssertEqual(Set(attributesContext.requiredProperties), Set(["stringProperty", "enumProperty", "dateProperty", "nullableProperty"]))
		XCTAssertEqual(Set(attributesContext.properties.keys), Set(["stringProperty", "enumProperty", "dateProperty", "optionalProperty", "nullableProperty", "nullableOptionalProperty"]))

		XCTAssertEqual(attributesContext.properties["stringProperty"],
					   .string(.init(format: .generic,
									 required: true),
							   .init()))

		XCTAssertEqual(attributesContext.properties["enumProperty"],
					   .string(.init(format: .generic,
									 required: true,
									 nullable: false,
									 allowedValues: ["one", "two"].map(AnyCodable.init)),
							   .init()))

		XCTAssertEqual(attributesContext.properties["dateProperty"],
					   .string(.init(format: .dateTime,
									 required: true,
									 nullable: false,
									 allowedValues: nil),
							   .init()))

		XCTAssertEqual(attributesContext.properties["optionalProperty"],
					   .string(.init(format: .generic,
									 required: false,
									 nullable: false,
									 allowedValues: nil),
							   .init()))

		XCTAssertEqual(attributesContext.properties["nullableProperty"],
					   .string(.init(format: .generic,
									 required: true,
									 nullable: true,
									 allowedValues: nil),
							   .init()))

		XCTAssertEqual(attributesContext.properties["nullableOptionalProperty"],
					   .string(.init(format: .generic,
									 required: false,
									 nullable: true,
									 allowedValues: nil),
							   .init()))
	}

	func test_RelationshipsEntity() {
		let node = try! TestType3.openAPINode(using: JSONEncoder())

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .object(.generic))

		guard case let .object(contextA, objectContext1) = node else {
			XCTFail("Expected Object node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(objectContext1.minProperties, 3)
		XCTAssertEqual(Set(objectContext1.requiredProperties), Set(["id", "type", "relationships"]))
		XCTAssertEqual(Set(objectContext1.properties.keys), Set(["id", "type", "relationships"]))

		XCTAssertEqual(objectContext1.properties["id"], .string(.init(format: .generic,
																	  required: true),
																.init()))
		XCTAssertEqual(objectContext1.properties["type"], .string(.init(format: .generic,
																		required: true,
																		allowedValues: [.init(TestType3.jsonType)]),
																  .init()))

		let relationshipsNode = objectContext1.properties["relationships"]

		XCTAssertNotNil(relationshipsNode)
		XCTAssertTrue(relationshipsNode?.required ?? false)
		XCTAssertEqual(relationshipsNode?.jsonTypeFormat, .object(.generic))

		guard case let .object(contextB, relationshipsContext)? = relationshipsNode else {
			XCTFail("Expected Object node for relationships")
			return
		}

		XCTAssertEqual(contextB, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(relationshipsContext.minProperties, 3)
		XCTAssertEqual(Set(relationshipsContext.requiredProperties), Set(["toOne", "nullableToOne", "toMany"]))
		XCTAssertEqual(Set(relationshipsContext.properties.keys), Set(["toOne", "optionalTooOne", "nullableToOne", "nullableOptionalToOne", "toMany", "optionalToMany"]))

		let pointerDataContext = JSONNode.ObjectContext(properties: ["id": .string(.init(format: .generic,
																						 required: true),
																				   .init()),
																	 "type": .string(.init(format: .generic,
																						   required: true,
																						   allowedValues: [.init(TestType1.jsonType)]),
																					 .init())])

		let pointerContext = JSONNode.ObjectContext(properties: ["data": .object(.init(format: .generic,
																					   required: true),
																				 pointerDataContext)])

		let nullablePointerContext = JSONNode.ObjectContext(properties: ["data": .object(.init(format: .generic,
																							   required: true,
																							   nullable: true),
																						 pointerDataContext)])

		let manyPointerContext = JSONNode.ObjectContext(properties: ["data": .array(.init(format: .generic,
																						  required: true),
																					.init(items: .object(.init(format: .generic,
																											   required: true),
																										 pointerDataContext)))])

		XCTAssertEqual(relationshipsContext.properties["toOne"],
					   .object(.init(format: .generic,
									 required: true),
							   pointerContext))

		XCTAssertEqual(relationshipsContext.properties["optionalTooOne"],
					   .object(.init(format: .generic,
									 required: false,
									 nullable: false,
									 allowedValues: nil),
							   pointerContext))

		XCTAssertEqual(relationshipsContext.properties["nullableToOne"],
					   .object(.init(format: .generic,
									 required: true,
									 nullable: false,
									 allowedValues: nil),
							   nullablePointerContext))

		XCTAssertEqual(relationshipsContext.properties["nullableOptionalToOne"],
					   .object(.init(format: .generic,
									 required: false,
									 nullable: false,
									 allowedValues: nil),
							   nullablePointerContext))

		XCTAssertEqual(relationshipsContext.properties["toMany"],
					   .object(.init(format: .generic,
									 required: true),
							   manyPointerContext))

		XCTAssertEqual(relationshipsContext.properties["optionalToMany"],
					   .object(.init(format: .generic,
									 required: false,
									 nullable: false,
									 allowedValues: nil),
							   manyPointerContext))
	}

	func test_AttributesAndRelationshipsEntity() {
		// TODO: write test

		/*

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let string = String(data: try! encoder.encode(node), encoding: .utf8)!
		print(string)

		*/
	}
}

// MARK: Test Types
extension JSONAPIEntityOpenAPITests {
	enum TestType1Description: EntityDescription {
		public static var jsonType: String { return "test1" }

		public typealias Attributes = NoAttributes

		public typealias Relationships = NoRelationships
	}

	typealias TestType1 = BasicEntity<TestType1Description>
	typealias UnidentifiedTestType1 = JSONAPI.Entity<TestType1Description, NoMetadata, NoLinks, Unidentified>

	enum TestType2Description: EntityDescription {
		public static var jsonType: String { return "test2" }

		public enum EnumType: String, CaseIterable, Codable, Equatable {
			case one
			case two
		}

		public struct Attributes: JSONAPI.Attributes, Sampleable {
			let stringProperty: Attribute<String>
			let enumProperty: Attribute<EnumType>
			let dateProperty: Attribute<Date>
			let optionalProperty: Attribute<String>?
			let nullableProperty: Attribute<String?>
			let nullableOptionalProperty: Attribute<String?>?
			var computedProperty: Attribute<EnumType> {
				return enumProperty
			}

			public static var sample: Attributes {
				return Attributes(stringProperty: .init(value: "hello"),
								  enumProperty: .init(value: .one),
								  dateProperty: .init(value: Date()),
								  optionalProperty: nil,
								  nullableProperty: .init(value: nil),
								  nullableOptionalProperty: nil)
			}
		}

		public typealias Relationships = NoRelationships
	}

	typealias TestType2 = BasicEntity<TestType2Description>

	enum TestType3Description: EntityDescription {
		public static var jsonType: String { return "test3" }

		public typealias Attributes = NoAttributes

		public struct Relationships: JSONAPI.Relationships, Sampleable {
			public let toOne: ToOneRelationship<TestType1, NoMetadata, NoLinks>
			public let optionalTooOne: ToOneRelationship<TestType1, NoMetadata, NoLinks>?
			public let nullableToOne: ToOneRelationship<TestType1?, NoMetadata, NoLinks>
			public let nullableOptionalToOne: ToOneRelationship<TestType1?, NoMetadata, NoLinks>?

			public let toMany: ToManyRelationship<TestType1, NoMetadata, NoLinks>
			public let optionalToMany: ToManyRelationship<TestType1, NoMetadata, NoLinks>?
			// Note there is no such thing as nullable to-many relationships (Just use
			// an empty array)

			public static var sample: Relationships {
				return Relationships(toOne: .init(id: .init(rawValue: "1")),
									 optionalTooOne: nil,
									 nullableToOne: .init(id: nil),
									 nullableOptionalToOne: nil,
									 toMany: .init(ids: [.init(rawValue: "1")]),
									 optionalToMany: nil)
			}
		}
	}

	typealias TestType3 = BasicEntity<TestType3Description>
}
