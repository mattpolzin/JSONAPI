//
//  JSONAPIDocumentOpenAPITests.swift
//  JSONAPIOpenAPITests
//
//  Created by Mathew Polzin on 1/21/19.
//

import XCTest
import SwiftCheck
import JSONAPI
import JSONAPIOpenAPI
import Sampleable

class JSONAPIDocumentOpenAPITests: XCTestCase {
	func test_SingleResourceDocument() {

		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale(identifier: "en_US")

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .formatted(dateFormatter)

		let node = try! SingleEntityDocument.openAPINodeWithExample(using: encoder)

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .object(.generic))

		guard case let .object(contextA, objectContext1) = node else {
			XCTFail("Expected JSON Document to be an Object Node")
			return
		}

		XCTAssertNotNil(contextA.example)
		XCTAssertFalse(contextA.nullable)
		XCTAssertEqual(contextA.format, .generic)
		XCTAssertTrue(contextA.required)

		XCTAssertEqual(objectContext1.minProperties, 1)
		XCTAssertEqual(Set(objectContext1.requiredProperties), Set(["data"]))
		XCTAssertEqual(Set(objectContext1.properties.keys), Set(["data"]))

		guard case let .object(contextB, objectContext2)? = objectContext1.properties["data"] else {
			XCTFail("Expected Data field of JSON Document to be an Object Node")
			return
		}

		XCTAssertFalse(contextB.nullable)
		XCTAssertEqual(contextB.format, .generic)
		XCTAssertTrue(contextB.required)

		XCTAssertEqual(objectContext2.minProperties, 3)
		XCTAssertEqual(Set(objectContext2.requiredProperties), Set(["id", "attributes", "type"]))
		XCTAssertEqual(Set(objectContext2.properties.keys), Set(["id", "attributes", "type"]))

		XCTAssertEqual(objectContext2.properties["type"],
					   JSONNode.string(.init(format: .generic,
											 required: true,
											 allowedValues: [.init("test")]),
									   .init()))
	}

	func test_ManyResourceDocument() {

		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale(identifier: "en_US")

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .formatted(dateFormatter)

		let node = try! ManyEntityDocument.openAPINodeWithExample(using: encoder)

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .object(.generic))

		guard case let .object(contextA, objectContext1) = node else {
			XCTFail("Expected JSON Document to be an Object Node")
			return
		}

		XCTAssertNotNil(contextA.example)
		XCTAssertFalse(contextA.nullable)
		XCTAssertEqual(contextA.format, .generic)
		XCTAssertTrue(contextA.required)

		XCTAssertEqual(objectContext1.minProperties, 1)
		XCTAssertEqual(Set(objectContext1.requiredProperties), Set(["data"]))
		XCTAssertEqual(Set(objectContext1.properties.keys), Set(["data"]))

		guard case let .array(contextB, arrayContext)? = objectContext1.properties["data"] else {
			XCTFail("Expected Data field of JSON Document to be an Array Node")
			return
		}

		XCTAssertFalse(contextB.nullable)
		XCTAssertEqual(contextB.format, .generic)
		XCTAssertTrue(contextB.required)

		XCTAssertFalse(arrayContext.uniqueItems)
		XCTAssertEqual(arrayContext.minItems, 0)

		guard case let .object(contextC, objectContext2) = arrayContext.items else {
			XCTFail("Expected Items of Array under Data to be an Object Node")
			return
		}

		XCTAssertFalse(contextC.nullable)
		XCTAssertEqual(contextC.format, .generic)
		XCTAssertTrue(contextC.required)

		XCTAssertEqual(objectContext2.minProperties, 3)
		XCTAssertEqual(Set(objectContext2.requiredProperties), Set(["id", "attributes", "type"]))
		XCTAssertEqual(Set(objectContext2.properties.keys), Set(["id", "attributes", "type"]))

		XCTAssertEqual(objectContext2.properties["type"],
					   JSONNode.string(.init(format: .generic,
											 required: true,
											 allowedValues: [.init("test")]),
									   .init()))
	}

	func test_DocumentWithOneIncludeType() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale(identifier: "en_US")

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .formatted(dateFormatter)

		let node = try! DocumentWithIncludes.openAPINodeWithExample(using: encoder)

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .object(.generic))

		guard case let .object(contextA, objectContext1) = node else {
			XCTFail("Expected JSON Document to be an Object Node")
			return
		}

		XCTAssertNotNil(contextA.example)
		XCTAssertFalse(contextA.nullable)
		XCTAssertEqual(contextA.format, .generic)
		XCTAssertTrue(contextA.required)

		XCTAssertEqual(objectContext1.minProperties, 2)
		XCTAssertEqual(Set(objectContext1.requiredProperties), Set(["data", "included"]))
		XCTAssertEqual(Set(objectContext1.properties.keys), Set(["data", "included"]))

		guard case let .object(contextB, objectContext2)? = objectContext1.properties["data"] else {
			XCTFail("Expected Data field of JSON Document to be an Object Node")
			return
		}

		XCTAssertFalse(contextB.nullable)
		XCTAssertEqual(contextB.format, .generic)
		XCTAssertTrue(contextB.required)

		XCTAssertEqual(objectContext2.minProperties, 3)
		XCTAssertEqual(Set(objectContext2.requiredProperties), Set(["id", "attributes", "type"]))
		XCTAssertEqual(Set(objectContext2.properties.keys), Set(["id", "attributes", "type"]))

		XCTAssertEqual(objectContext2.properties["type"],
					   JSONNode.string(.init(format: .generic,
											 required: true,
											 allowedValues: [.init("test")]),
									   .init()))

		guard case let .array(contextC, arrayContext)? = objectContext1.properties["included"] else {
			XCTFail("Expected Includes field of JSON Document to be an Array Node")
			return
		}

		XCTAssertFalse(contextC.nullable)
		XCTAssertEqual(contextC.format, .generic)
		XCTAssertTrue(contextC.required)

		XCTAssertTrue(arrayContext.uniqueItems)
		XCTAssertEqual(arrayContext.minItems, 0)

		guard case let .object(contextD, objectContext3) = arrayContext.items else {
			XCTFail("Expected Items of Array under Data to be an Object Node")
			return
		}

		XCTAssertFalse(contextD.nullable)
		XCTAssertEqual(contextD.format, .generic)
		XCTAssertTrue(contextD.required)

		XCTAssertEqual(objectContext3.minProperties, 3)
		XCTAssertEqual(Set(objectContext3.requiredProperties), Set(["id", "attributes", "type"]))
		XCTAssertEqual(Set(objectContext3.properties.keys), Set(["id", "attributes", "type"]))

		XCTAssertEqual(objectContext3.properties["type"],
					   JSONNode.string(.init(format: .generic,
											 required: true,
											 allowedValues: [.init("test")]),
									   .init()))
	}

	func test_DocumentWithTwoIncludeTypes() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale(identifier: "en_US")

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .formatted(dateFormatter)

		let node = try! DocumentWithMultipleTypesOfIncludes.openAPINodeWithExample(using: encoder)

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .object(.generic))

		guard case let .object(contextA, objectContext1) = node else {
			XCTFail("Expected JSON Document to be an Object Node")
			return
		}

		XCTAssertNotNil(contextA.example)
		XCTAssertFalse(contextA.nullable)
		XCTAssertEqual(contextA.format, .generic)
		XCTAssertTrue(contextA.required)

		XCTAssertEqual(objectContext1.minProperties, 2)
		XCTAssertEqual(Set(objectContext1.requiredProperties), Set(["data", "included"]))
		XCTAssertEqual(Set(objectContext1.properties.keys), Set(["data", "included"]))

		guard case let .object(contextB, objectContext2)? = objectContext1.properties["data"] else {
			XCTFail("Expected Data field of JSON Document to be an Object Node")
			return
		}

		XCTAssertFalse(contextB.nullable)
		XCTAssertEqual(contextB.format, .generic)
		XCTAssertTrue(contextB.required)

		XCTAssertEqual(objectContext2.minProperties, 3)
		XCTAssertEqual(Set(objectContext2.requiredProperties), Set(["id", "attributes", "type"]))
		XCTAssertEqual(Set(objectContext2.properties.keys), Set(["id", "attributes", "type"]))

		XCTAssertEqual(objectContext2.properties["type"],
					   JSONNode.string(.init(format: .generic,
											 required: true,
											 allowedValues: [.init("test")]),
									   .init()))

		guard case let .array(contextC, arrayContext)? = objectContext1.properties["included"] else {
			XCTFail("Expected Includes field of JSON Document to be an Array Node")
			return
		}

		XCTAssertFalse(contextC.nullable)
		XCTAssertEqual(contextC.format, .generic)
		XCTAssertTrue(contextC.required)

		XCTAssertTrue(arrayContext.uniqueItems)
		XCTAssertEqual(arrayContext.minItems, 0)

		guard case let .one(of: includeNodes) = arrayContext.items else {
			XCTFail("Expected Included to contain multiple types of items.")
			return
		}

		XCTAssertEqual(includeNodes.count, 2)

		guard case let .object(contextD, objectContext3) = includeNodes[0] else {
			XCTFail("Expected Items of OneOf under Array under Data to be an Object Node")
			return
		}

		XCTAssertFalse(contextD.nullable)
		XCTAssertEqual(contextD.format, .generic)
		XCTAssertTrue(contextD.required)

		XCTAssertEqual(objectContext3.minProperties, 3)
		XCTAssertEqual(Set(objectContext3.requiredProperties), Set(["id", "attributes", "type"]))
		XCTAssertEqual(Set(objectContext3.properties.keys), Set(["id", "attributes", "type"]))

		XCTAssertEqual(objectContext3.properties["type"],
					   JSONNode.string(.init(format: .generic,
											 required: true,
											 allowedValues: [.init("test")]),
									   .init()))

		guard case let .object(contextE, objectContext4) = includeNodes[1] else {
			XCTFail("Expected Items of OneOf under Array under Data to be an Object Node")
			return
		}

		XCTAssertFalse(contextE.nullable)
		XCTAssertEqual(contextE.format, .generic)
		XCTAssertTrue(contextE.required)

		XCTAssertEqual(objectContext4.minProperties, 2)
		XCTAssertEqual(Set(objectContext4.requiredProperties), Set(["id", "type"]))
		XCTAssertEqual(Set(objectContext4.properties.keys), Set(["id", "type"]))

		XCTAssertEqual(objectContext4.properties["type"],
					   JSONNode.string(.init(format: .generic,
											 required: true,
											 allowedValues: [.init("test2")]),
									   .init()))
	}
}

// MARK: - Test Types
extension JSONAPIDocumentOpenAPITests {
	enum TestEntityDescription: EntityDescription {
		static var jsonType: String { return "test" }

		struct Attributes: JSONAPI.Attributes, Sampleable {
			let name: Attribute<String>
			let date: Attribute<Date>

			static var sample: Attributes {
				return .init(name: "hello world",
							 date: .init(value: Date()))
			}
		}

		typealias Relationships = NoRelationships
	}

	typealias TestEntity = BasicEntity<TestEntityDescription>

	typealias SingleEntityDocument = Document<SingleResourceBody<TestEntity>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>

	typealias ManyEntityDocument = Document<ManyResourceBody<TestEntity>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>

	typealias DocumentWithIncludes = Document<SingleResourceBody<TestEntity>, NoMetadata, NoLinks, Include1<TestEntity>, NoAPIDescription, UnknownJSONAPIError>

	enum TestEntityDescription2: EntityDescription {
		static var jsonType: String { return "test2" }

		typealias Attributes = NoAttributes

		typealias Relationships = NoRelationships
	}

	typealias TestEntity2 = BasicEntity<TestEntityDescription2>

	typealias DocumentWithMultipleTypesOfIncludes = Document<SingleResourceBody<TestEntity>, NoMetadata, NoLinks, Include2<TestEntity, TestEntity2>, NoAPIDescription, UnknownJSONAPIError>
}

extension Id: Sampleable where RawType == String {
	public static var sample: Id<RawType, IdentifiableType> {
		return .init(rawValue: String.arbitrary.generate)
	}
}

extension JSONAPI.Entity: Sampleable where Description.Attributes: Sampleable, Description.Relationships: Sampleable, MetaType: Sampleable, LinksType: Sampleable, EntityRawIdType == String {
	public static var sample: JSONAPI.Entity<Description, MetaType, LinksType, EntityRawIdType> {
		return JSONAPI.Entity(id: .sample,
							  attributes: .sample,
							  relationships: .sample,
							  meta: .sample,
							  links: .sample)
	}
}

extension Document: Sampleable where PrimaryResourceBody: Sampleable, MetaType: Sampleable, LinksType: Sampleable, IncludeType: Sampleable, APIDescription: Sampleable, Error: Sampleable {
	public static var sample: Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error> {
		return Document(apiDescription: .sample,
						body: .sample,
						includes: .sample,
						meta: .sample,
						links: .sample)
	}
}
