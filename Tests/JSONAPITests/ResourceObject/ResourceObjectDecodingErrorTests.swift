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
                    location: .relationships,
                    jsonAPIType: TestEntity.jsonType
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
                    location: .relationships,
                    jsonAPIType: TestEntity.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' relationship is required and missing."
            )
        }
    }

    func test_relationshipWithNoId() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_required_relationship_no_id
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .keyNotFound,
                    location: .relationshipId,
                    jsonAPIType: TestEntity.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' relationship does not have an 'id'."
            )
        }
    }

    func test_relationshipWithNoType() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_required_relationship_no_type
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .keyNotFound,
                    location: .relationshipType,
                    jsonAPIType: TestEntity.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' relationship does not have a 'type'."
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
                    location: .relationships,
                    jsonAPIType: TestEntity.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' relationship is not nullable but null was found."
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
                    location: .relationships,
                    jsonAPIType: TestEntity.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' relationship is not nullable but null was found."
            )
        }
    }

    func test_oneTypeVsAnother_relationship() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity.self,
            from: entity_relationship_is_wrong_type
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "required",
                    cause: .jsonTypeMismatch(foundType: "not_the_same"),
                    location: .relationships,
                    jsonAPIType: "thirteenth_test_entities"
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
                    location: .relationships,
                    jsonAPIType: TestEntity.jsonType
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
                    location: .relationships,
                    jsonAPIType: TestEntity.jsonType
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
                    location: .attributes,
                    jsonAPIType: TestEntity2.jsonType
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
                    location: .attributes,
                    jsonAPIType: TestEntity2.jsonType
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
                    location: .attributes,
                    jsonAPIType: TestEntity2.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'required' attribute is not nullable but null was found."
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
                    location: .attributes,
                    jsonAPIType: TestEntity2.jsonType
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
                    location: .attributes,
                    jsonAPIType: TestEntity2.jsonType
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
                    location: .attributes,
                    jsonAPIType: TestEntity2.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'yetAnother' attribute is not a Bool as expected."
            )
        }
    }

    func test_transformed_attribute() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_attribute_is_wrong_type4
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "transformed",
                    cause: .typeMismatch(expectedTypeName: String(describing: Int.self)),
                    location: .attributes,
                    jsonAPIType: TestEntity2.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                "'transformed' attribute is not a Int as expected."
            )
        }
    }

    func test_transformed_attribute2() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_attribute_always_fails
        )) { error in
            XCTAssertEqual(
                String(describing: error),
                "Error: Always Fails"
            )
        }
    }
}

// MARK: - JSON:API Type
extension ResourceObjectDecodingErrorTests {
    func test_wrongJSONAPIType() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_is_wrong_type
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "self",
                    cause: .jsonTypeMismatch(foundType: "not_correct_type"),
                    location: .type,
                    jsonAPIType: "fourteenth_test_entities"
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                #"found JSON:API type "not_correct_type" but expected "fourteenth_test_entities""#
            )
        }
    }

    func test_wrongDecodedType() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_type_is_wrong_type
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "type",
                    cause: .typeMismatch(expectedTypeName: String(describing: String.self)),
                    location: .type,
                    jsonAPIType: TestEntity2.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                #"'type' (a.k.a. the JSON:API type name) is not a String as expected."#
            )
        }
    }

    func test_type_missing() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_type_is_missing
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "type",
                    cause: .keyNotFound,
                    location: .type,
                    jsonAPIType: TestEntity2.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                #"'type' (a.k.a. JSON:API type name) is required and missing."#
            )
        }
    }

    func test_type_null() {
        XCTAssertThrowsError(try testDecoder.decode(
            TestEntity2.self,
            from: entity_type_is_null
        )) { error in
            XCTAssertEqual(
                error as? ResourceObjectDecodingError,
                ResourceObjectDecodingError(
                    subjectName: "type",
                    cause: .valueNotFound,
                    location: .type,
                    jsonAPIType: TestEntity2.jsonType
                )
            )

            XCTAssertEqual(
                (error as? ResourceObjectDecodingError)?.description,
                #"'type' (a.k.a. JSON:API type name) is not nullable but null was found."#
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

            let required: ToOneRelationship<TestEntity, NoIdMetadata, NoMetadata, NoLinks>
            let omittable: ToManyRelationship<TestEntity, NoIdMetadata, NoMetadata, NoLinks>?
        }
    }

    typealias TestEntity = BasicEntity<TestEntityType>

    enum TestEntityType2: ResourceObjectDescription {
        public static var jsonType: String { return "fourteenth_test_entities" }

        public struct Attributes: JSONAPI.Attributes {

            let required: Attribute<String>
            let other: Attribute<Int>?
            let yetAnother: Attribute<Bool?>?
            let transformed: TransformedAttribute<Int, IntToString>?
            let transformed2: TransformedAttribute<String, AlwaysFails>?
        }

        typealias Relationships = NoRelationships
    }

    typealias TestEntity2 = BasicEntity<TestEntityType2>

    enum IntToString: Transformer {
        static func transform(_ value: Int) throws -> String {
            return "\(value)"
        }
        typealias From = Int
        typealias To = String
    }

    enum AlwaysFails: Transformer {
        static func transform(_ value: String) throws -> String {
            throw Error()
        }

        struct Error: Swift.Error, CustomStringConvertible {
            let description: String = "Error: Always Fails"
        }
    }
}
