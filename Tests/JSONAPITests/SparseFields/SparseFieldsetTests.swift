//
//  SparseFieldsetTests.swift
//  
//
//  Created by Mathew Polzin on 8/4/19.
//

import XCTest
import Foundation
import JSONAPI
import JSONAPITesting

class SparseFieldsetTests: XCTestCase {
    func test_FullEncode() {
        let jsonEncoder = JSONEncoder()
        let sparseWithEverything = SparseFieldset(testEverythingObject, fields: EverythingTest.Attributes.CodingKeys.allCases)

        let encoded = try! jsonEncoder.encode(sparseWithEverything)

        let deserialized = try! JSONSerialization.jsonObject(with: encoded,
                                                             options: [])

        let outerDict = deserialized as? [String: Any]
        let id = outerDict?["id"] as? String
        let type = outerDict?["type"] as? String
        let attributesDict = outerDict?["attributes"] as? [String: Any]
        let relationships = outerDict?["relationships"]

        XCTAssertEqual(id, testEverythingObject.id.rawValue)
        XCTAssertEqual(type, EverythingTest.jsonType)
        XCTAssertNil(relationships)

        XCTAssertEqual(attributesDict?.count, 9) // note not 10 because one value is omitted intentionally at initialization
        XCTAssertEqual(attributesDict?["bool"] as? Bool,
                       testEverythingObject.bool)
        XCTAssertEqual(attributesDict?["int"] as? Int,
                       testEverythingObject.int)
        XCTAssertEqual(attributesDict?["double"] as? Double,
                       testEverythingObject.double)
        XCTAssertEqual(attributesDict?["string"] as? String,
                       testEverythingObject.string)
        XCTAssertEqual((attributesDict?["nestedStruct"] as? [String: String])?["hello"],
                       testEverythingObject.nestedStruct.hello)
        XCTAssertEqual(attributesDict?["nestedEnum"] as? String,
                       testEverythingObject.nestedEnum.rawValue)
        XCTAssertEqual(attributesDict?["array"] as? [Bool],
                       testEverythingObject.array)
        XCTAssertNil(attributesDict?["optional"])
        XCTAssertNotNil(attributesDict?["nullable"] as? NSNull)
        XCTAssertNotNil(attributesDict?["optionalNullable"] as? NSNull)
    }

    func test_PartialEncode() {
        let jsonEncoder = JSONEncoder()
        let sparseObject = SparseFieldset(testEverythingObject, fields: [.string, .bool, .array])

        let encoded = try! jsonEncoder.encode(sparseObject)

        let deserialized = try! JSONSerialization.jsonObject(with: encoded,
                                                             options: [])

        let outerDict = deserialized as? [String: Any]
        let id = outerDict?["id"] as? String
        let type = outerDict?["type"] as? String
        let attributesDict = outerDict?["attributes"] as? [String: Any]
        let relationships = outerDict?["relationships"]

        XCTAssertEqual(id, testEverythingObject.id.rawValue)
        XCTAssertEqual(type, EverythingTest.jsonType)
        XCTAssertNil(relationships)

        XCTAssertEqual(attributesDict?.count, 3)
        XCTAssertEqual(attributesDict?["bool"] as? Bool,
                       testEverythingObject.bool)
        XCTAssertNil(attributesDict?["int"])
        XCTAssertNil(attributesDict?["double"])
        XCTAssertEqual(attributesDict?["string"] as? String,
                       testEverythingObject.string)
        XCTAssertNil(attributesDict?["nestedStruct"])
        XCTAssertNil(attributesDict?["nestedEnum"])
        XCTAssertEqual(attributesDict?["array"] as? [Bool],
                       testEverythingObject.array)
        XCTAssertNil(attributesDict?["optional"])
        XCTAssertNil(attributesDict?["nullable"])
        XCTAssertNil(attributesDict?["optionalNullable"])
    }

    func test_sparseFieldsMethod() {
        let jsonEncoder = JSONEncoder()
        let sparseObject = testEverythingObject.sparse(with: [.string, .bool, .array])

        let encoded = try! jsonEncoder.encode(sparseObject)

        let deserialized = try! JSONSerialization.jsonObject(with: encoded,
                                                             options: [])

        let outerDict = deserialized as? [String: Any]
        let id = outerDict?["id"] as? String
        let type = outerDict?["type"] as? String
        let attributesDict = outerDict?["attributes"] as? [String: Any]
        let relationships = outerDict?["relationships"]

        XCTAssertEqual(id, testEverythingObject.id.rawValue)
        XCTAssertEqual(type, EverythingTest.jsonType)
        XCTAssertNil(relationships)

        XCTAssertEqual(attributesDict?.count, 3)
        XCTAssertEqual(attributesDict?["bool"] as? Bool,
                       testEverythingObject.bool)
        XCTAssertNil(attributesDict?["int"])
        XCTAssertNil(attributesDict?["double"])
        XCTAssertEqual(attributesDict?["string"] as? String,
                       testEverythingObject.string)
        XCTAssertNil(attributesDict?["nestedStruct"])
        XCTAssertNil(attributesDict?["nestedEnum"])
        XCTAssertEqual(attributesDict?["array"] as? [Bool],
                       testEverythingObject.array)
        XCTAssertNil(attributesDict?["optional"])
        XCTAssertNil(attributesDict?["nullable"])
        XCTAssertNil(attributesDict?["optionalNullable"])
    }
}

struct EverythingTestDescription: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "everything"

    struct Attributes: JSONAPI.SparsableAttributes {
        let bool: Attribute<Bool>
        let int: Attribute<Int>
        let double: Attribute<Double>
        let string: Attribute<String>
        let nestedStruct: Attribute<NestedStruct>
        let nestedEnum: Attribute<NestedEnum>

        let array: Attribute<[Bool]>
        let optional: Attribute<Bool>?
        let nullable: Attribute<Bool?>
        let optionalNullable: Attribute<Bool?>?

        struct NestedStruct: Codable, Equatable {
            let hello: String
        }

        enum NestedEnum: String, Codable, Equatable {
            case hello
            case world
        }

        enum CodingKeys: String, CodingKey, Equatable, CaseIterable {
            case bool
            case int
            case double
            case string
            case nestedStruct
            case nestedEnum
            case array
            case optional
            case nullable
            case optionalNullable
        }
    }

    typealias Relationships = NoRelationships
}

typealias EverythingTest = JSONAPI.ResourceObject<EverythingTestDescription, NoMetadata, NoLinks, String>

let testEverythingObject = EverythingTest(attributes: .init(bool: true,
                                                            int: 10,
                                                            double: 10.5,
                                                            string: "hello world",
                                                            nestedStruct: .init(value: .init(hello: "world")),
                                                            nestedEnum: .init(value: .hello),
                                                            array: [true, false, false],
                                                            optional: nil,
                                                            nullable: .init(value: nil),
                                                            optionalNullable: .init(value: nil)),
                                          relationships: .none,
                                          meta: .none,
                                          links: .none)
