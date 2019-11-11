//
//  ResourceObjectDecodingErrorTests.swift
//  
//
//  Created by Mathew Polzin on 11/8/19.
//

import XCTest
@testable import JSONAPI

// MARK: - Relationships
final class ResourceObjectDecodingErrorTests: XCTestCase {
    func test_missingRelationshipsObject() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_relationships_entirely_missing
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: ResourceObjectDecodingError.entireObject,
                    cause: .keyNotFound,
                    location: .relationships
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "relationships object is required and missing."
            )
        }
    }

    func test_required_relationship() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_required_relationship_is_omitted
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .keyNotFound,
                    location: .relationships
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' relationship is required and missing."
            )
        }
    }

    func test_NonNullable_relationship() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_nonNullable_relationship_is_null
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .valueNotFound,
                    location: .relationships
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' relationship is not nullable but null."
            )
        }
    }

    func test_NonNullable_relationship2() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_nonNullable_relationship_is_null2
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .valueNotFound,
                    location: .relationships
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' relationship is not nullable but null."
            )
        }
    }

    func test_oneTypeVsAnother_relationship() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_relationship_is_wrong_type
        )) { error in
            print(error)
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .jsonTypeMismatch(expectedType: "thirteenth_test_entities", foundType: "not_the_same"),
                    location: .relationships
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                #"'required' relationship is of JSON:API type "not_the_same" but it was expected to be "thirteenth_test_entities""#
            )
        }
    }

    func test_twoOneVsToMany_relationship() {

        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_single_relationship_is_many
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .quantityMismatch(expected: .one),
                    location: .relationships
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' relationship should contain one value but found many"
            )
        }

        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_many_relationship_is_single
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "omittable",
                    cause: .quantityMismatch(expected: .many),
                    location: .relationships
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'omittable' relationship should contain many values but found one"
            )
        }
    }
}

// MARK: - Attributes
extension ResourceObjectDecodingErrorTests {
    func test_missingAttributesObject() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_attributes_entirely_missing
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: ResourceObjectDecodingError.entireObject,
                    cause: .keyNotFound,
                    location: .attributes
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "attributes object is required and missing."
            )
        }
    }

    func test_required_attribute() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_required_attribute_is_omitted
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .keyNotFound,
                    location: .attributes
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' attribute is required and missing."
            )
        }
    }

    func test_NonNullable_attribute() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_nonNullable_attribute_is_null
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .valueNotFound,
                    location: .attributes
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' attribute is not nullable but null."
            )
        }
    }

    func test_oneTypeVsAnother_attribute() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_attribute_is_wrong_type
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .typeMismatch(expectedTypeName: String(describing: String.self)),
                    location: .attributes
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' attribute is not a String as expected."
            )
        }
    }

    func test_oneTypeVsAnother_attribute2() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_attribute_is_wrong_type2
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "other",
                    cause: .typeMismatch(expectedTypeName: String(describing: Int.self)),
                    location: .attributes
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'other' attribute is not a Int as expected."
            )
        }
    }

    func test_oneTypeVsAnother_attribute3() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_attribute_is_wrong_type3
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "yetAnother",
                    cause: .typeMismatch(expectedTypeName: String(describing: Bool.self)),
                    location: .attributes
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'yetAnother' attribute is not a Bool as expected."
            )
        }
    }
}

// MARK: - JSON:API Type
extension ResourceObjectDecodingErrorTests {
    func test_wrongType() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_is_wrong_type
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "self",
                    cause: .jsonTypeMismatch(expectedType: "fourteenth_test_entities", foundType: "not_correct_type"),
                    location: .type
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                #"found JSON:API type "not_correct_type" but expected "fourteenth_test_entities""#
            )
        }
    }
}

// MARK: - Test Types
extension ResourceObjectDecodingErrorTests {
    enum TestEntityType: ResourceObjectDescription {
        public static var jsonType: String { return "thirteenth_test_entities" }

        typealias Attributes = NoAttributes

        public struct Relationships: JSONAPI.Relationships {

            let required: ToOneRelationship<TestEntity, NoMetadata, NoLinks>
            let omittable: ToManyRelationship<TestEntity, NoMetadata, NoLinks>?
        }
    }

    typealias TestEntity = BasicEntity<TestEntityType>

    enum TestEntityType2: ResourceObjectDescription {
        public static var jsonType: String { return "fourteenth_test_entities" }

        public struct Attributes: JSONAPI.Attributes {

            let required: Attribute<String>
            let other: Attribute<Int>?
            let yetAnother: Attribute<Bool?>?
        }

        typealias Relationships = NoRelationships
    }

    typealias TestEntity2 = BasicEntity<TestEntityType2>
}
