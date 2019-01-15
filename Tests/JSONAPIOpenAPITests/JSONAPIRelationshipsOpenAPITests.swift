//
//  JSONAPIRelationshipsOpenAPITests.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 1/14/19.
//

import Foundation
import XCTest
import JSONAPI
import JSONAPITesting
import JSONAPIOpenAPI

class JSONAPIRelationshipsOpenAPITests: XCTestCase {

	func test_ToOne() {
		let node = ToOneRelationship<TestEntity1?, NoMetadata, NoLinks>.openAPINode

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		print(String(data: (try? encoder.encode(node))!, encoding: .utf8)!)
	}
}

// MARK: Test Types
extension JSONAPIRelationshipsOpenAPITests {
	enum TestEntityType1: EntityDescription {
		static var jsonType: String { return "test_entities"}

		typealias Attributes = NoAttributes
		typealias Relationships = NoRelationships
	}

	typealias TestEntity1 = BasicEntity<TestEntityType1>

	enum TestEntityType2: EntityDescription {
		static var jsonType: String { return "second_test_entities"}

		typealias Attributes = NoAttributes

		struct Relationships: JSONAPI.Relationships {
			let other: ToOneRelationship<TestEntity1, NoMetadata, NoLinks>
		}
	}

	typealias TestEntity2 = BasicEntity<TestEntityType2>
}
