//
//  ResourceObject+ReplacingTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 10/12/19.
//

import XCTest
import JSONAPI

final class ResourceObjectReplacingTests: XCTestCase {
    func test_replaceMutableAttributes() {
        let testResource = MutableTestType(attributes: .init(name: .init(value: "Matt")),
                                           relationships: .init(other: .init(id: .init(rawValue: "2"))),
                                           meta: .none,
                                           links: .none)

        let mutatedResource = testResource
            .replacingAttributes {
                var newAttributes = $0
                newAttributes.name = .init(value: "Matt 2")
                return newAttributes
        }

        XCTAssertEqual(testResource.name, "Matt")
        XCTAssertEqual(mutatedResource.name, "Matt 2")
    }

    func test_tapMutableAttributes() {
        let testResource = MutableTestType(attributes: .init(name: .init(value: "Matt")),
                                           relationships: .init(other: .init(id: .init(rawValue: "2"))),
                                           meta: .none,
                                           links: .none)

        let mutatedResource = testResource
            .tappingAttributes { $0.name = .init(value: "Matt 2") }

        XCTAssertEqual(testResource.name, "Matt")
        XCTAssertEqual(mutatedResource.name, "Matt 2")
    }

    func test_replaceImmutableAttributes() {
        let testResource = ImmutableTestType(attributes: .init(name: .init(value: "Matt")),
                                             relationships: .init(other: .init(id: .init(rawValue: "2"))),
                                             meta: .none,
                                             links: .none)

        let mutatedResource = testResource
            .replacingAttributes {
                return .init(name: $0.name.map { $0 + " 2" })
        }

        XCTAssertEqual(testResource.name, "Matt")
        XCTAssertEqual(mutatedResource.name, "Matt 2")
    }

    func test_tapImmutableAttributes() {
        let testResource = ImmutableTestType(attributes: .init(name: .init(value: "Matt")),
                                             relationships: .init(other: .init(id: .init(rawValue: "2"))),
                                             meta: .none,
                                             links: .none)

        let mutatedResource = testResource
            .tappingAttributes { $0 = .init(name: $0.name.map { $0 + " 2" }) }

        XCTAssertEqual(testResource.name, "Matt")
        XCTAssertEqual(mutatedResource.name, "Matt 2")
    }

    func test_replaceMutableRelationships() {
        let testResource = MutableTestType(attributes: .init(name: .init(value: "Matt")),
                                           relationships: .init(other: .init(id: .init(rawValue: "2"))),
                                           meta: .none,
                                           links: .none)

        let mutatedResource = testResource
            .replacingRelationships {
                var newRelationships = $0
                newRelationships.other = .init(id: .init(rawValue: "3"))
                return newRelationships
        }

        XCTAssertEqual(testResource ~> \.other, "2")
        XCTAssertEqual(mutatedResource ~> \.other, "3")
    }

    func test_tapMutableRelationships() {
        let testResource = MutableTestType(attributes: .init(name: .init(value: "Matt")),
                                           relationships: .init(other: .init(id: .init(rawValue: "2"))),
                                           meta: .none,
                                           links: .none)

        let mutatedResource = testResource
            .tappingRelationships { $0.other = .init(id: .init(rawValue: "3")) }

        XCTAssertEqual(testResource ~> \.other, "2")
        XCTAssertEqual(mutatedResource ~> \.other, "3")
    }

    func test_replaceImmutableRelationships() {
        let testResource = ImmutableTestType(attributes: .init(name: .init(value: "Matt")),
                                             relationships: .init(other: .init(id: .init(rawValue: "2"))),
                                             meta: .none,
                                             links: .none)

        let mutatedResource = testResource
            .replacingRelationships { _ in
                return .init(other: .init(id: .init(rawValue: "3")))
        }

        XCTAssertEqual(testResource ~> \.other, "2")
        XCTAssertEqual(mutatedResource ~> \.other, "3")
    }

    func test_tapImmutableRelationships() {
        let testResource = ImmutableTestType(attributes: .init(name: .init(value: "Matt")),
                                             relationships: .init(other: .init(id: .init(rawValue: "2"))),
                                             meta: .none,
                                             links: .none)

        let mutatedResource = testResource
            .tappingRelationships { $0 = .init(other: .init(id: .init(rawValue: "3"))) }

        XCTAssertEqual(testResource ~> \.other, "2")
        XCTAssertEqual(mutatedResource ~> \.other, "3")
    }
}

private enum MutableTestDescription: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "test"

    struct Attributes: JSONAPI.Attributes {
        var name: Attribute<String>
    }

    struct Relationships: JSONAPI.Relationships {
        var other: ToOneRelationship<MutableTestType, NoIdMetadata, NoMetadata, NoLinks>
    }
}

private typealias MutableTestType = JSONAPI.ResourceObject<MutableTestDescription, NoMetadata, NoLinks, String>

private enum ImmutableTestDescription: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "test2"

    struct Attributes: JSONAPI.Attributes {
        let name: Attribute<String>
    }

    struct Relationships: JSONAPI.Relationships {
        let other: ToOneRelationship<ImmutableTestType, NoIdMetadata, NoMetadata, NoLinks>
    }
}

private typealias ImmutableTestType = JSONAPI.ResourceObject<ImmutableTestDescription, NoMetadata, NoLinks, String>
