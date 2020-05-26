//
//  ResourceObject+HashableTests.swift
//  
//
//  Created by Mathew Polzin on 5/26/20.
//

import XCTest
import JSONAPI
import JSONAPITesting

class ResourceObjectHashableTests: XCTestCase {

    func test_hashable_sameProeprties() {
        let t1 = ResourceObject<ResourceObjectTests.TestEntityType5, NoMetadata, NoLinks, String>(
            id: "hello",
            attributes: .init(floater: 1234),
            relationships: .none,
            meta: .none,
            links: .none
        )

        let t2 = ResourceObject<ResourceObjectTests.TestEntityType5, NoMetadata, NoLinks, String>(
            id: "hello",
            attributes: .init(floater: 1234),
            relationships: .none,
            meta: .none,
            links: .none
        )

        let t3 = ResourceObject<ResourceObjectTests.TestEntityType5, NoMetadata, NoLinks, String>(
            id: "world",
            attributes: .init(floater: 1234),
            relationships: .none,
            meta: .none,
            links: .none
        )

        XCTAssertEqual(t1, t2)
        XCTAssertEqual(t1.hashValue, t2.hashValue)

        XCTAssertEqual(t1.attributes, t3.attributes)
        XCTAssertEqual(t1.relationships, t3.relationships)
        XCTAssertEqual(t1.meta, t3.meta)
        XCTAssertEqual(t1.links, t3.links)
        XCTAssertNotEqual(t1, t3)
        XCTAssertNotEqual(t1.hashValue, t3.hashValue)
    }

    func test_hashable_differentProeprties() {
        let t1 = ResourceObject<ResourceObjectTests.TestEntityType5, NoMetadata, NoLinks, String>(
            id: "hello",
            attributes: .init(floater: 1234),
            relationships: .none,
            meta: .none,
            links: .none
        )

        let t2 = ResourceObject<ResourceObjectTests.TestEntityType5, NoMetadata, NoLinks, String>(
            id: "hello",
            attributes: .init(floater: 11111),
            relationships: .none,
            meta: .none,
            links: .none
        )

        let t3 = ResourceObject<ResourceObjectTests.TestEntityType5, NoMetadata, NoLinks, String>(
            id: "world",
            attributes: .init(floater: 1111),
            relationships: .none,
            meta: .none,
            links: .none
        )

        XCTAssertNotEqual(t1, t2)
        XCTAssertEqual(t1.hashValue, t2.hashValue)

        XCTAssertNotEqual(t1.attributes, t3.attributes)
        XCTAssertEqual(t1.relationships, t3.relationships)
        XCTAssertEqual(t1.meta, t3.meta)
        XCTAssertEqual(t1.links, t3.links)
        XCTAssertNotEqual(t1, t3)
        XCTAssertNotEqual(t1.hashValue, t3.hashValue)
    }

    func test_hashable_differentTypes() {
        let t1 = ResourceObject<ResourceObjectTests.TestEntityType1, NoMetadata, NoLinks, String>(
            id: "hello",
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let t2 = ResourceObject<ResourceObjectTests.TestEntityType5, NoMetadata, NoLinks, String>(
            id: "hello",
            attributes: .init(floater: 1234),
            relationships: .none,
            meta: .none,
            links: .none
        )

        let t3 = ResourceObject<ResourceObjectTests.TestEntityType5, NoMetadata, NoLinks, String>(
            id: "world",
            attributes: .init(floater: 1234),
            relationships: .none,
            meta: .none,
            links: .none
        )

        XCTAssertNotEqual(t1.hashValue, t2.hashValue)

        XCTAssertNotEqual(t1.hashValue, t3.hashValue)
    }
}

extension ResourceObjectHashableTests {

}
