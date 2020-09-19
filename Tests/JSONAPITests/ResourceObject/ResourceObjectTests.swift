//
//  ResourceObjectTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 7/25/18.
//

import XCTest
import JSONAPI
import JSONAPITesting

class ResourceObjectTests: XCTestCase {

	func test_relationship_access() {
		let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity2 = TestEntity2(attributes: .none, relationships: .init(other: entity1.pointer), meta: .none, links: .none)

		XCTAssertEqual(entity2.relationships.other, entity1.pointer)
	}

	func test_relationship_operator_access() {
		let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity2 = TestEntity2(attributes: .none, relationships: .init(other: entity1.pointer), meta: .none, links: .none)

		XCTAssertEqual(entity2 ~> \.other, entity1.id)
	}

	func test_optional_relationship_operator_access() {
		let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity = TestEntity9(attributes: .none, relationships: .init(meta: .init(meta: .init(x: "hello", y: 5), links: .none), optionalMeta: nil, one: entity1.pointer, nullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalNullableOne: nil, optionalMany: .init(resourceObjects: [entity1, entity1], meta: .none, links: .none)), meta: .none, links: .none)

		XCTAssertEqual(entity ~> \.optionalOne, Optional(entity1.id))
		XCTAssertEqual((entity ~> \.optionalOne).rawValue, Optional(entity1.id.rawValue))
	}

	func test_toMany_relationship_operator_access() {
		let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity2 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity4 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity3 = TestEntity3(attributes: .none, relationships: .init(others: .init(pointers: [entity1.pointer, entity2.pointer, entity4.pointer])), meta: .none, links: .none)

		XCTAssertEqual(entity3 ~> \.others, [entity1.id, entity2.id, entity4.id])
	}

	func test_optionalToMany_relationship_opeartor_access() {
		let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity = TestEntity9(attributes: .none, relationships: .init(meta: .init(meta: .init(x: "hello", y: 5), links: .none), optionalMeta: nil, one: entity1.pointer, nullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalOne: nil, optionalNullableOne: nil, optionalMany: .init(resourceObjects: [entity1, entity1], meta: .none, links: .none)), meta: .none, links: .none)

		XCTAssertEqual(entity ~> \.optionalMany, [entity1.id, entity1.id])
	}

	func test_relationshipIds() {
		let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity2 = TestEntity2(attributes: .none, relationships: .init(other: entity1.pointer), meta: .none, links: .none)

		XCTAssertEqual(entity2.relationships.other.id, entity1.id)
	}

	func test_pointerWithMetaAndLinks() {
		let entity = TestEntity4WithMetaAndLinks(attributes: .init(word: "hello", number: 10, array: []), relationships: .init(other: .init(id: "2")), meta: .init(x: "world", y: nil), links: .init(link1: .init(url: "ok")))

		let pointer = entity.pointer(withMeta: TestEntityMeta(x: "world", y: nil), links: TestEntityLinks(link1: .init(url: "ok")))

		XCTAssertEqual(pointer.id, entity.id)
		XCTAssertEqual(pointer.meta.x, "world")
		XCTAssertEqual(pointer.links.link1.url, "ok")
	}

	func test_unidentifiedEntityAttributeAccess() {
		let entity = UnidentifiedTestEntity(attributes: .init(me: "hello"), relationships: .none, meta: .none, links: .none)

        XCTAssertEqual(entity.me, "hello")
	}

	func test_initialization() {
		let entity1 = TestEntity1(id: .init(rawValue: "wow"), attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity2 = TestEntity2(id: .init(rawValue: "cool"), attributes: .none, relationships: .init(other: .init(resourceObject: entity1)), meta: .none, links: .none)
		let _ = TestEntity2(id: .init(rawValue: "cool"), attributes: .none, relationships: .init(other: .init(resourceObject: entity1)), meta: .none, links: .none)
		let _ = TestEntity2(id: .init(rawValue: "cool"), attributes: .none, relationships: .init(other: .init(resourceObject: entity1)), meta: .none, links: .none)
		let _ = TestEntity3(id: .init(rawValue: "3"), attributes: .none, relationships: .init(others: .init(ids: [.init(rawValue: "10"), .init(rawValue: "20"), entity1.id])), meta: .none, links: .none)
		let _ = TestEntity3(id: .init(rawValue: "3"), attributes: .none, relationships: .init(others: .none), meta: .none, links: .none)
		let _ = TestEntity4(id: .init(rawValue: "4"), attributes: .init(word: .init(value: "hello"), number: .init(value: 10), array: .init(value: [10.2, 10.3])), relationships: .init(other: entity2.pointer), meta: .none, links: .none)
		let _ = TestEntity5(id: .init(rawValue: "5"), attributes: .init(floater: .init(value: 10.2)), relationships: .none, meta: .none, links: .none)
		let _ = TestEntity6(id: .init(rawValue: "6"), attributes: .init(here: .init(value: "here"), maybeHere: nil, maybeNull: .init(value: nil)), relationships: .none, meta: .none, links: .none)
		let _ = TestEntity7(id: .init(rawValue: "7"), attributes: .init(here: .init(value: "hello"), maybeHereMaybeNull: .init(value: "world")), relationships: .none, meta: .none, links: .none)
		XCTAssertNoThrow(try TestEntity8(id: .init(rawValue: "8"), attributes: .init(string: .init(value: "hello"), int: .init(value: 10), stringFromInt: .init(rawValue: 20), plus: .init(rawValue: 30), doubleFromInt: .init(rawValue: 32), omitted: nil, nullToString: .init(rawValue: nil)), relationships: .none, meta: .none, links: .none))
        let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(meta: .init(meta: .init(x: "hello", y: 5), links: .none), optionalMeta: nil, one: entity1.pointer, nullableOne: nil, optionalOne: nil, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
		let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(meta: .init(meta: .init(x: "hello", y: 5), links: .none), optionalMeta: .init(meta: .init(x: "hello", y: 5), links: .none), one: entity1.pointer, nullableOne: .init(resourceObject: nil), optionalOne: nil, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
		let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(meta: .init(meta: .init(x: "hello", y: 5), links: .none), optionalMeta: nil, one: entity1.pointer, nullableOne: .init(id: nil), optionalOne: nil, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
		let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(meta: .init(meta: .init(x: "hello", y: 5), links: .none), optionalMeta: nil, one: entity1.pointer, nullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalOne: nil, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
		let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(meta: .init(meta: .init(x: "hello", y: 5), links: .none), optionalMeta: nil, one: entity1.pointer, nullableOne: nil, optionalOne: entity1.pointer, optionalNullableOne: nil, optionalMany: nil), meta: .none, links: .none)
		let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(meta: .init(meta: .init(x: "hello", y: 5), links: .none), optionalMeta: nil, one: entity1.pointer, nullableOne: nil, optionalOne: nil, optionalNullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalMany: nil), meta: .none, links: .none)
		let _ = TestEntity9(id: .init(rawValue: "9"), attributes: .none, relationships: .init(meta: .init(meta: .init(x: "hello", y: 5), links: .none), optionalMeta: nil, one: entity1.pointer, nullableOne: nil, optionalOne: nil, optionalNullableOne: .init(resourceObject: entity1, meta: .none, links: .none), optionalMany: .init(resourceObjects: [], meta: .none, links: .none)), meta: .none, links: .none)
		let e10id1 = TestEntity10.ID(rawValue: "hello")
		let e10id2 = TestEntity10.Id(rawValue: "world")
		let e10id3: TestEntity10.Id = "!"
		let _ = TestEntity10(id: .init(rawValue: "10"), attributes: .none, relationships: .init(selfRef: .init(id: e10id1), selfRefs: .init(ids: [e10id2, e10id3])), meta: .none, links: .none)
		XCTAssertNoThrow(try TestEntity11(id: .init(rawValue: "11"), attributes: .init(number: .init(rawValue: 11)), relationships: .none, meta: .none, links: .none))
		let _ = UnidentifiedTestEntity(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .none, links: .none)
		let _ = UnidentifiedTestEntityWithMeta(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .init(x: "world", y: nil), links: .none)
		let _ = UnidentifiedTestEntityWithLinks(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .none, links: .init(link1: .init(url: "hmmm")))
	}
}

// MARK: - Identifying entity copies
extension ResourceObjectTests {
	func test_copyIdentifiedByType() {
		let unidentifiedEntity = UnidentifiedTestEntity(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .none, links: .none)

		let identifiedCopy = unidentifiedEntity.identified(byType: String.self)

		XCTAssertEqual(unidentifiedEntity.attributes, identifiedCopy.attributes)
		XCTAssertEqual(unidentifiedEntity.relationships, identifiedCopy.relationships)
	}

	func test_copyIdentifiedByValue() {
		let unidentifiedEntity = UnidentifiedTestEntity(attributes: .init(me: .init(value: "hello")), relationships: .none, meta: .none, links: .none)

		let identifiedCopy = unidentifiedEntity.identified(by: "hello")

		XCTAssertEqual(unidentifiedEntity.attributes, identifiedCopy.attributes)
		XCTAssertEqual(unidentifiedEntity.relationships, identifiedCopy.relationships)
		XCTAssertEqual(identifiedCopy.id, "hello")
	}

	func test_copyWithNewId() {
		let identifiedEntity = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)

		let identifiedCopy = identifiedEntity.withNewIdentifier()

		XCTAssertNotEqual(identifiedEntity.id, identifiedCopy.id)
	}
}

// MARK: - Encode/Decode
extension ResourceObjectTests {

	func test_EntityNoRelationshipsNoAttributes() {
		let entity = decoded(type: TestEntity1.self,
								  data: entity_no_relationships_no_attributes)

		XCTAssert(type(of: entity.relationships) == NoRelationships.self)
		XCTAssert(type(of: entity.attributes) == NoAttributes.self)
		XCTAssertNoThrow(try TestEntity1.check(entity))

		testEncoded(entity: entity)
	}

	func test_EntityNoRelationshipsNoAttributes_encode() {
		test_DecodeEncodeEquality(type: TestEntity1.self,
								   data: entity_no_relationships_no_attributes)
	}

	func test_EntityNoRelationshipsSomeAttributes() {
		let entity = decoded(type: TestEntity5.self,
								   data: entity_no_relationships_some_attributes)

		XCTAssert(type(of: entity.relationships) == NoRelationships.self)

        XCTAssertEqual(entity.floater, 123.321)
		XCTAssertNoThrow(try TestEntity5.check(entity))

		testEncoded(entity: entity)
	}

	func test_EntityNoRelationshipsSomeAttributes_encode() {
		test_DecodeEncodeEquality(type: TestEntity5.self,
								   data: entity_no_relationships_some_attributes)
	}

	func test_EntitySomeRelationshipsNoAttributes() {
		let entity = decoded(type: TestEntity3.self,
								   data: entity_some_relationships_no_attributes)

		XCTAssert(type(of: entity.attributes) == NoAttributes.self)

		XCTAssertEqual((entity ~> \.others).map(\.rawValue), ["364B3B69-4DF1-467F-B52E-B0C9E44F666E"])
		XCTAssertNoThrow(try TestEntity3.check(entity))

		testEncoded(entity: entity)
	}

	func test_EntitySomeRelationshipsNoAttributes_encode() {
		test_DecodeEncodeEquality(type: TestEntity3.self,
								  data: entity_some_relationships_no_attributes)
	}

	func test_EntitySomeRelationshipsSomeAttributes() {
		let entity = decoded(type: TestEntity4.self,
								   data: entity_some_relationships_some_attributes)

        XCTAssertEqual(entity.word, "coolio")
        XCTAssertEqual(entity.number, 992299)
		XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
		XCTAssertNoThrow(try TestEntity4.check(entity))

		testEncoded(entity: entity)
	}

	func test_EntitySomeRelationshipsSomeAttributes_encode() {
		test_DecodeEncodeEquality(type: TestEntity4.self,
								   data: entity_some_relationships_some_attributes)
	}
}

// MARK: Attribute omission and nullification
extension ResourceObjectTests {

	func test_entityOneOmittedAttribute() {
		let entity = decoded(type: TestEntity6.self,
								   data: entity_one_omitted_attribute)

        XCTAssertEqual(entity.here, "Hello")
        XCTAssertNil(entity.maybeHere)
        XCTAssertEqual(entity.maybeNull, "World")
		XCTAssertNoThrow(try TestEntity6.check(entity))

		testEncoded(entity: entity)
	}

	func test_entityOneOmittedAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity6.self,
								   data: entity_one_omitted_attribute)
	}

	func test_entityOneNullAttribute() {
		let entity = decoded(type: TestEntity6.self,
								   data: entity_one_null_attribute)

        XCTAssertEqual(entity.here, "Hello")
        XCTAssertEqual(entity.maybeHere, "World")
        XCTAssertNil(entity.maybeNull)
		XCTAssertNoThrow(try TestEntity6.check(entity))

		testEncoded(entity: entity)
	}

	func test_entityOneNullAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity6.self,
								   data: entity_one_null_attribute)
	}

	func test_entityAllAttribute() {
		let entity = decoded(type: TestEntity6.self,
								   data: entity_all_attributes)

        XCTAssertEqual(entity.here, "Hello")
        XCTAssertEqual(entity.maybeHere, "World")
        XCTAssertEqual(entity.maybeNull, "!")
		XCTAssertNoThrow(try TestEntity6.check(entity))

		testEncoded(entity: entity)
	}

	func test_entityAllAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity6.self,
								   data: entity_all_attributes)
	}

	func test_entityOneNullAndOneOmittedAttribute() {
		let entity = decoded(type: TestEntity6.self,
								   data: entity_one_null_and_one_missing_attribute)

        XCTAssertEqual(entity.here, "Hello")
        XCTAssertNil(entity.maybeHere)
        XCTAssertNil(entity.maybeNull)
		XCTAssertNoThrow(try TestEntity6.check(entity))

		testEncoded(entity: entity)
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
		let entity = decoded(type: TestEntity7.self,
								   data: entity_null_optional_nullable_attribute)

        XCTAssertEqual(entity.here, "Hello")
        XCTAssertNil(entity.maybeHereMaybeNull)
		XCTAssertNoThrow(try TestEntity7.check(entity))

		testEncoded(entity: entity)
	}

	func test_NullOptionalNullableAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity7.self,
								   data: entity_null_optional_nullable_attribute)
	}

	func test_NonNullOptionalNullableAttribute() {
		let entity = decoded(type: TestEntity7.self,
								   data: entity_non_null_optional_nullable_attribute)

        XCTAssertEqual(entity.here, "Hello")
        XCTAssertEqual(entity.maybeHereMaybeNull, "World")
		XCTAssertNoThrow(try TestEntity7.check(entity))

		testEncoded(entity: entity)
	}

	func test_NonNullOptionalNullableAttribute_encode() {
		test_DecodeEncodeEquality(type: TestEntity7.self,
								   data: entity_non_null_optional_nullable_attribute)
	}
}

// MARK: Attribute Transformation
extension ResourceObjectTests {
	func test_IntToString() {
		let entity = decoded(type: TestEntity8.self,
								   data: entity_int_to_string_attribute)

        XCTAssertEqual(entity.string, "22")
        XCTAssertEqual(entity.int, 22)
        XCTAssertEqual(entity.stringFromInt, "22")
        XCTAssertEqual(entity.plus, 122)
        XCTAssertEqual(entity.doubleFromInt, 22.0)
        XCTAssertEqual(entity.nullToString, "nil")
		XCTAssertNoThrow(try TestEntity8.check(entity))

		testEncoded(entity: entity)
	}

	func test_IntToString_encode() {
		test_DecodeEncodeEquality(type: TestEntity8.self,
								   data: entity_int_to_string_attribute)
	}
}

// MARK: Attribute Validation
extension ResourceObjectTests {
	func test_IntOver10_success() {
		XCTAssertNoThrow(decoded(type: TestEntity11.self, data: entity_valid_validated_attribute))
	}

	func test_IntOver10_encode() {
		test_DecodeEncodeEquality(type: TestEntity11.self, data: entity_valid_validated_attribute)
	}

	func test_IntOver10_failure() {
		XCTAssertThrowsError(try JSONDecoder().decode(TestEntity11.self, from: entity_invalid_validated_attribute))
	}
}

// MARK: Relationship omission and nullification
extension ResourceObjectTests {
	func test_nullableRelationshipNotNullOrOmitted() {
		let entity = decoded(type: TestEntity9.self,
								   data: entity_optional_not_omitted_relationship)

        XCTAssertEqual(entity.relationships.meta.meta, TestEntityMeta(x: "world", y: 5))
        XCTAssertEqual(entity.relationships.optionalMeta?.meta, TestEntityMeta(x: "world", y: 5))
		XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "3323")
		XCTAssertEqual((entity ~> \.one).rawValue, "4459")
		XCTAssertNil(entity ~> \.optionalOne)
		XCTAssertEqual((entity ~> \.optionalNullableOne)?.rawValue, "1229")
		XCTAssertNoThrow(try TestEntity9.check(entity))

		testEncoded(entity: entity)
	}

	func test_nullableRelationshipNotNullOrOmitted_encode() {
		test_DecodeEncodeEquality(type: TestEntity9.self,
								   data: entity_optional_not_omitted_relationship)
	}

	func test_nullableRelationshipNotNull() {
		let entity = decoded(type: TestEntity9.self,
							 data: entity_omitted_relationship)

		XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "3323")
		XCTAssertEqual((entity ~> \.one).rawValue, "4459")
		XCTAssertNil(entity ~> \.optionalNullableOne)
		XCTAssertNoThrow(try TestEntity9.check(entity))

		testEncoded(entity: entity)
	}

	func test_nullableRelationshipNotNull_encode() {
		test_DecodeEncodeEquality(type: TestEntity9.self,
								  data: entity_omitted_relationship)
	}

	func test_optionalNullableRelationshipNulled() {
		let entity = decoded(type: TestEntity9.self,
							 data: entity_optional_nullable_nulled_relationship)

        XCTAssertEqual(entity.relationships.meta.meta, TestEntityMeta(x: "world", y: 5))
        XCTAssertNil(entity.relationships.optionalMeta)
		XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "3323")
		XCTAssertEqual((entity ~> \.one).rawValue, "4459")
		XCTAssertNil(entity ~> \.optionalNullableOne)
        XCTAssertNil((entity ~> \.optionalNullableOne).rawValue)
		XCTAssertNoThrow(try TestEntity9.check(entity))

		testEncoded(entity: entity)
	}

	func test_optionalNullableRelationshipNulled_encode() {
		test_DecodeEncodeEquality(type: TestEntity9.self,
								  data: entity_optional_nullable_nulled_relationship)
	}

	func test_optionalNullableRelationshipOmitted() {
		let entity = decoded(type: TestEntity12.self,
							 data: entity_all_relationships_optional_and_omitted)

		XCTAssertNil(entity ~> \.optionalOne)
		XCTAssertNil(entity ~> \.optionalNullableOne)
		XCTAssertNil(entity ~> \.optionalMany)
		XCTAssertNoThrow(try TestEntity12.check(entity))
	}

	func test_nullableRelationshipIsNull() {
		let entity = decoded(type: TestEntity9.self,
								   data: entity_nulled_relationship)

		XCTAssertNil(entity ~> \.nullableOne)
		XCTAssertEqual((entity ~> \.one).rawValue, "4452")
		XCTAssertNil(entity ~> \.optionalNullableOne)
		XCTAssertNoThrow(try TestEntity9.check(entity))

		testEncoded(entity: entity)
	}

	func test_nullableRelationshipIsNull_encode() {
		test_DecodeEncodeEquality(type: TestEntity9.self,
								   data: entity_nulled_relationship)
	}

	func test_optionalToManyIsNotOmitted() {
		let entity = decoded(type: TestEntity9.self,
							 data: entity_optional_to_many_relationship_not_omitted)

		XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "3323")
		XCTAssertEqual((entity ~> \.one).rawValue, "4459")
		XCTAssertEqual((entity ~> \.optionalMany)?[0].rawValue, "332223")
		XCTAssertNil(entity ~> \.optionalNullableOne)
		XCTAssertNoThrow(try TestEntity9.check(entity))

		testEncoded(entity: entity)
	}

	func test_optionalToManyIsNotOmitted_encode() {
		test_DecodeEncodeEquality(type: TestEntity9.self,
								  data: entity_optional_to_many_relationship_not_omitted)
	}
}

// MARK: Relationships of same type as root entity

extension ResourceObjectTests {
	func test_RleationshipsOfSameType() {
		let entity = decoded(type: TestEntity10.self,
								   data: entity_self_ref_relationship)

		XCTAssertEqual((entity ~> \.selfRef).rawValue, "1")
		XCTAssertNoThrow(try TestEntity10.check(entity))

		testEncoded(entity: entity)
	}

	func test_RleationshipsOfSameType_encode() {
		test_DecodeEncodeEquality(type: TestEntity10.self,
								   data: entity_self_ref_relationship)
	}
}

// MARK: Unidentified

extension ResourceObjectTests {
	func test_UnidentifiedEntity() {
		let entity = decoded(type: UnidentifiedTestEntity.self,
								   data: entity_unidentified)

        XCTAssertNil(entity.me)
		XCTAssertEqual(entity.id, .unidentified)
		XCTAssertNoThrow(try UnidentifiedTestEntity.check(entity))

		testEncoded(entity: entity)
	}

	func test_UnidentifiedEntity_encode() {
		test_DecodeEncodeEquality(type: UnidentifiedTestEntity.self,
								   data: entity_unidentified)
	}

	func test_UnidentifiedEntityWithAttributes() {
		let entity = decoded(type: UnidentifiedTestEntity.self,
								   data: entity_unidentified_with_attributes)

        XCTAssertEqual(entity.me, "unknown")
		XCTAssertEqual(entity.id, .unidentified)
		XCTAssertNoThrow(try UnidentifiedTestEntity.check(entity))

		testEncoded(entity: entity)
	}

	func test_UnidentifiedEntityWithAttributes_encode() {
		test_DecodeEncodeEquality(type: UnidentifiedTestEntity.self,
								   data: entity_unidentified_with_attributes)
	}
}

// MARK: With Meta and/or Links

extension ResourceObjectTests {
	func test_UnidentifiedEntityWithAttributesAndMeta() {
		let entity = decoded(type: UnidentifiedTestEntityWithMeta.self,
							 data: entity_unidentified_with_attributes_and_meta)

        XCTAssertEqual(entity.me, "unknown")
		XCTAssertEqual(entity.id, .unidentified)
		XCTAssertEqual(entity.meta.x, "world")
		XCTAssertEqual(entity.meta.y, 5)
		XCTAssertNoThrow(try UnidentifiedTestEntityWithMeta.check(entity))

		testEncoded(entity: entity)
	}

	func test_UnidentifiedEntityWithAttributesAndMeta_encode() {
		test_DecodeEncodeEquality(type: UnidentifiedTestEntityWithMeta.self,
								  data: entity_unidentified_with_attributes_and_meta)
	}

	func test_UnidentifiedEntityWithAttributesAndLinks() {
		let entity = decoded(type: UnidentifiedTestEntityWithLinks.self,
							 data: entity_unidentified_with_attributes_and_links)

        XCTAssertEqual(entity.me, "unknown")
		XCTAssertEqual(entity.id, .unidentified)
		XCTAssertEqual(entity.links.link1, .init(url: "https://image.com/image.png"))
		XCTAssertNoThrow(try UnidentifiedTestEntityWithLinks.check(entity))

		testEncoded(entity: entity)
	}

	func test_UnidentifiedEntityWithAttributesAndLinks_encode() {
		test_DecodeEncodeEquality(type: UnidentifiedTestEntityWithLinks.self,
								  data: entity_unidentified_with_attributes_and_links)
	}

	func test_UnidentifiedEntityWithAttributesAndMetaAndLinks() {
		let entity = decoded(type: UnidentifiedTestEntityWithMetaAndLinks.self,
							 data: entity_unidentified_with_attributes_and_meta_and_links)

        XCTAssertEqual(entity.me, "unknown")
		XCTAssertEqual(entity.id, .unidentified)
		XCTAssertEqual(entity.meta.x, "world")
		XCTAssertEqual(entity.meta.y, 5)
		XCTAssertEqual(entity.links.link1, .init(url: "https://image.com/image.png"))
		XCTAssertNoThrow(try UnidentifiedTestEntityWithMetaAndLinks.check(entity))

		testEncoded(entity: entity)
	}

	func test_UnidentifiedEntityWithAttributesAndMetaAndLinks_encode() {
		test_DecodeEncodeEquality(type: UnidentifiedTestEntityWithMetaAndLinks.self,
								  data: entity_unidentified_with_attributes_and_meta_and_links)
	}

	func test_EntitySomeRelationshipsSomeAttributesWithMeta() {
		let entity = decoded(type: TestEntity4WithMeta.self,
							 data: entity_some_relationships_some_attributes_with_meta)

        XCTAssertEqual(entity.word, "coolio")
        XCTAssertEqual(entity.number, 992299)
		XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
		XCTAssertEqual(entity.meta.x, "world")
		XCTAssertEqual(entity.meta.y, 5)
		XCTAssertNoThrow(try TestEntity4WithMeta.check(entity))

		testEncoded(entity: entity)
	}

	func test_EntitySomeRelationshipsSomeAttributesWithMeta_encode() {
		test_DecodeEncodeEquality(type: TestEntity4WithMeta.self,
								  data: entity_some_relationships_some_attributes_with_meta)
	}

	func test_EntitySomeRelationshipsSomeAttributesWithLinks() {
		let entity = decoded(type: TestEntity4WithLinks.self,
							 data: entity_some_relationships_some_attributes_with_links)

        XCTAssertEqual(entity.word, "coolio")
        XCTAssertEqual(entity.number, 992299)
		XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
		XCTAssertEqual(entity.links.link1, .init(url: "https://image.com/image.png"))
		XCTAssertNoThrow(try TestEntity4WithLinks.check(entity))

		testEncoded(entity: entity)
	}

	func test_EntitySomeRelationshipsSomeAttributesWithLinks_encode() {
		test_DecodeEncodeEquality(type: TestEntity4WithLinks.self,
								  data: entity_some_relationships_some_attributes_with_links)
	}

	func test_EntitySomeRelationshipsSomeAttributesWithMetaAndLinks() {
		let entity = decoded(type: TestEntity4WithMetaAndLinks.self,
							 data: entity_some_relationships_some_attributes_with_meta_and_links)

        XCTAssertEqual(entity.word, "coolio")
        XCTAssertEqual(entity.number, 992299)
		XCTAssertEqual((entity ~> \.other).rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
		XCTAssertEqual(entity.meta.x, "world")
		XCTAssertEqual(entity.meta.y, 5)
		XCTAssertEqual(entity.links.link1, .init(url: "https://image.com/image.png"))
		XCTAssertNoThrow(try TestEntity4WithMetaAndLinks.check(entity))

		testEncoded(entity: entity)
	}

	func test_EntitySomeRelationshipsSomeAttributesWithMetaAndLinks_encode() {
		test_DecodeEncodeEquality(type: TestEntity4WithMetaAndLinks.self,
								  data: entity_some_relationships_some_attributes_with_meta_and_links)
	}
}

// MARK: With a Meta Attribute

extension ResourceObjectTests {
	func test_MetaEntityAttributeAccessWorks() {
		let entity1 = TestEntityWithMetaAttribute(id: "even",
												  attributes: .init(),
												  relationships: .none,
												  meta: .none,
												  links: .none)
		let entity2 = TestEntityWithMetaAttribute(id: "odd",
												  attributes: .init(),
												  relationships: .none,
												  meta: .none,
												  links: .none)

        XCTAssertEqual(entity1.metaAttribute, true)
        XCTAssertEqual(entity2.metaAttribute, false)
	}
}

// MARK: With a Meta Relationship

extension ResourceObjectTests {
	func test_MetaEntityRelationshipAccessWorks() {
		let entity1 = TestEntityWithMetaRelationship(id: "even",
												  attributes: .none,
												  relationships: .init(),
												  meta: .none,
												  links: .none)

		XCTAssertEqual(entity1 ~> \.metaRelationship, "hello")
	}

    func test_toManyMetaRelationshipAccessWorks() {
        let entity1 = TestEntityWithMetaRelationship(id: "even",
                                                     attributes: .none,
                                                     relationships: .init(),
                                                     meta: .none,
                                                     links: .none)

        XCTAssertEqual(entity1 ~> \.toManyMetaRelationship, ["hello"])
    }
}

// MARK: - Test Types
extension ResourceObjectTests {

	enum TestEntityType1: ResourceObjectDescription {
		static var jsonType: String { return "test_entities"}

		typealias Attributes = NoAttributes
		typealias Relationships = NoRelationships
	}

	typealias TestEntity1 = BasicEntity<TestEntityType1>

	enum TestEntityType2: ResourceObjectDescription {
		static var jsonType: String { return "second_test_entities"}

		typealias Attributes = NoAttributes

		struct Relationships: JSONAPI.Relationships {
			let other: ToOneRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>
		}
	}

	typealias TestEntity2 = BasicEntity<TestEntityType2>

	enum TestEntityType3: ResourceObjectDescription {
		static var jsonType: String { return "third_test_entities"}

		typealias Attributes = NoAttributes

		struct Relationships: JSONAPI.Relationships {
			let others: ToManyRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>
		}
	}

	typealias TestEntity3 = BasicEntity<TestEntityType3>

	enum TestEntityType4: ResourceObjectDescription {
		static var jsonType: String { return "fourth_test_entities"}

		struct Relationships: JSONAPI.Relationships {
			let other: ToOneRelationship<TestEntity2, NoIdMetadata, NoMetadata, NoLinks>
		}

		struct Attributes: JSONAPI.Attributes {
			let word: Attribute<String>
			let number: Attribute<Int>
			let array: Attribute<[Double]>
		}
	}

	typealias TestEntity4 = BasicEntity<TestEntityType4>

	typealias TestEntity4WithMeta = Entity<TestEntityType4, TestEntityMeta, NoLinks>

	typealias TestEntity4WithLinks = Entity<TestEntityType4, NoMetadata, TestEntityLinks>

	typealias TestEntity4WithMetaAndLinks = Entity<TestEntityType4, TestEntityMeta, TestEntityLinks>

	enum TestEntityType5: ResourceObjectDescription {
		static var jsonType: String { return "fifth_test_entities"}

		typealias Relationships = NoRelationships

		struct Attributes: JSONAPI.Attributes {
			let floater: Attribute<Double>
		}
	}

	typealias TestEntity5 = BasicEntity<TestEntityType5>

	enum TestEntityType6: ResourceObjectDescription {
		static var jsonType: String { return "sixth_test_entities" }

		typealias Relationships = NoRelationships

		struct Attributes: JSONAPI.Attributes {
			let here: Attribute<String>
			let maybeHere: Attribute<String>?
			let maybeNull: Attribute<String?>
		}
	}

	typealias TestEntity6 = BasicEntity<TestEntityType6>

	enum TestEntityType7: ResourceObjectDescription {
		static var jsonType: String { return "seventh_test_entities" }

		typealias Relationships = NoRelationships

		struct Attributes: JSONAPI.Attributes {
			let here: Attribute<String>
			let maybeHereMaybeNull: Attribute<String?>?
		}
	}

	typealias TestEntity7 = BasicEntity<TestEntityType7>

	enum TestEntityType8: ResourceObjectDescription {
		static var jsonType: String { return "eighth_test_entities" }

		typealias Relationships = NoRelationships

		struct Attributes: JSONAPI.Attributes {
			let string: Attribute<String>
			let int: Attribute<Int>
			let stringFromInt: TransformedAttribute<Int, IntToString>
			let plus: TransformedAttribute<Int, IntPlusOneHundred>
			let doubleFromInt: TransformedAttribute<Int, IntToDouble>
			let omitted: TransformedAttribute<Int, IntToString>?
			let nullToString: TransformedAttribute<Int?, OptionalToString<Int>>
		}
	}

	typealias TestEntity8 = BasicEntity<TestEntityType8>

	enum TestEntityType9: ResourceObjectDescription {
		public static var jsonType: String { return "ninth_test_entities" }

		typealias Attributes = NoAttributes

		public struct Relationships: JSONAPI.Relationships {
            let meta: MetaRelationship<TestEntityMeta, NoLinks>

            let optionalMeta: MetaRelationship<TestEntityMeta, NoLinks>?

			let one: ToOneRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>

			let nullableOne: ToOneRelationship<TestEntity1?, NoIdMetadata, NoMetadata, NoLinks>

			let optionalOne: ToOneRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>?

			let optionalNullableOne: ToOneRelationship<TestEntity1?, NoIdMetadata, NoMetadata, NoLinks>?

			let optionalMany: ToManyRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>?

			// a nullable many is not allowed. it should
			// just be an empty array.
		}
	}

	typealias TestEntity9 = BasicEntity<TestEntityType9>

	enum TestEntityType10: ResourceObjectDescription {
		public static var jsonType: String { return "tenth_test_entities" }

		typealias Attributes = NoAttributes

		public struct Relationships: JSONAPI.Relationships {
			let selfRef: ToOneRelationship<TestEntity10, NoIdMetadata, NoMetadata, NoLinks>
			let selfRefs: ToManyRelationship<TestEntity10, NoIdMetadata, NoMetadata, NoLinks>
		}
	}

	typealias TestEntity10 = BasicEntity<TestEntityType10>

	enum TestEntityType11: ResourceObjectDescription {
		public static var jsonType: String { return "eleventh_test_entities" }

		public struct Attributes: JSONAPI.Attributes {
			let number: ValidatedAttribute<Int, IntOver10>
		}

		typealias Relationships = NoRelationships
	}

	typealias TestEntity11 = BasicEntity<TestEntityType11>

	enum TestEntityType12: ResourceObjectDescription {
		public static var jsonType: String { return "twelfth_test_entities" }

		typealias Attributes = NoAttributes

		public struct Relationships: JSONAPI.Relationships {
			public init() {
                optionalMeta = nil
				optionalOne = nil
				optionalNullableOne = nil
				optionalMany = nil
			}

            let optionalMeta: MetaRelationship<TestEntityMeta, NoLinks>?

			let optionalOne: ToOneRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>?

			let optionalNullableOne: ToOneRelationship<TestEntity1?, NoIdMetadata, NoMetadata, NoLinks>?

			let optionalMany: ToManyRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>?
		}
	}

	typealias TestEntity12 = BasicEntity<TestEntityType12>

	enum UnidentifiedTestEntityType: ResourceObjectDescription {
		public static var jsonType: String { return "unidentified_test_entities" }

		struct Attributes: JSONAPI.Attributes {
			let me: Attribute<String>?
		}

		typealias Relationships = NoRelationships
	}

	typealias UnidentifiedTestEntity = NewEntity<UnidentifiedTestEntityType, NoMetadata, NoLinks>

	typealias UnidentifiedTestEntityWithMeta = NewEntity<UnidentifiedTestEntityType, TestEntityMeta, NoLinks>

	typealias UnidentifiedTestEntityWithLinks = NewEntity<UnidentifiedTestEntityType, NoMetadata, TestEntityLinks>

	typealias UnidentifiedTestEntityWithMetaAndLinks = NewEntity<UnidentifiedTestEntityType, TestEntityMeta, TestEntityLinks>

	enum TestEntityWithMetaAttributeDescription: ResourceObjectDescription {
		public static var jsonType: String { return "meta_attribute_entity" }

		struct Attributes: JSONAPI.Attributes {
			var metaAttribute: (TestEntityWithMetaAttribute) -> Bool {
				return { entity in
					(entity.id.rawValue.count % 2) == 0
				}
			}
		}

		typealias Relationships = NoRelationships
	}

	typealias TestEntityWithMetaAttribute = BasicEntity<TestEntityWithMetaAttributeDescription>

	enum TestEntityWithMetaRelationshipDescription: ResourceObjectDescription {
		public static var jsonType: String { return "meta_relationship_entity" }

		typealias Attributes = NoAttributes

		struct Relationships: JSONAPI.Relationships {
			var metaRelationship: (TestEntityWithMetaRelationship) -> TestEntity1.ID {
				return { entity in
					return TestEntity1.ID(rawValue: "hello")
				}
			}

            var toManyMetaRelationship: (TestEntityWithMetaRelationship) -> [TestEntity1.ID] {
                return { entity in
                    return [TestEntity1.ID.id(from: "hello")]
                }
            }
		}
	}

	typealias TestEntityWithMetaRelationship = BasicEntity<TestEntityWithMetaRelationshipDescription>

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

	enum IntOver10: Validator {
		enum Error: Swift.Error {
			case under10
		}

		public static func transform(_ from: Int) throws -> Int {
			guard from > 10 else {
				throw Error.under10
			}
			return from
		}
	}

	struct TestEntityMeta: JSONAPI.Meta {
		let x: String
		let y: Int?
	}

	struct TestEntityLinks: JSONAPI.Links {
		let link1: Link<String, NoMetadata>
	}
}
