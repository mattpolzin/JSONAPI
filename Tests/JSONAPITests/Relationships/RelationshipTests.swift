//
//  RelationshipTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

import XCTest
import JSONAPI

class RelationshipTests: XCTestCase {

	func test_initToManyWithEntities() {
		let entity1 = TestEntity1()
		let entity2 = TestEntity1()
		let entity3 = TestEntity1()
		let entity4 = TestEntity1()
		let relationship = ToManyRelationship<TestEntity1, NoMetadata, NoLinks>(entities: [entity1, entity2, entity3, entity4])

		XCTAssertEqual(relationship.ids.count, 4)
		XCTAssertEqual(relationship.ids, [entity1, entity2, entity3, entity4].map { $0.id })
	}

	func test_initToManyWithRelationships() {
		let entity1 = TestEntity1()
		let entity2 = TestEntity1()
		let entity3 = TestEntity1()
		let entity4 = TestEntity1()
		let relationship = ToManyRelationship<TestEntity1, NoMetadata, NoLinks>(relationships: [entity1.pointer, entity2.pointer, entity3.pointer, entity4.pointer])

		XCTAssertEqual(relationship.ids.count, 4)
		XCTAssertEqual(relationship.ids, [entity1, entity2, entity3, entity4].map { $0.id })
	}
}

// MARK: - Encode/Decode
extension RelationshipTests {
	func test_ToOneRelationship() {
		let relationship = decoded(type: ToOneRelationship<TestEntity1, NoMetadata, NoLinks>.self,
								   data: to_one_relationship)

		XCTAssertEqual(relationship.id.rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
	}

	func test_ToOneRelationship_encode() {
		test_DecodeEncodeEquality(type: ToOneRelationship<TestEntity1, NoMetadata, NoLinks>.self,
								   data: to_one_relationship)
	}

	func test_ToManyRelationship() {
		let relationship = decoded(type: ToManyRelationship<TestEntity1, NoMetadata, NoLinks>.self,
								   data: to_many_relationship)

		XCTAssertEqual(relationship.ids.map { $0.rawValue }, ["2DF03B69-4B0A-467F-B52E-B0C9E44FCECF", "90F03B69-4DF1-467F-B52E-B0C9E44FC333", "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"])
	}

	func test_ToManyRelationship_encode() {
		test_DecodeEncodeEquality(type: ToManyRelationship<TestEntity1, NoMetadata, NoLinks>.self,
								   data: to_many_relationship)
	}
}

// MARK: Failure tests
extension RelationshipTests {
	func test_ToManyTypeMismatch() {
		XCTAssertThrowsError(try JSONDecoder().decode(ToManyRelationship<TestEntity1, NoMetadata, NoLinks>.self, from: to_many_relationship_type_mismatch))
	}

	func test_ToOneTypeMismatch() {
		XCTAssertThrowsError(try JSONDecoder().decode(ToOneRelationship<TestEntity1, NoMetadata, NoLinks>.self, from: to_one_relationship_type_mismatch))
	}
}

// MARK: - Test types
extension RelationshipTests {
	enum TestEntityType1: EntityDescription {
		typealias Attributes = NoAttributes

		typealias Relationships = NoRelationships

		public static var type: String { return "test_entity1" }
	}

	typealias TestEntity1 = BasicEntity<TestEntityType1>
}
