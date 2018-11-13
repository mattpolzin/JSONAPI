//
//  EntityTests.swift
//  ElevatedCoreTests
//
//  Created by Mathew Polzin on 7/25/18.
//

import XCTest
import Foundation
import JSONAPI

class EntityTests: XCTestCase {
	
	func test_relationship_access() {
		let entity1 = TestEntity1()
		let entity2 = TestEntity2(other: entity1.pointer)
		
		XCTAssertEqual(entity2.relationships.other, entity1.pointer)
	}
	
	func test_relationship_operator_access() {
		let entity1 = TestEntity1()
		let entity2 = TestEntity2(other: entity1.pointer)

		XCTAssertEqual(entity2 ~> \.other, entity1.id)
	}
	
	func test_toMany_relationship_operator_access() {
		let entity1 = TestEntity1()
		let entity2 = TestEntity1()
		let entity4 = TestEntity1()
		let entity3 = TestEntity3(others: .init(relationships: [entity1.pointer, entity2.pointer, entity4.pointer]))
		
		XCTAssertEqual(entity3 ~> \.others, [entity1.id, entity2.id, entity4.id])
	}
	
	func test_relationshipIds() {
		let entity1 = TestEntity1()
		let entity2 = TestEntity2(other: entity1.pointer)
		
		XCTAssertEqual(entity2.relationships.other.ids, [entity1.id])
	}
	
	func test_EntityNoRelationshipsNoAttributes() {
		let entity = try? JSONDecoder().decode(TestEntity1.self, from: entity_no_relationships_no_attributes)
		
		XCTAssertNotNil(entity)
		XCTAssert(type(of: entity?.relationships) == NoRelatives?.self)
		XCTAssert(type(of: entity?.attributes) == NoAttributes?.self)
	}
	
	func test_EntityNoRelationshipsSomeAttributes() {
		let entity = try? JSONDecoder().decode(TestEntity5.self, from: entity_no_relationships_some_attributes)
		
		XCTAssertNotNil(entity)
		XCTAssert(type(of: entity?.relationships) == NoRelatives?.self)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.floater], 123.321)
	}
	
	func test_EntitySomeRelationshipsNoAttributes() {
		let entity = try? JSONDecoder().decode(TestEntity3.self, from: entity_some_relationships_no_attributes)
		
		XCTAssertNotNil(entity)
		XCTAssert(type(of: entity?.attributes) == NoAttributes?.self)
		
		guard let e = entity else { return }
		
		XCTAssertEqual((e ~> \.others).map { $0.rawValue.uuidString }, ["364B3B69-4DF1-467F-B52E-B0C9E44F666E"])
	}
	
	func test_EntitySomeRelationshipsSomeAttributes() {
		let entity = try? JSONDecoder().decode(TestEntity4.self, from: entity_some_relationships_some_attributes)
		
		XCTAssertNotNil(entity)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.word], "coolio")
		XCTAssertEqual(e[\.number], 992299)
		XCTAssertEqual((e ~> \.other).rawValue.uuidString, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
	}

	enum TestEntityType1: EntityType {
		static var type: String { return "test_entities"}
		
		typealias Identifier = Id<UUID, TestEntityType1>
		typealias AttributeType = NoAttributes
		typealias RelatedType = NoRelatives
	}
	
	typealias TestEntity1 = Entity<TestEntityType1>
	
	enum TestEntityType2: EntityType {
		static var type: String { return "second_test_entities"}
		
		typealias Identifier = Id<UUID, TestEntityType2>
		typealias RelatedType = Relationships
		typealias AttributeType = NoAttributes
		
		struct Relationships: Relatives {
			let other: ToOneRelationship<TestEntityType1>
		}
	}
	
	typealias TestEntity2 = Entity<TestEntityType2>
	
	enum TestEntityType3: EntityType {
		static var type: String { return "third_test_entities"}
		
		typealias Identifier = Id<UUID, TestEntityType3>
		typealias RelatedType = Relationships
		typealias AttributeType = NoAttributes
		
		struct Relationships: Relatives {
			let others: ToManyRelationship<TestEntityType1>
		}
	}

	typealias TestEntity3 = Entity<TestEntityType3>
	
	enum TestEntityType4: EntityType {
		static var type: String { return "fourth_test_entities"}
		
		typealias Identifier = Id<UUID, TestEntityType4>
		typealias RelatedType = Relationships
		typealias AttributeType = Atts
		
		struct Relationships: Relatives {
			let other: ToOneRelationship<TestEntityType2>
		}
		
		struct Atts: Attributes {
			let word: String
			let number: Int
		}
	}
	
	typealias TestEntity4 = Entity<TestEntityType4>
	
	enum TestEntityType5: EntityType {
		static var type: String { return "fifth_test_entities"}
		
		typealias Identifier = Id<UUID, TestEntityType5>
		typealias RelatedType = NoRelatives
		typealias AttributeType = Atts
		
		struct Atts: Attributes {
			let floater: Double
		}
	}
	
	typealias TestEntity5 = Entity<TestEntityType5>
}

extension Entity where EntityType == EntityTests.TestEntityType2 {
	init(other: ToOneRelationship<EntityTests.TestEntityType1>) {
		self.init(relationships: .init(other: other))
	}
}

extension Entity where EntityType == EntityTests.TestEntityType3 {
	init(others: ToManyRelationship<EntityTests.TestEntityType1>) {
		self.init(relationships: .init(others: others))
	}
}
