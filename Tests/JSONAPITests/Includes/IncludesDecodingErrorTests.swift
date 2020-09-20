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
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: three_different_type_includes)) { (error: Error) -> Void in
            XCTAssertEqual(
                (error as? IncludesDecodingError)?.idx,
                2
            )

            XCTAssertEqual(
                (error as? IncludesDecodingError).map(String.init(describing:)),
                """
                Out of 3 includes, the 3rd one failed to parse: \nCould not have been Include Type `test_entity1` because:
                found JSON:API type "test_entity4" but expected "test_entity1"

                Could not have been Include Type `test_entity2` because:
                found JSON:API type "test_entity4" but expected "test_entity2"
                """
            )
        }

        // now test that we get the same error with a different total include count from a different test stub
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: four_different_type_includes)) { (error2: Error) -> Void in
            XCTAssertEqual(
                (error2 as? IncludesDecodingError).map(String.init(describing:)),
                """
                Out of 4 includes, the 3rd one failed to parse: \nCould not have been Include Type `test_entity1` because:
                found JSON:API type "test_entity4" but expected "test_entity1"

                Could not have been Include Type `test_entity2` because:
                found JSON:API type "test_entity4" but expected "test_entity2"
                """
            )
        }

        // and with six total includes
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: six_includes_one_bad_type)) { (error2: Error) -> Void in
            XCTAssertEqual(
                (error2 as? IncludesDecodingError).map(String.init(describing:)),
                """
                Out of 6 includes, the 5th one failed to parse: \nCould not have been Include Type `test_entity1` because:
                found JSON:API type "test_entity4" but expected "test_entity1"

                Could not have been Include Type `test_entity2` because:
                found JSON:API type "test_entity4" but expected "test_entity2"
                """
            )
        }

        // and with a number of total includes between 10 and 19
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: eleven_includes_one_bad_type)) { (error2: Error) -> Void in
            XCTAssertEqual(
                (error2 as? IncludesDecodingError).map(String.init(describing:)),
                """
                Out of 11 includes, the 10th one failed to parse: \nCould not have been Include Type `test_entity1` because:
                found JSON:API type "test_entity4" but expected "test_entity1"

                Could not have been Include Type `test_entity2` because:
                found JSON:API type "test_entity4" but expected "test_entity2"
                """
            )
        }

        // and finally with a larger number of total includes
        XCTAssertThrowsError(try testDecoder.decode(Includes<Include2<TestEntity, TestEntity2>>.self, from: twenty_two_includes_one_bad_type)) { (error2: Error) -> Void in
            XCTAssertEqual(
                (error2 as? IncludesDecodingError).map(String.init(describing:)),
                """
                Out of 22 includes, the 21st one failed to parse: \nCould not have been Include Type `test_entity1` because:
                found JSON:API type "test_entity4" but expected "test_entity1"

                Could not have been Include Type `test_entity2` because:
                found JSON:API type "test_entity4" but expected "test_entity2"
                """
            )
        }
    }

    func test_missingProperty() {
        XCTAssertThrowsError(
            try testDecoder.decode(
                Includes<Include3<TestEntity, TestEntity2, TestEntity4>>.self,
                from: three_includes_one_missing_attributes
            )
        ) { (error: Error) -> Void in
            XCTAssertEqual(
                (error as? IncludesDecodingError).map(String.init(describing:)),
                """
                Out of 3 includes, the 3rd one failed to parse: \nCould not have been Include Type `test_entity1` because:
                found JSON:API type "test_entity2" but expected "test_entity1"

                Could not have been Include Type `test_entity2` because:
                'foo' attribute is required and missing.

                Could not have been Include Type `test_entity4` because:
                found JSON:API type "test_entity2" but expected "test_entity4"
                """
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
            let entity1: ToOneRelationship<TestEntity, NoMetadata, NoLinks>
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
            let entity4: ToOneRelationship<TestEntity4, NoMetadata, NoLinks>
        }
    }

    typealias TestEntity6 = BasicEntity<TestEntityType6>
}
