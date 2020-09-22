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
		let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity2 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity3 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity4 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let relationship = ToManyRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>(resourceObjects: [entity1, entity2, entity3, entity4])

		XCTAssertEqual(relationship.ids.count, 4)
		XCTAssertEqual(relationship.ids, [entity1, entity2, entity3, entity4].map(\.id))
	}

	func test_initToManyWithRelationships() {
		let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity2 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity3 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let entity4 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let relationship = ToManyRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>(pointers: [entity1.pointer, entity2.pointer, entity3.pointer, entity4.pointer])

		XCTAssertEqual(relationship.ids.count, 4)
		XCTAssertEqual(relationship.ids, [entity1, entity2, entity3, entity4].map(\.id))
	}

    func test_initToOneWithIdMeta() {
        let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let relationship = ToOneWithMetaInIds(
            id: (entity1.id, .init(a: "hello"))
        )
        XCTAssertEqual(relationship.id, entity1.id)
        XCTAssertEqual(relationship.idMeta, .init(a: "hello"))
    }

    func test_initToManyWithIdMeta() {
        let entity1 = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
        let relationship = ToManyWithMetaInIds(
            idsWithMetadata: [
                (entity1.id, .init(a: "hello"))
            ]
        )
        XCTAssertEqual(relationship.ids, [entity1.id])
        XCTAssertEqual(relationship.idsWithMeta, [.init(id: entity1.id, meta: .init(a: "hello"))])
    }
}

// MARK: - Encode/Decode
extension RelationshipTests {
    func test_MetaRelationshipWithMeta() {
        let relationship = decoded(
            type: MetaRelationship<TestMeta, NoLinks>.self,
            data: meta_relationship_with_meta
        )

        XCTAssertEqual(relationship.meta, TestMeta(a: "hello"))
        XCTAssertEqual(relationship.links, .none)
    }

    func test_MetaRelationshipWithMeta_encode() {
        test_DecodeEncodeEquality(
            type: MetaRelationship<TestMeta, NoLinks>.self,
            data: meta_relationship_with_meta
        )
    }

    func test_MetaRelationshipWithLinks() {
        let relationship = decoded(
            type: MetaRelationship<NoMetadata, TestLinks>.self,
            data: meta_relationship_with_links
        )

        XCTAssertEqual(relationship.meta, .none)
        XCTAssertEqual(relationship.links, TestLinks(b: .init(url: "world")))
    }

    func test_MetaRelationshipWithLinks_encode() {
        test_DecodeEncodeEquality(
            type: MetaRelationship<NoMetadata, TestLinks>.self,
            data: meta_relationship_with_links
        )
    }

    func test_MetaRelationshipWithMetaAndLinks() {
        let relationship = decoded(
            type: MetaRelationship<TestMeta, TestLinks>.self,
            data: meta_relationship_with_meta_and_links
        )

        XCTAssertEqual(relationship.meta, TestMeta(a: "hello"))
        XCTAssertEqual(relationship.links, TestLinks(b: .init(url: "world")))
    }

    func test_MetaRelationshipWithMetaAndLinks_encode() {
        test_DecodeEncodeEquality(
            type: MetaRelationship<TestMeta, TestLinks>.self,
            data: meta_relationship_with_meta_and_links
        )
    }

	func test_ToOneRelationship() {
		let relationship = decoded(type: ToOneRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>.self,
								   data: to_one_relationship)

		XCTAssertEqual(relationship.id.rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
	}

	func test_ToOneRelationship_encode() {
		test_DecodeEncodeEquality(type: ToOneRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>.self,
								   data: to_one_relationship)
	}

	func test_ToOneRelationshipWithMeta() {
		let relationship = decoded(type: ToOneWithMeta.self,
								   data: to_one_relationship_with_meta)

		XCTAssertEqual(relationship.id.rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
		XCTAssertEqual(relationship.meta.a, "hello")
	}

	func test_ToOneRelationshipWithMeta_encode() {
		test_DecodeEncodeEquality(type: ToOneWithMeta.self,
								  data: to_one_relationship_with_meta)
	}

    func test_ToOneRelationshipWithMetaInsideIdentifier() {
        let relationship = decoded(type: ToOneWithMetaInIds.self,
                                   data: to_one_relationship_with_meta_inside_identifier)

        XCTAssertEqual(relationship.id.rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
        XCTAssertEqual(relationship.idMeta.a, "hello")
    }

    func test_ToOneRelationshipWithMetaInsideIdentifier_encode() {
        test_DecodeEncodeEquality(type: ToOneWithMetaInIds.self,
                                  data: to_one_relationship_with_meta_inside_identifier)
    }

	func test_ToOneRelationshipWithLinks() {
		let relationship = decoded(type: ToOneWithLinks.self,
								   data: to_one_relationship_with_links)

		XCTAssertEqual(relationship.id.rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
		XCTAssertEqual(relationship.links.b, .init(url: "world"))
	}

	func test_ToOneRelationshipWithLinks_encode() {
		test_DecodeEncodeEquality(type: ToOneWithLinks.self,
								  data: to_one_relationship_with_links)
	}

	func test_ToOneRelationshipWithMetaAndLinks() {
		let relationship = decoded(type: ToOneWithMetaAndLinks.self,
								   data: to_one_relationship_with_meta_and_links)

		XCTAssertEqual(relationship.id.rawValue, "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF")
		XCTAssertEqual(relationship.meta.a, "hello")
		XCTAssertEqual(relationship.links.b, .init(url: "world"))
	}

	func test_ToOneRelationshipWithMetaAndLinks_encode() {
		test_DecodeEncodeEquality(type: ToOneWithMetaAndLinks.self,
								  data: to_one_relationship_with_meta_and_links)
	}

	func test_ToManyRelationship() {
		let relationship = decoded(type: ToManyRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>.self,
								   data: to_many_relationship)

		XCTAssertEqual(relationship.ids.map(\.rawValue), ["2DF03B69-4B0A-467F-B52E-B0C9E44FCECF", "90F03B69-4DF1-467F-B52E-B0C9E44FC333", "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"])
	}

	func test_ToManyRelationship_encode() {
		test_DecodeEncodeEquality(type: ToManyRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>.self,
								   data: to_many_relationship)
	}

	func test_ToManyRelationshipWithMeta() {
		let relationship = decoded(type: ToManyWithMeta.self,
								   data: to_many_relationship_with_meta)

		XCTAssertEqual(relationship.ids.map(\.rawValue), ["2DF03B69-4B0A-467F-B52E-B0C9E44FCECF", "90F03B69-4DF1-467F-B52E-B0C9E44FC333", "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"])
		XCTAssertEqual(relationship.meta.a, "hello")
	}

	func test_ToManyRelationshipWithMeta_encode() {
		test_DecodeEncodeEquality(type: ToManyWithMeta.self,
								  data: to_many_relationship_with_meta)
	}

    func test_ToManyRelationshipWithMetaInsideIdentifier() {
        let relationship = decoded(type: ToManyWithMetaInIds.self,
                                   data: to_many_relationship_with_meta_inside_identifier)

        XCTAssertEqual(relationship.ids.map(\.rawValue), ["2DF03B69-4B0A-467F-B52E-B0C9E44FCECF", "90F03B69-4DF1-467F-B52E-B0C9E44FC333", "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"])
        XCTAssertEqual(relationship.idsWithMeta[0].meta.a, "hello")
    }

    func test_ToManyRelationshipWithMetaInsideIdentifier_encode() {
        test_DecodeEncodeEquality(type: ToManyWithMetaInIds.self,
                                  data: to_many_relationship_with_meta_inside_identifier)
    }

	func test_ToManyRelationshipWithLinks() {
		let relationship = decoded(type: ToManyWithLinks.self,
								   data: to_many_relationship_with_links)

		XCTAssertEqual(relationship.ids.map(\.rawValue), ["2DF03B69-4B0A-467F-B52E-B0C9E44FCECF", "90F03B69-4DF1-467F-B52E-B0C9E44FC333", "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"])
		XCTAssertEqual(relationship.links.b, .init(url: "world"))
	}

	func test_ToManyRelationshipWithLinks_encode() {
		test_DecodeEncodeEquality(type: ToManyWithLinks.self,
								  data: to_many_relationship_with_links)
	}

	func test_ToManyRelationshipWithMetaAndLinks() {
		let relationship = decoded(type: ToManyWithMetaAndLinks.self,
								   data: to_many_relationship_with_meta_and_links)

		XCTAssertEqual(relationship.ids.map(\.rawValue), ["2DF03B69-4B0A-467F-B52E-B0C9E44FCECF", "90F03B69-4DF1-467F-B52E-B0C9E44FC333", "2DF03B69-4B0A-467F-B52E-B0C9E44FCECF"])
		XCTAssertEqual(relationship.meta.a, "hello")
		XCTAssertEqual(relationship.links.b, .init(url: "world"))
	}

	func test_ToManyRelationshipWithMetaAndLinks_encode() {
		test_DecodeEncodeEquality(type: ToManyWithMetaAndLinks.self,
								  data: to_many_relationship_with_meta_and_links)
	}
}

// MARK: Nullable
extension RelationshipTests {
	func test_ToOneNullableIsNullIfNil() {
		let relationship = ToOneNullable(resourceObject: nil)
		let relationshipData = try! JSONEncoder().encode(relationship)
		let relationshipString = String(data: relationshipData, encoding: .utf8)!

		XCTAssertEqual(relationshipString, "{\"data\":null}")
	}

	func test_ToOneNullableIsEqualToNonNullableIfNotNil() {
		let entity = TestEntity1(attributes: .none, relationships: .none, meta: .none, links: .none)
		let relationship1 = ToOneNonNullable(resourceObject: entity)
		let relationship2 = ToOneNullable(resourceObject: entity)

		XCTAssertEqual(encoded(value: relationship1), encoded(value: relationship2))
	}

    func test_nullableIdMeta() {
        let _ = decoded(type: ToOneRelationship<TestEntity1?, TestMeta?, NoMetadata, NoLinks>.self, data: to_one_relationship_nulled_out)
    }
}

// MARK: Failure tests
extension RelationshipTests {
	func test_ToManyTypeMismatch() {
		XCTAssertThrowsError(try JSONDecoder().decode(ToManyRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>.self, from: to_many_relationship_type_mismatch))
	}

	func test_ToOneTypeMismatch() {
		XCTAssertThrowsError(try JSONDecoder().decode(ToOneRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>.self, from: to_one_relationship_type_mismatch))
	}

    func test_toOneNulledOutWithExpectedIdMetadata() {
        XCTAssertThrowsError(try JSONDecoder().decode(ToOneRelationship<TestEntity1?, TestMeta, NoMetadata, NoLinks>.self, from: to_one_relationship_nulled_out))
    }
}

// MARK: - Test types
extension RelationshipTests {
	enum TestEntityType1: ResourceObjectDescription {
		typealias Attributes = NoAttributes

		typealias Relationships = NoRelationships

		public static var jsonType: String { return "test_entity1" }
	}

	typealias TestEntity1 = BasicEntity<TestEntityType1>

	typealias ToOneWithMeta = ToOneRelationship<TestEntity1, NoIdMetadata, TestMeta, NoLinks>
    typealias ToOneWithMetaInIds = ToOneRelationship<TestEntity1, TestMeta, NoMetadata, NoLinks>

	typealias ToOneWithLinks = ToOneRelationship<TestEntity1, NoIdMetadata, NoMetadata, TestLinks>

    typealias ToOneWithMetaAndLinks = ToOneRelationship<TestEntity1, NoIdMetadata, TestMeta, TestLinks>

	typealias ToManyWithMeta = ToManyRelationship<TestEntity1, NoIdMetadata, TestMeta, NoLinks>
    typealias ToManyWithMetaInIds = ToManyRelationship<TestEntity1, TestMeta, NoMetadata, NoLinks>

    typealias ToManyWithLinks = ToManyRelationship<TestEntity1, NoIdMetadata, NoMetadata, TestLinks>

    typealias ToManyWithMetaAndLinks = ToManyRelationship<TestEntity1, NoIdMetadata, TestMeta, TestLinks>

	typealias ToOneNullable = ToOneRelationship<TestEntity1?, NoIdMetadata, NoMetadata, NoLinks>
	typealias ToOneNonNullable = ToOneRelationship<TestEntity1, NoIdMetadata, NoMetadata, NoLinks>

	struct TestMeta: JSONAPI.Meta {
		let a: String
	}

	typealias TestLink = JSONAPI.Link<String, NoMetadata>

	struct TestLinks: JSONAPI.Links {
		let b: TestLink
	}
}
