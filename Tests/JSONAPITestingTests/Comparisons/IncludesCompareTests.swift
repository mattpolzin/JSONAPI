//
//  IncludeCompareTests.swift
//  
//
//  Created by Mathew Polzin on 11/4/19.
//

import XCTest
import JSONAPI
import JSONAPITesting
import Poly

final class IncludesCompareTests: XCTestCase {
    func test_same() {
        let includes1 = Includes(values: justTypeOnes)
        let includes2 = Includes(values: justTypeOnes)
        XCTAssertTrue(includes1.compare(to: includes2).differences.isEmpty)

        let includes3 = Includes(values: longerTypeOnes)
        let includes4 = Includes(values: longerTypeOnes)
        XCTAssertTrue(includes3.compare(to: includes4).differences.isEmpty)

        let includes5 = Includes(values: onesAndTwos)
        let includes6 = Includes(values: onesAndTwos)
        XCTAssertTrue(includes5.compare(to: includes6).differences.isEmpty)
    }

    func test_missing() {
        let includes1 = Includes(values: justTypeOnes)
        let includes2 = Includes(values: longerTypeOnes)
        XCTAssertEqual(includes1.compare(to: includes2).differences, ["include 3": "missing"])
        XCTAssertEqual(includes2.compare(to: includes1).differences, ["include 3": "missing"])
    }

    func test_typeMismatch() {
        let includes1 = Includes(values: onesAndTwos)
        let includes2 = Includes(values: justTypeOnes)
        XCTAssertEqual(includes1.compare(to: includes2).differences, ["include 2": "ResourceObject<TestDescription2, NoMetadata, NoLinks, String> ≠ ResourceObject<TestDescription1, NoMetadata, NoLinks, String>"])
        XCTAssertEqual(includes2.compare(to: includes1).differences, ["include 2": "ResourceObject<TestDescription1, NoMetadata, NoLinks, String> ≠ ResourceObject<TestDescription2, NoMetadata, NoLinks, String>"])
    }

    func test_valueMismatch() {
        let includes1 = Includes(values: onesAndTwos)
        let includes2 = Includes(values: differentOnesAndTwos)
        XCTAssertEqual(includes1.compare(to: includes2).differences, [
            "include 1": #"'favoriteColor' attribute: Optional("red") ≠ nil, 'name' attribute: Matt ≠ Todd, 'parents' relationship: 4, 5 ≠ 7, 8, id: 1 ≠ 2"#
        ])
    }

    fileprivate let justTypeOnes: [Poly2<TestType1, TestType2>] = [
        .a(
            TestType1(
                id: "1",
                attributes: .init(
                    name: "Matt",
                    age: 23,
                    favoriteColor: "red"
                ),
                relationships: .init(
                    bestFriend: "3",
                    parents: ["4", "5"]
                ),
                meta: .none,
                links: .none
            )
        ),
        .a(
            TestType1(
                id: "3",
                attributes: .init(
                    name: "Helen",
                    age: 24,
                    favoriteColor: nil
                ),
                relationships: .init(
                    bestFriend: nil,
                    parents: ["2"]
                ),
                meta: .none,
                links: .none
            )
        )
    ]

    fileprivate let longerTypeOnes: [Poly2<TestType1, TestType2>] = [
        .a(
            TestType1(
                id: "1",
                attributes: .init(
                    name: "Matt",
                    age: 23,
                    favoriteColor: "red"
                ),
                relationships: .init(
                    bestFriend: "3",
                    parents: ["4", "5"]
                ),
                meta: .none,
                links: .none
            )
        ),
        .a(
            TestType1(
                id: "3",
                attributes: .init(
                    name: "Helen",
                    age: 24,
                    favoriteColor: nil
                ),
                relationships: .init(
                    bestFriend: nil,
                    parents: ["2"]
                ),
                meta: .none,
                links: .none
            )
        ),
        .a(
            TestType1(
                id: "2",
                attributes: .init(
                    name: "Troy",
                    age: 45,
                    favoriteColor: "blue"
                ),
                relationships: .init(
                    bestFriend: nil,
                    parents: []
                ),
                meta: .none,
                links: .none
            )
        )
    ]

    fileprivate let onesAndTwos: [Poly2<TestType1, TestType2>] = [
        .a(
            TestType1(
                id: "1",
                attributes: .init(
                    name: "Matt",
                    age: 23,
                    favoriteColor: "red"
                ),
                relationships: .init(
                    bestFriend: "3",
                    parents: ["4", "5"]
                ),
                meta: .none,
                links: .none
            )
        ),
        .b(
            TestType2(
                id: "1",
                attributes: .init(
                    name: "Lucy",
                    age: 33,
                    favoriteColor: nil
                ),
                relationships: .init(
                    bestFriend: nil,
                    parents: []
                ),
                meta: .none,
                links: .none
            )
        )
    ]

    fileprivate let differentOnesAndTwos: [Poly2<TestType1, TestType2>] = [
        .a(
            TestType1(
                id: "2",
                attributes: .init(
                    name: "Todd",
                    age: 23,
                    favoriteColor: nil
                ),
                relationships: .init(
                    bestFriend: "3",
                    parents: ["7", "8"]
                ),
                meta: .none,
                links: .none
            )
        ),
        .b(
            TestType2(
                id: "1",
                attributes: .init(
                    name: "Lucy",
                    age: 33,
                    favoriteColor: nil
                ),
                relationships: .init(
                    bestFriend: nil,
                    parents: []
                ),
                meta: .none,
                links: .none
            )
        )
    ]
}

private enum TestDescription1: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "test_type1"

    struct Attributes: JSONAPI.Attributes {
        let name: Attribute<String>
        let age: Attribute<Int>
        let favoriteColor: Attribute<String?>
    }

    struct Relationships: JSONAPI.Relationships {
        let bestFriend: ToOneRelationship<TestType1?, NoIdMetadata, NoMetadata, NoLinks>
        let parents: ToManyRelationship<TestType1, NoIdMetadata, NoMetadata, NoLinks>
    }
}

private typealias TestType1 = ResourceObject<TestDescription1, NoMetadata, NoLinks, String>

private enum TestDescription2: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "test_type2"

    struct Attributes: JSONAPI.Attributes {
        let name: Attribute<String>
        let age: Attribute<Int>
        let favoriteColor: Attribute<String?>
    }

    struct Relationships: JSONAPI.Relationships {
        let bestFriend: ToOneRelationship<TestType2?, NoIdMetadata, NoMetadata, NoLinks>
        let parents: ToManyRelationship<TestType2, NoIdMetadata, NoMetadata, NoLinks>
    }
}

private typealias TestType2 = ResourceObject<TestDescription2, NoMetadata, NoLinks, String>
