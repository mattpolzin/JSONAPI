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
        }
    }
}

// MARK: - Attributes
extension ResourceObjectDecodingErrorTests {
    // TODO: write tests
}

// MARK: - Test Types
extension ResourceObjectDecodingErrorTests {
    enum TestEntityType: ResourceObjectDescription {
        public static var jsonType: String { return "thirteenth_test_entities" }

        typealias Attributes = NoAttributes

        public struct Relationships: JSONAPI.Relationships {

            let required: ToOneRelationship<TestEntity, NoMetadata, NoLinks>
        }
    }

    typealias TestEntity = BasicEntity<TestEntityType>
}
