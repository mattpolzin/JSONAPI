//
//  JSONAPIDocumentOpenAPITests.swift
//  JSONAPIOpenAPITests
//
//  Created by Mathew Polzin on 1/21/19.
//

import XCTest
import JSONAPI
import JSONAPIOpenAPI

class JSONAPIDocumentOpenAPITests: XCTestCase {
	func test_SingleResourceDocument() {
		let node = try! SingleEntityDocument.openAPINode()

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		print(String(data: try! encoder.encode(node), encoding: .utf8)!)
	}
}

// MARK: - Test Types
extension JSONAPIDocumentOpenAPITests {
	enum TestEntityDescription: EntityDescription {
		static var jsonType: String { return "test" }

		struct Attributes: JSONAPI.Attributes, Sampleable {
			let name: Attribute<String>

			static var sample: Attributes {
				return .init(name: "hello world")
			}
		}

		typealias Relationships = NoRelationships
	}

	typealias TestEntity = BasicEntity<TestEntityDescription>

	typealias SingleEntityDocument = Document<SingleResourceBody<TestEntity>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>
}
