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

		print(String(data: try! encoder.encode(node), encoding: .utf8)!)
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
