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
		let relationship = ToManyRelationship<TestEntityType1>(entities: [entity1, entity2, entity3, entity4])
		
		XCTAssertEqual(relationship.ids.count, 4)
		XCTAssertEqual(relationship.ids, [entity1, entity2, entity3, entity4].map { $0.id })
	}
	
	func test_initToManyWithRelationships() {
		let entity1 = TestEntity1()
		let entity2 = TestEntity1()
		let entity3 = TestEntity1()
		let entity4 = TestEntity1()
		let relationship = ToManyRelationship<TestEntityType1>(relationships: [entity1.pointer, entity2.pointer, entity3.pointer, entity4.pointer])
		
		XCTAssertEqual(relationship.ids.count, 4)
		XCTAssertEqual(relationship.ids, [entity1, entity2, entity3, entity4].map { $0.id })
	}
	
	func test_ToOneRelationship() {
		let relationship = try? JSONDecoder().decode(ToOneRelationship<TestEntityType1>.self, from: to_one_relationship)
		
		XCTAssertNotNil(relationship)
		
		XCTAssertEqual(relationship?.id.rawValue.uuidString, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
		XCTAssertEqual(relationship?.ids.count, 1)
	}
	
	func test_ToManyRelationship() {
		let relationship = try? JSONDecoder().decode(ToManyRelationship<TestEntityType1>.self, from: to_many_relationship)
		
		XCTAssertNotNil(relationship)
		
		XCTAssertEqual(relationship?.ids.map { $0.rawValue.uuidString }, ["2DF03B69-4B0A-467F-B52E-B0C9E44FCECF", "90F03B69-4DF1-467F-B52E-B0C9E44FC333", "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"])
	}
	
	enum TestEntityType1: EntityType {
		typealias Identifier = Id<UUID, TestEntityType1>
		
		typealias AttributeType = NoAttributes
		
		typealias RelatedType = NoRelatives
		
		public static var type: String { return "test_entity1" }
	}
	
	typealias TestEntity1 = Entity<TestEntityType1>
}
