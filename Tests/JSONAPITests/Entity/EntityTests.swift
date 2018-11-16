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
}

// MARK: - Encode/Decode
extension EntityTests {

	func test_EntityNoRelationshipsNoAttributes() {
		let entity = decodedTestType(type: TestEntity1.self,
								  data: entity_no_relationships_no_attributes)

		XCTAssert(type(of: entity.relationships) == NoRelatives.self)
		XCTAssert(type(of: entity.attributes) == NoAttributes.self)
	}

	func test_EntityNoRelationshipsNoAttributes_encode() {
		test_DecodeEncodeEquality(type: TestEntity1.self,
								   data: entity_no_relationships_no_attributes)
	}

	func test_EntityNoRelationshipsSomeAttributes() {
		let entity = decodedTestType(type: TestEntity5.self,
								   data: entity_no_relationships_some_attributes)

		XCTAssert(type(of: entity.relationships) == NoRelatives.self)

		XCTAssertEqual(entity[\.floater], 123.321)
	}

	func test_EntityNoRelationshipsSomeAttributes_encode() {
		test_DecodeEncodeEquality(type: TestEntity5.self,
								   data: entity_no_relationships_some_attributes)
	}

	func test_EntitySomeRelationshipsNoAttributes() {
		let entity = decodedTestType(type: TestEntity3.self,
								   data: entity_some_relationships_no_attributes)

		XCTAssert(type(of: entity.attributes) == NoAttributes.self)
		
		XCTAssertEqual((entity ~> \.others).map { $0.rawValue }, ["364B3B69-4DF1-467F-B52E-B0C9E44F666E"])
	}

	func test_EntitySomeRelationshipsNoAttributes_encode() {
		test_DecodeEncodeEquality(type: TestEntity3.self,
								  data: entity_some_relationships_no_attributes)
	}
	
	func test_EntitySomeRelationshipsSomeAttributes() {
		let entity = decodedTestType(type: TestEntity4.self,
								   data: entity_some_relationships_some_attributes)
		
		XCTAssertEqual(entity[\.word], "coolio")
		XCTAssertEqual(entity[\.number], 992299)
		XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
	}

	func test_EntitySomeRelationshipsSomeAttributes_encode() {
		test_DecodeEncodeEquality(type: TestEntity4.self,
								   data: entity_some_relationships_some_attributes)
	}
}

// MARK: Attribute omission and nullification
extension EntityTests {
	
	func test_entityOneOmittedAttribute() {
		let entity = decodedTestType(type: TestEntity6.self,
								   data: entity_one_omitted_attribute)
		
		XCTAssertEqual(entity[\.here], "Hello")
		XCTAssertNil(entity[\.maybeHere])
		XCTAssertEqual(entity[\.maybeNull], "World")
	}

	func test_entityOneOmittedAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity6.self,
								   data: entity_one_omitted_attribute)
	}
	
	func test_entityOneNullAttribute() {
		let entity = decodedTestType(type: TestEntity6.self,
								   data: entity_one_null_attribute)
		
		XCTAssertEqual(entity[\.here], "Hello")
		XCTAssertEqual(entity[\.maybeHere], "World")
		XCTAssertNil(entity[\.maybeNull])
	}

	func test_entityOneNullAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity6.self,
								   data: entity_one_null_attribute)
	}
	
	func test_entityAllAttribute() {
		let entity = decodedTestType(type: TestEntity6.self,
								   data: entity_all_attributes)
		
		XCTAssertEqual(entity[\.here], "Hello")
		XCTAssertEqual(entity[\.maybeHere], "World")
		XCTAssertEqual(entity[\.maybeNull], "!")
	}

	func test_entityAllAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity6.self,
								   data: entity_all_attributes)
	}
	
	func test_entityOneNullAndOneOmittedAttribute() {
		let entity = decodedTestType(type: TestEntity6.self,
								   data: entity_one_null_and_one_missing_attribute)
		
		XCTAssertEqual(entity[\.here], "Hello")
		XCTAssertNil(entity[\.maybeHere])
		XCTAssertNil(entity[\.maybeNull])
	}

	func test_entityOneNullAndOneOmittedAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity6.self,
								   data: entity_one_null_and_one_missing_attribute)
	}
	
	func test_entityBrokenNullableOmittedAttribute() {
		XCTAssertThrowsError(try JSONDecoder().decode(TestEntity6.self,
								   from: entity_broken_missing_nullable_attribute))
	}
	
	func test_NullOptionalNullableAttribute() {
		let entity = decodedTestType(type: TestEntity7.self,
								   data: entity_null_optional_nullable_attribute)
		
		XCTAssertEqual(entity[\.here], "Hello")
		XCTAssertNil(entity[\.maybeHereMaybeNull])
	}

	func test_NullOptionalNullableAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity7.self,
								   data: entity_null_optional_nullable_attribute)
	}
	
	func test_NonNullOptionalNullableAttribute() {
		let entity = decodedTestType(type: TestEntity7.self,
								   data: entity_non_null_optional_nullable_attribute)

		XCTAssertEqual(entity[\.here], "Hello")
		XCTAssertEqual(entity[\.maybeHereMaybeNull], "World")
	}

	func test_NonNullOptionalNullableAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity7.self,
								   data: entity_non_null_optional_nullable_attribute)
	}
}

// MARK: Attribute Transformation
extension EntityTests {
	func test_IntToString() {
		let entity = decodedTestType(type: TestEntity8.self,
								   data: entity_int_to_string_attribute)
		
		XCTAssertEqual(entity[\.string], "22")
		XCTAssertEqual(entity[\.int], 22)
		XCTAssertEqual(entity[\.stringFromInt], "22")
		XCTAssertEqual(entity[\.plus], 122)
		XCTAssertEqual(entity[\.doubleFromInt], 22.0)
		XCTAssertEqual(entity[\.nullToString], "nil")
	}

	func test_IntToString_encode() {
		test_DecodeEncodeEquality(type: TestEntity8.self,
								   data: entity_int_to_string_attribute)
	}
}

// MARK: Relationship omission and nullification
extension EntityTests {
	func test_nullableRelationshipNotNull() {
		let entity = decodedTestType(type: TestEntity9.self,
								   data: entity_omitted_relationship)

		XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "3323")
		XCTAssertEqual((entity ~> \.one).rawValue, "4459")
	}

	func test_nullableRelationshipNotNull_encode() {
		test_DecodeEncodeEquality(type: TestEntity9.self,
								   data: entity_omitted_relationship)
	}

	func test_nullableRelationshipIsNull() {
		let entity = decodedTestType(type: TestEntity9.self,
								   data: entity_nulled_relationship)

		XCTAssertNil(entity ~> \.nullableOne)
		XCTAssertEqual((entity ~> \.one).rawValue, "4452")
	}

	func test_nullableRelationshipIsNull_encode() {
		test_DecodeEncodeEquality(type: TestEntity9.self,
								   data: entity_nulled_relationship)
	}
}

// MARK: Relationships of same type as root entity

extension EntityTests {
	func test_RleationshipsOfSameType() {
		let entity = decodedTestType(type: TestEntity10.self,
								   data: entity_self_ref_relationship)

		XCTAssertEqual((entity ~> \.selfRef).rawValue, "1")
	}

	func test_RleationshipsOfSameType_encode() {
		test_DecodeEncodeEquality(type: TestEntity10.self,
								   data: entity_self_ref_relationship)
	}
}

// MARK: Unidentified

extension EntityTests {
	func test_UnidentifiedEntity() {
		let entity = decodedTestType(type: UnidentifiedTestEntity.self,
								   data: entity_unidentified)

		XCTAssertNil(entity[\.me])
		XCTAssertEqual(entity.id, Unidentified())
	}

	func test_UnidentifiedEntity_encode() {
		test_DecodeEncodeEquality(type: UnidentifiedTestEntity.self,
								   data: entity_unidentified)
	}

	func test_UnidentifiedEntityWithAttributes() {
		let entity = decodedTestType(type: UnidentifiedTestEntity.self,
								   data: entity_unidentified_with_attributes)

		XCTAssertEqual(entity[\.me], "unknown")
		XCTAssertEqual(entity.id, Unidentified())
	}

	func test_UnidentifiedEntityWithAttributes_encode() {
		test_DecodeEncodeEquality(type: UnidentifiedTestEntity.self,
								   data: entity_unidentified_with_attributes)
	}
}

// MARK: - Test Types
extension EntityTests {

	enum TestEntityType1: EntityDescription {
		static var type: String { return "test_entities"}

		typealias Attributes = NoAttributes
		typealias Relationships = NoRelatives
	}

	typealias TestEntity1 = Entity<TestEntityType1>

	enum TestEntityType2: EntityDescription {
		static var type: String { return "second_test_entities"}

		typealias Attributes = NoAttributes
		
		struct Relationships: JSONAPI.Relationships {
			let other: ToOneRelationship<TestEntity1>
		}
	}

	typealias TestEntity2 = Entity<TestEntityType2>

	enum TestEntityType3: EntityDescription {
		static var type: String { return "third_test_entities"}

		typealias Attributes = NoAttributes
		
		struct Relationships: JSONAPI.Relationships {
			let others: ToManyRelationship<TestEntity1>
		}
	}

	typealias TestEntity3 = Entity<TestEntityType3>

	enum TestEntityType4: EntityDescription {
		static var type: String { return "fourth_test_entities"}

		struct Relationships: JSONAPI.Relationships {
			let other: ToOneRelationship<TestEntity2>
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

		typealias Relationships = NoRelatives

		struct Attributes: JSONAPI.Attributes {
			let floater: Attribute<Double>
		}
	}

	typealias TestEntity5 = Entity<TestEntityType5>

	enum TestEntityType6: EntityDescription {
		static var type: String { return "sixth_test_entities" }

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

		typealias Relationships = NoRelatives

		struct Attributes: JSONAPI.Attributes {
			let here: Attribute<String>
			let maybeHereMaybeNull: Attribute<String?>?
		}
	}

	typealias TestEntity7 = Entity<TestEntityType7>

	enum TestEntityType8: EntityDescription {
		static var type: String { return "eighth_test_entities" }

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

	enum TestEntityType9: EntityDescription {
		public static var type: String { return "ninth_test_entities" }

		typealias Attributes = NoAttributes

		public struct Relationships: JSONAPI.Relationships {
			let one: ToOneRelationship<TestEntity1>

			let nullableOne: ToOneRelationship<TestEntity1?>

			// a nullable many is not allowed. it should
			// just be an empty array.

			// omitted relationships are not allowed either,
			// so ToOneRelationship<TestEntity1>? (with the
			// question on the relationship, not the entity)
			// is not a thing.
		}
	}

	typealias TestEntity9 = Entity<TestEntityType9>

	enum TestEntityType10: EntityDescription {
		public static var type: String { return "tenth_test_entities" }

		typealias Attributes = NoAttributes

		public struct Relationships: JSONAPI.Relationships {
			let selfRef: ToOneRelationship<TestEntity10>
			let selfRefs: ToManyRelationship<TestEntity10>
		}
	}

	typealias TestEntity10 = Entity<TestEntityType10>

	enum UnidentifiedTestEntityType: EntityDescription {
		public static var type: String { return "unidentified_test_entities" }

		struct Attributes: JSONAPI.Attributes {
			let me: Attribute<String>?
		}

		typealias Relationships = NoRelatives
	}

	typealias UnidentifiedTestEntity = NewEntity<UnidentifiedTestEntityType>

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

extension Entity where Description == EntityTests.TestEntityType2, Identifier: CreatableIdType {
	init(other: ToOneRelationship<EntityTests.TestEntity1>) {
		self.init(relationships: .init(other: other))
	}
}

extension Entity where Description == EntityTests.TestEntityType3, Identifier: CreatableIdType {
	init(others: ToManyRelationship<EntityTests.TestEntity1>) {
		self.init(relationships: .init(others: others))
	}
}
