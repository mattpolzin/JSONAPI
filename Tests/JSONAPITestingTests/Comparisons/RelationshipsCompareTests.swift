//
//  RelationshipCompareTests.swift
//  
//
//  Created by Mathew Polzin on 11/5/19.
//

import XCTest
import JSONAPI
import JSONAPITesting

final class RelationshipsCompareTests: XCTestCase {
    func test_same() {
        let r1 = TestRelationships(
            a: t1,
            b: t2,
            c: t3,
            d: t4
        )
        let r2 = r1

        XCTAssertTrue(r1.compare(to: r2).allSatisfy { $0.value == .same })

        let r3 = TestRelationships(
            a: t1_differentId,
            b: t2_differentLinks,
            c: t3_differentId,
            d: t4_differentLinks
        )
        let r4 = r3

        XCTAssertTrue(r3.compare(to: r4).allSatisfy { $0.value == .same })

        let r5 = TestRelationships(
            a: nil,
            b: nil,
            c: nil,
            d: nil
        )
        let r6 = r5

        XCTAssertTrue(r5.compare(to: r6).allSatisfy { $0.value == .same })
    }

    func test_differentIds() {
        let r1 = TestRelationships(
            a: t1,
            b: nil,
            c: t3,
            d: nil
        )

        let r2 = TestRelationships(
            a: t1_differentId,
            b: nil,
            c: t3_differentId,
            d: nil
        )

        XCTAssertEqual(r1.compare(to: r2), [
            "a": .different("Id(123)", "Id(999)"),
            "b": .same,
            "c": .different("123, 456", "999, 1010"),
            "d": .same
        ])
    }

    func test_differentMetadata() {
        let r1 = TestRelationships(
            a: nil,
            b: t2,
            c: nil,
            d: t4
        )

        let r2 = TestRelationships(
            a: nil,
            b: t2_differentMeta,
            c: nil,
            d: t4_differentMeta
        )

        XCTAssertEqual(r1.compare(to: r2), [
            "a": .same,
            "b": .different(#"("Id(456)", "hello: world", "link: http://google.com")"#, #"("Id(456)", "hello: there", "link: http://google.com")"#),
            "c": .same,
            "d": .different(#"("123, 456", "hello: world", "link: http://google.com")"#, #"("123, 456", "hello: there", "link: http://google.com")"#)
        ])
    }

    func test_differentLinks() {
        let r1 = TestRelationships(
            a: nil,
            b: t2,
            c: nil,
            d: t4
        )

        let r2 = TestRelationships(
            a: nil,
            b: t2_differentLinks,
            c: nil,
            d: t4_differentLinks
        )

        XCTAssertEqual(r1.compare(to: r2), [
            "a": .same,
            "b": .different(#"("Id(456)", "hello: world", "link: http://google.com")"#, #"("Id(456)", "hello: world", "link: http://yahoo.com")"#),
            "c": .same,
            "d": .different(#"("123, 456", "hello: world", "link: http://google.com")"#, #"("123, 456", "hello: world", "link: http://yahoo.com")"#)
        ])
    }

    func test_nonRelationshipTypes() {
        let r1 = TestNonRelationships(
            a: .init(attributes: .none, relationships: .none, meta: .none, links: .none),
            b: false,
            c: 10,
            d: "1234"
        )

        XCTAssertEqual(r1.compare(to: r1), [
            "a": .prebuilt("comparison on non-JSON:API Relationship type (ResourceObject<TestTypeDescription, NoMetadata, NoLinks, String>) not supported."),
            "b": .prebuilt("comparison on non-JSON:API Relationship type (Bool) not supported."),
            "c": .prebuilt("comparison on non-JSON:API Relationship type (Int) not supported."),
            "d": .prebuilt("comparison on non-JSON:API Relationship type (Id<String, ResourceObject<TestTypeDescription, NoMetadata, NoLinks, String>>) not supported.")
        ])
    }

    let t1 = ToOneRelationship<TestType, NoMetadata, NoLinks>(id: "123")
    let t2 = ToOneRelationship<TestType, TestMeta, TestLinks>(id: "456", meta: .init(hello: "world"), links: .init(link: .init(url: "http://google.com")))
    let t3 = ToManyRelationship<TestType, NoMetadata, NoLinks>(ids: ["123", "456"])
    let t4 = ToManyRelationship<TestType, TestMeta, TestLinks>(ids: ["123", "456"], meta: .init(hello: "world"), links: .init(link: .init(url: "http://google.com")))

    let t1_differentId = ToOneRelationship<TestType, NoMetadata, NoLinks>(id: "999")
    let t3_differentId = ToManyRelationship<TestType, NoMetadata, NoLinks>(ids: ["999", "1010"])

    let t2_differentLinks = ToOneRelationship<TestType, TestMeta, TestLinks>(id: "456", meta: .init(hello: "world"), links: .init(link: .init(url: "http://yahoo.com")))
    let t4_differentLinks = ToManyRelationship<TestType, TestMeta, TestLinks>(ids: ["123", "456"], meta: .init(hello: "world"), links: .init(link: .init(url: "http://yahoo.com")))

    let t2_differentMeta = ToOneRelationship<TestType, TestMeta, TestLinks>(id: "456", meta: .init(hello: "there"), links: .init(link: .init(url: "http://google.com")))
    let t4_differentMeta = ToManyRelationship<TestType, TestMeta, TestLinks>(ids: ["123", "456"], meta: .init(hello: "there"), links: .init(link: .init(url: "http://google.com")))
}

// MARK: - Test Types
extension RelationshipsCompareTests {
    enum TestTypeDescription: ResourceObjectDescription {
        static let jsonType: String = "test"

        typealias Attributes = NoAttributes
        typealias Relationships = NoRelationships
    }

    typealias TestType = ResourceObject<TestTypeDescription, NoMetadata, NoLinks, String>

    struct TestMeta: JSONAPI.Meta, CustomDebugStringConvertible {
        let hello: String

        var debugDescription: String {
            "hello: \(hello)"
        }
    }

    struct TestLinks: JSONAPI.Links, CustomDebugStringConvertible {
        let link: Link<String, NoMetadata>

        var debugDescription: String {
            "link: \(link.url)"
        }
    }

    struct TestRelationships: JSONAPI.Relationships {
        let a: ToOneRelationship<TestType, NoMetadata, NoLinks>?
        let b: ToOneRelationship<TestType, TestMeta, TestLinks>?
        let c: ToManyRelationship<TestType, NoMetadata, NoLinks>?
        let d: ToManyRelationship<TestType, TestMeta, TestLinks>?
    }

    struct TestNonRelationships: JSONAPI.Relationships {
        let a: TestType
        let b: Bool
        let c: Int
        let d: JSONAPI.Id<String, TestType>
    }
}
