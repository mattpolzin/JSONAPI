//
//  IncludesDecodingErrorTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/14/19.
//

import XCTest
import JSONAPI

final class IncludesDecodingErrorTests: XCTestCase {
    func test_unexpectedIncludeType() {
        var error1: Error!
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: three_different_type_includes)) { (error: Error) -> Void in
            XCTAssertEqual(
                (error as? IncludesDecodingError)?.idx,
                2
            )

            XCTAssertEqual(
                (error as? IncludesDecodingError).map(String.init(describing:)),
"""
Include 3 failed to parse: \nCould not have been Include Type 1 because:
found JSON:API type "test_entity4" but expected "test_entity1"

Could not have been Include Type 2 because:
found JSON:API type "test_entity4" but expected "test_entity2"
"""
            )

            error1 = error
        }

        // now test that we get the same error from a different test stub
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: four_different_type_includes)) { (error2: Error) -> Void in
            XCTAssertEqual(
                error1 as? IncludesDecodingError,
                error2 as? IncludesDecodingError
            )
        }
    }
}

// MARK: - Test Types
extension IncludesDecodingErrorTests {
    enum TestEntityType: ResourceObjectDescription {

        typealias Relationships = NoRelationships

        public static var jsonType: String { return "test_entity1" }

        public struct Attributes: JSONAPI.SparsableAttributes {
            let foo: Attribute<String>
            let bar: Attribute<Int>

            public enum CodingKeys: String, Equatable, CodingKey {
                case foo
                case bar
            }
        }
    }

    typealias TestEntity = BasicEntity<TestEntityType>

    enum TestEntityType2: ResourceObjectDescription {

        public static var jsonType: String { return "test_entity2" }

        public struct Relationships: JSONAPI.Relationships {
            let entity1: ToOneRelationship<TestEntity, NoIdMetadata, NoMetadata, NoLinks>
        }

        public struct Attributes: JSONAPI.SparsableAttributes {
            let foo: Attribute<String>
            let bar: Attribute<Int>

            public enum CodingKeys: String, Equatable, CodingKey {
                case foo
                case bar
            }
        }
    }

    typealias TestEntity2 = BasicEntity<TestEntityType2>

    enum TestEntityType4: ResourceObjectDescription {

        typealias Attributes = NoAttributes

        typealias Relationships = NoRelationships

        public static var jsonType: String { return "test_entity4" }
    }

    typealias TestEntity4 = BasicEntity<TestEntityType4>

    enum TestEntityType6: ResourceObjectDescription {

        typealias Attributes = NoAttributes

        public static var jsonType: String { return "test_entity6" }

        struct Relationships: JSONAPI.Relationships {
            let entity4: ToOneRelationship<TestEntity4, NoIdMetadata, NoMetadata, NoLinks>
        }
    }

    typealias TestEntity6 = BasicEntity<TestEntityType6>
}
