//
//  DocumentCompareTests.swift
//  
//
//  Created by Mathew Polzin on 11/4/19.
//

import XCTest
import JSONAPI
import JSONAPITesting

final class DocumentCompareTests: XCTestCase {
    func test_same() {
        XCTAssertTrue(d1.compare(to: d1).differences.isEmpty)
        XCTAssertTrue(d2.compare(to: d2).differences.isEmpty)
        XCTAssertTrue(d3.compare(to: d3).differences.isEmpty)
        XCTAssertTrue(d4.compare(to: d4).differences.isEmpty)
        XCTAssertTrue(d5.compare(to: d5).differences.isEmpty)
        XCTAssertTrue(d6.compare(to: d6).differences.isEmpty)
        XCTAssertTrue(d7.compare(to: d7).differences.isEmpty)
        XCTAssertTrue(d8.compare(to: d8).differences.isEmpty)
        XCTAssertTrue(d9.compare(to: d9).differences.isEmpty)
        XCTAssertTrue(d10.compare(to: d10).differences.isEmpty)
    }

    func test_errorAndData() {
        XCTAssertEqual(d1.compare(to: d2).differences, [
            "Body": "data response ≠ error response"
        ])

        XCTAssertEqual(d2.compare(to: d1).differences, [
            "Body": "error response ≠ data response"
        ])
    }

    func test_differentErrors() {
        XCTAssertEqual(d2.compare(to: d4).differences, [
            "Body": "status: 500, title: Internal Error ≠ status: 404, title: Not Found"
        ])
    }

    func test_differentData() {
        XCTAssertEqual(d3.compare(to: d5).differences, [
            "Body": "(Includes: (include 2: missing)), (Primary Resource: (resource 2: missing))"
        ])

        XCTAssertEqual(d3.compare(to: d6).differences, [
            "Body": ##"(Includes: (include 2: missing)), (Primary Resource: (resource 2: 'age' attribute: 10 ≠ 12, 'bestFriend' relationship: Optional(Id(2)) ≠ nil, 'favoriteColor' attribute: nil ≠ Optional("blue"), 'name' attribute: name ≠ Fig, id: 1 ≠ 5), (resource 3: missing))"##
        ])

        XCTAssertEqual(d7.compare(to: d8).differences, [
            "Body": ##"(Primary Resource: nil ≠ ResourceObject<TestDescription, NoMetadata, NoLinks, String>)"##
        ])

        XCTAssertEqual(d8.compare(to: d9).differences, [
            "Body": ##"(Primary Resource: ('age' attribute: 10 ≠ 12), ('bestFriend' relationship: Optional(Id(2)) ≠ nil), ('favoriteColor' attribute: nil ≠ Optional("blue")), ('name' attribute: name ≠ Fig), (id: 1 ≠ 5))"##
        ])

        XCTAssertEqual(d1.compare(to: d10).differences, [
            "Body": ##"(Primary Resource: (resource 1: 'age' attribute: 10 ≠ 12, 'bestFriend' relationship: Optional(Id(2)) ≠ nil, 'favoriteColor' attribute: nil ≠ Optional("blue"), 'name' attribute: name ≠ Fig, id: 1 ≠ 5))"##
        ])
    }
}

fileprivate enum TestDescription: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "test_type"

    struct Attributes: JSONAPI.Attributes {
        let name: Attribute<String>
        let age: Attribute<Int>
        let favoriteColor: Attribute<String?>
    }

    struct Relationships: JSONAPI.Relationships {
        let bestFriend: ToOneRelationship<TestType2?, NoMetadata, NoLinks>
        let parents: ToManyRelationship<TestType, NoMetadata, NoLinks>
    }
}

fileprivate typealias TestType = ResourceObject<TestDescription, NoMetadata, NoLinks, String>

fileprivate enum TestDescription2: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "test_type2"

    struct Attributes: JSONAPI.Attributes {
        let name: Attribute<String>
        let age: Attribute<Int>
        let favoriteColor: Attribute<String?>
    }

    struct Relationships: JSONAPI.Relationships {
        let bestFriend: ToOneRelationship<TestType2?, NoMetadata, NoLinks>
        let parents: ToManyRelationship<TestType2, NoMetadata, NoLinks>
    }
}

fileprivate typealias TestType2 = ResourceObject<TestDescription2, NoMetadata, NoLinks, String>

fileprivate typealias SingleDocument = JSONAPI.Document<SingleResourceBody<TestType>, NoMetadata, NoLinks, Include2<TestType, TestType2>, NoAPIDescription, BasicJSONAPIError<String>>

fileprivate typealias OptionalSingleDocument = JSONAPI.Document<SingleResourceBody<TestType?>, NoMetadata, NoLinks, Include2<TestType, TestType2>, NoAPIDescription, BasicJSONAPIError<String>>

fileprivate typealias ManyDocument = JSONAPI.Document<ManyResourceBody<TestType>, NoMetadata, NoLinks, Include2<TestType, TestType2>, NoAPIDescription, BasicJSONAPIError<String>>

fileprivate let r1 = TestType(
    id: "1",
    attributes: .init(
        name: "name",
        age: 10,
        favoriteColor: nil
    ),
    relationships: .init(
        bestFriend: "2",
        parents: ["3", "4"]
    ),
    meta: .none,
    links: .none
)

fileprivate let r2 = TestType(
    id: "5",
    attributes: .init(
        name: "Fig",
        age: 12,
        favoriteColor: "blue"
    ),
    relationships: .init(
        bestFriend: nil,
        parents: ["3", "4"]
    ),
    meta: .none,
    links: .none
)

fileprivate let r3 = TestType2(
    id: "2",
    attributes: .init(
        name: "Tully",
        age: 100,
        favoriteColor: "red"
    ),
    relationships: .init(
        bestFriend: nil,
        parents: []
    ),
    meta: .none,
    links: .none
)

fileprivate let d1 = SingleDocument(
    apiDescription: .none,
    body: .init(resourceObject: r1),
    includes: .none,
    meta: .none,
    links: .none
)

fileprivate let d2 = SingleDocument(
    apiDescription: .none,
    errors: [.error(.init(id: nil, status: "500", title: "Internal Error"))]
)

fileprivate let d3 = ManyDocument(
    apiDescription: .none,
    body: .init(resourceObjects: [r1, r2]),
    includes: .init(values: [.init(r3)]),
    meta: .none,
    links: .none
)

fileprivate let d4 = SingleDocument(
    apiDescription: .none,
    errors: [.error(.init(id: nil, status: "404", title: "Not Found"))]
)

fileprivate let d5 = ManyDocument(
    apiDescription: .none,
    body: .init(resourceObjects: [r1]),
    includes: .init(values: [.init(r3), .init(r2)]),
    meta: .none,
    links: .none
)

fileprivate let d6 = ManyDocument(
    apiDescription: .none,
    body: .init(resourceObjects: [r1, r1, r2]),
    includes: .init(values: [.init(r3), .init(r2)]),
    meta: .none,
    links: .none
)

fileprivate let d7 = OptionalSingleDocument(
    apiDescription: .none,
    body: .init(resourceObject: nil),
    includes: .none,
    meta: .none,
    links: .none
)

fileprivate let d8 = OptionalSingleDocument(
    apiDescription: .none,
    body: .init(resourceObject: r1),
    includes: .none,
    meta: .none,
    links: .none
)

fileprivate let d9 = OptionalSingleDocument(
    apiDescription: .none,
    body: .init(resourceObject: r2),
    includes: .none,
    meta: .none,
    links: .none
)

fileprivate let d10 = SingleDocument(
    apiDescription: .none,
    body: .init(resourceObject: r2),
    includes: .none,
    meta: .none,
    links: .none
)
