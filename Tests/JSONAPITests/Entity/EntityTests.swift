//
//  EntityTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 7/25/18.
//

import XCTest
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
		
		XCTAssertEqual((e ~> \.others).map { $0.rawValue }, ["364B3B69-4DF1-467F-B52E-B0C9E44F666E"])
	}
	
	func test_EntitySomeRelationshipsSomeAttributes() {
		let entity = try? JSONDecoder().decode(TestEntity4.self, from: entity_some_relationships_some_attributes)
		
		XCTAssertNotNil(entity)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.word], "coolio")
		XCTAssertEqual(e[\.number], 992299)
		XCTAssertEqual((e ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
	}
	
}

// MARK: Attribute omission and nullification
extension EntityTests {
	
	func test_entityOneOmittedAttribute() {
		let entity = try? JSONDecoder().decode(TestEntity6.self, from: entity_one_omitted_attribute)
		
		XCTAssertNotNil(entity)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.here], "Hello")
		XCTAssertNil(e[\.maybeHere])
		XCTAssertEqual(e[\.maybeNull], "World")
	}
	
	func test_entityOneNullAttribute() {
		let entity = try? JSONDecoder().decode(TestEntity6.self, from: entity_one_null_attribute)
		
		XCTAssertNotNil(entity)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.here], "Hello")
		XCTAssertEqual(e[\.maybeHere], "World")
		XCTAssertNil(e[\.maybeNull])
	}
	
	func test_entityAllAttribute() {
		let entity = try? JSONDecoder().decode(TestEntity6.self, from: entity_all_attributes)
		
		XCTAssertNotNil(entity)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.here], "Hello")
		XCTAssertEqual(e[\.maybeHere], "World")
		XCTAssertEqual(e[\.maybeNull], "!")
	}
	
	func test_entityOneNullAndOneOmittedAttribute() {
		let entity = try? JSONDecoder().decode(TestEntity6.self, from: entity_one_null_and_one_missing_attribute)
		
		XCTAssertNotNil(entity)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.here], "Hello")
		XCTAssertNil(e[\.maybeHere])
		XCTAssertNil(e[\.maybeNull])
	}
	
	func test_entityBrokenNullableOmittedAttribute() {
		let entity = try? JSONDecoder().decode(TestEntity6.self, from: entity_broken_missing_nullable_attribute)
		
		XCTAssertNil(entity)
	}
	
	func test_NullOptionalNullableAttribute() {
		let entity = try? JSONDecoder().decode(TestEntity7.self, from: entity_null_optional_nullable_attribute)
		
		XCTAssertNotNil(entity)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.here], "Hello")
		XCTAssertNil(e[\.maybeHereMaybeNull])
	}
	
	func test_NonNullOptionalNullableAttribute() {
		let entity = try? JSONDecoder().decode(TestEntity7.self, from: entity_non_null_optional_nullable_attribute)
		
		XCTAssertNotNil(entity)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.here], "Hello")
		XCTAssertEqual(e[\.maybeHereMaybeNull], "World")
	}
}

// MARK: Attribute Transformation

extension EntityTests {
	func test_IntToString() {
		let entity = try? JSONDecoder().decode(TestEntity8.self, from: entity_int_to_string_attribute)
		
		XCTAssertNotNil(entity)
		
		guard let e = entity else { return }
		
		XCTAssertEqual(e[\.string], "22")
		XCTAssertEqual(e[\.int], 22)
		XCTAssertEqual(e[\.stringFromInt], "22")
		XCTAssertEqual(e[\.plus], 122)
		XCTAssertEqual(e[\.doubleFromInt], 22.0)
		XCTAssertEqual(e[\.nullToString], "nil")
	}
}

// MARK: Test Types
extension EntityTests {

	enum TestEntityType1: EntityDescription {
		static var type: String { return "test_entities"}
		
		typealias Identifier = Id<String, TestEntityType1>
		typealias Attributes = NoAttributes
		typealias Relationships = NoRelatives
	}
	
	typealias TestEntity1 = Entity<TestEntityType1>
	
	enum TestEntityType2: EntityDescription {
		static var type: String { return "second_test_entities"}
		
		typealias Identifier = Id<String, TestEntityType2>
		typealias Attributes = NoAttributes
		
		struct Relationships: JSONAPI.Relationships {
			let other: ToOneRelationship<TestEntityType1>
		}
	}
	
	typealias TestEntity2 = Entity<TestEntityType2>
	
	enum TestEntityType3: EntityDescription {
		static var type: String { return "third_test_entities"}
		
		typealias Identifier = Id<String, TestEntityType3>
		typealias Attributes = NoAttributes
		
		struct Relationships: JSONAPI.Relationships {
			let others: ToManyRelationship<TestEntityType1>
		}
	}

	typealias TestEntity3 = Entity<TestEntityType3>
	
	enum TestEntityType4: EntityDescription {
		static var type: String { return "fourth_test_entities"}
		
		typealias Identifier = Id<String, TestEntityType4>
		
		struct Relationships: JSONAPI.Relationships {
			let other: ToOneRelationship<TestEntityType2>
		}
		
		struct Attributes: JSONAPI.Attributes {
			let word: Attribute<String>
			let number: Attribute<Int>
			let array: Attribute<[Double]>
		}
	}
	
	typealias TestEntity4 = Entity<TestEntityType4>
	
	enum TestEntityType5: EntityDescription {
		static var type: String { return "fifth_test_entities"}
		
		typealias Identifier = Id<String, TestEntityType5>
		typealias Relationships = NoRelatives
		
		struct Attributes: JSONAPI.Attributes {
			let floater: Attribute<Double>
		}
	}
	
	typealias TestEntity5 = Entity<TestEntityType5>
	
	enum TestEntityType6: EntityDescription {
		static var type: String { return "sixth_test_entities" }
		
		typealias Identifier = Id<String, TestEntityType6>
		typealias Relationships = NoRelatives
		
		struct Attributes: JSONAPI.Attributes {
			let here: Attribute<String>
			let maybeHere: Attribute<String>?
			let maybeNull: Attribute<String?>
		}
	}
	
	typealias TestEntity6 = Entity<TestEntityType6>
	
	enum TestEntityType7: EntityDescription {
		static var type: String { return "seventh_test_entities" }
		
		typealias Identifier = Id<String, TestEntityType7>
		typealias Relationships = NoRelatives
		
		struct Attributes: JSONAPI.Attributes {
			let here: Attribute<String>
			let maybeHereMaybeNull: Attribute<String?>?
		}
	}
	
	typealias TestEntity7 = Entity<TestEntityType7>
	
	enum TestEntityType8: EntityDescription {
		static var type: String { return "eighth_test_entities" }
		
		typealias Identifier = Id<String, TestEntityType8>
		typealias Relationships = NoRelatives
		
		struct Attributes: JSONAPI.Attributes {
			let string: Attribute<String>
			let int: Attribute<Int>
			let stringFromInt: TransformAttribute<Int, IntToString>
			let plus: TransformAttribute<Int, IntPlusOneHundred>
			let doubleFromInt: TransformAttribute<Int, IntToDouble>
			let omitted: TransformAttribute<Int, IntToString>?
			let nullToString: TransformAttribute<Int?, OptionalToString<Int>>
		}
	}
	
	typealias TestEntity8 = Entity<TestEntityType8>
	
	enum IntToString: Transformer {
		public static func transform(_ from: Int) -> String {
			return String(from)
		}
	}
	
	enum IntPlusOneHundred: Transformer {
		public static func transform(_ from: Int) -> Int {
			return from + 100
		}
	}
	
	enum IntToDouble: Transformer {
		public static func transform(_ from: Int) -> Double {
			return Double(from)
		}
	}
	
	enum OptionalToString<T>: Transformer {
		public static func transform(_ from: T?) -> String {
			return String(describing: from)
		}
	}
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
