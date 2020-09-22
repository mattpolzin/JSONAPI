//
//  ResourceObjectCompareTests.swift
//  
//
//  Created by Mathew Polzin on 11/3/19.
//

import XCTest
import JSONAPI
import JSONAPITesting

final class ResourceObjectCompareTests: XCTestCase {
    func test_same() {
        XCTAssertTrue(test1.compare(to: test1).differences.isEmpty)
        XCTAssertTrue(test1_differentId.compare(to: test1_differentId).differences.isEmpty)
        XCTAssertTrue(test1_differentAttributes.compare(to: test1_differentAttributes).differences.isEmpty)
    }

    func test_differentAttributes() {
        XCTAssertEqual(test1.compare(to: test1_differentAttributes).differences, [
            "'favoriteColor' attribute": #"Optional("red") ≠ nil"#,
            "'name' attribute": "James ≠ Fred",
            "'age' attribute": "12 ≠ 10"
        ])
    }

    func test_differentRelationships() {
        XCTAssertEqual(test1.compare(to: test1_differentRelationships).differences, [
            "'parents' relationship": "4, 5 ≠ 3",
            "'bestFriend' relationship": "Optional(Id(3)) ≠ nil"
        ])
    }

    func test_differentIds() {
        XCTAssertEqual(test1.compare(to: test1_differentId).differences, [
            "id": "2 ≠ 3"
        ])
    }

    func test_differentMetadata() {
        let test1 = TestType2(
            id: "2",
            attributes: .none,
            relationships: .none,
            meta: .init(total: 10),
            links: .init(link: .init(url: "http://google.com"))
        )
        let test1_differentMeta = TestType2(
            id: "2",
            attributes: .none,
            relationships: .none,
            meta: .init(total: 12),
            links: .init(link: .init(url: "http://google.com"))
        )

        XCTAssertEqual(test1.compare(to: test1_differentMeta).differences, [
            "meta": "total: 10 ≠ total: 12"
        ])
    }

    func test_differentLinks() {
        let test1 = TestType2(
            id: "2",
            attributes: .none,
            relationships: .none,
            meta: .init(total: 10),
            links: .init(link: .init(url: "http://google.com"))
        )
        let test1_differentLinks = TestType2(
            id: "2",
            attributes: .none,
            relationships: .none,
            meta: .init(total: 10),
            links: .init(link: .init(url: "http://yahoo.com"))
        )

        XCTAssertEqual(test1.compare(to: test1_differentLinks).differences, [
            "links": "link: http://google.com ≠ link: http://yahoo.com"
        ])
    }

    fileprivate let test1 = TestType(
        id: "2",
        attributes: .init(
            name: "James",
            age: 12,
            favoriteColor: "red"),
        relationships: .init(
            bestFriend: "3",
            parents: ["4", "5"]
        ),
        meta: .none,
        links: .none
    )

    fileprivate let test1_differentId = TestType(
        id: "3",
        attributes: .init(
            name: "James",
            age: 12,
            favoriteColor: "red"),
        relationships: .init(
            bestFriend: "3",
            parents: ["4", "5"]
        ),
        meta: .none,
        links: .none
    )

    fileprivate let test1_differentAttributes = TestType(
        id: "2",
        attributes: .init(
            name: "Fred",
            age: 10,
            favoriteColor: .init(value: nil)),
        relationships: .init(
            bestFriend: "3",
            parents: ["4", "5"]
        ),
        meta: .none,
        links: .none
    )

    fileprivate let test1_differentRelationships = TestType(
        id: "2",
        attributes: .init(
            name: "James",
            age: 12,
            favoriteColor: "red"),
        relationships: .init(
            bestFriend: nil,
            parents: ["3"]
        ),
        meta: .none,
        links: .none
    )
}

private enum TestDescription: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "test_type"

    struct Attributes: JSONAPI.Attributes {
        let name: Attribute<String>
        let age: Attribute<Int>
        let favoriteColor: Attribute<String?>
    }

    struct Relationships: JSONAPI.Relationships {
        let bestFriend: ToOneRelationship<TestType?, NoIdMetadata, NoMetadata, NoLinks>
        let parents: ToManyRelationship<TestType, NoIdMetadata, NoMetadata, NoLinks>
    }
}

private typealias TestType = ResourceObject<TestDescription, NoMetadata, NoLinks, String>

private struct TestMetadata: JSONAPI.Meta, CustomStringConvertible {
    let total: Int

    var description: String {
        "total: \(total)"
    }
}

private struct TestLinks: JSONAPI.Links, CustomStringConvertible {
    let link: Link<String, NoMetadata>

    var description: String {
        "link: \(link.url)"
    }
}

private enum TestDescription2: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "test_type2"

    typealias Attributes = NoAttributes

    typealias Relationships = NoRelationships
}

private typealias TestType2 = ResourceObject<TestDescription2, TestMetadata, TestLinks, String>
