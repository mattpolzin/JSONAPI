//
//  SwiftIdentifiableTests.swift
//  
//
//  Created by Mathew Polzin on 5/29/20.
//

import JSONAPI
import XCTest

final class SwiftIdentifiableTests: XCTestCase {
    @available(OSX 10.15, iOS 13, tvOS 13, watchOS 6, *)
    func test_identifiableConformance() {
        let t1 = TestType(attributes: .none, relationships: .none, meta: .none, links: .none)
        let t2 = TestType(attributes: .none, relationships: .none, meta: .none, links: .none)

        var hash = [AnyHashable: String]()
        func storeErased<T: Identifiable>(_ thing: T) {
            hash[thing.id] = String(describing: thing.id)
        }

        storeErased(t1)
        storeErased(t2)

        XCTAssertEqual(hash[t1.id], String(describing: t1.id))
        XCTAssertEqual(hash[t2.id], String(describing: t2.id))
    }

    func test_Id_ID_equivalence() {
        // it's not at all great to have both of these names for
        // the Id type, but I could not do better than this and
        // still have a typealias for the Id type on the
        // ResourceObjectProxy protocol. One protocol's typealias
        // will collide with anotehr protocol's associatedtype in
        // very ugly ways.

        XCTAssert(TestType.ID.self == TestType.Id.self)

        XCTAssertEqual(TestType.ID(rawValue: "hello"), TestType.Id(rawValue: "hello"))
    }
}

fileprivate enum TestDescription: JSONAPI.ResourceObjectDescription {
    static let jsonType: String = "test"

    typealias Attributes = NoAttributes
    typealias Relationships = NoRelationships
}

fileprivate typealias TestType = ResourceObject<TestDescription, NoMetadata, NoLinks, String>
