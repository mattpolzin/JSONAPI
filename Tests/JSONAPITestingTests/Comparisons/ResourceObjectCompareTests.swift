//
//  File.swift
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
        XCTAssertTrue(test2.compare(to: test2).differences.isEmpty)
    }

    func test_different() {
        // TODO: write actual test
        print(test1.compare(to: test2).differences.map { "\($0): \($1)" }.joined(separator: ", "))
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

    fileprivate let test2 = TestType(
        id: "3",
        attributes: .init(
            name: "Fred",
            age: 10,
            favoriteColor: .init(value: nil)),
        relationships: .init(
            bestFriend: nil,
            parents: ["1"]
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
        let bestFriend: ToOneRelationship<TestType?, NoMetadata, NoLinks>
        let parents: ToManyRelationship<TestType, NoMetadata, NoLinks>
    }
}

private typealias TestType = ResourceObject<TestDescription, NoMetadata, NoLinks, String>
