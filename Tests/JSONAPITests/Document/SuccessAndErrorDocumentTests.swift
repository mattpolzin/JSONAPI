//
//  SuccessAndErrorDocumentTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/19.
//

import XCTest
import JSONAPI

final class SuccessAndErrorDocumentTests: XCTestCase {
    func test_errorAccessors() {
        let apiDescription = TestErrorDocument.APIDescription(
            version: "1.0",
            meta: .none
        )
        let errors = [
            BasicJSONAPIError<String>.error(.init(status: "500"))
        ]
        let meta = TestMeta(hello: "world")
        let links = TestLinks(testLink: .init(url: "http://google.com"))
        let errorDoc = TestErrorDocument(
            apiDescription: apiDescription,
            errors: errors,
            meta: meta,
            links: links
        )

        guard case let .errors(testErrors, meta: testMeta, links: testLinks) = errorDoc.body else {
            XCTFail("Expected an error body")
            return
        }

        XCTAssertEqual(testErrors, errors)
        XCTAssertEqual(testMeta, meta)
        XCTAssertEqual(testLinks, links)

        XCTAssertEqual(errorDoc.apiDescription, apiDescription)
        XCTAssertEqual(errorDoc.errors, errors)
        XCTAssertEqual(errorDoc.meta, meta)
        XCTAssertEqual(errorDoc.links, links)

        let equivalentDocument = TestDocument(
            apiDescription: apiDescription,
            errors: errors,
            meta: meta,
            links: links
        )

        XCTAssert(equivalentDocument == errorDoc)
        XCTAssert(errorDoc == equivalentDocument)
    }

    func test_successAccessors() {
        let apiDescription = TestErrorDocument.APIDescription(
            version: "1.0",
            meta: .none
        )
        let primaryResource = TestType(
            id: "123",
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )
        let resourceBody = SingleResourceBody(resourceObject: primaryResource)
        let includedResource = TestType(
            id: "456",
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )
        let includes = Includes<TestDocument.Include>(values: [.init(includedResource)])
        let meta = TestMeta(hello: "world")
        let links = TestLinks(testLink: .init(url: "http://google.com"))
        let successDoc = TestSuccessDocument(
            apiDescription: apiDescription,
            body: resourceBody,
            includes: includes,
            meta: meta,
            links: links
        )

        guard case let .data(data) = successDoc.body else {
            XCTFail("Expected an data body")
            return
        }

        XCTAssertEqual(data.primary, resourceBody)
        XCTAssertEqual(data.includes, includes)
        XCTAssertEqual(data.meta, meta)
        XCTAssertEqual(data.links, links)

        XCTAssertEqual(successDoc.data, data)
        XCTAssertEqual(successDoc.apiDescription, apiDescription)
        XCTAssertEqual(successDoc.primaryResource, resourceBody)
        XCTAssertEqual(successDoc.includes, includes)
        XCTAssertEqual(successDoc.meta, meta)
        XCTAssertEqual(successDoc.links, links)

        let equivalentDocument = TestDocument(
            apiDescription: apiDescription,
            body: resourceBody,
            includes: includes,
            meta: meta,
            links: links
        )

        XCTAssert(equivalentDocument == successDoc)
        XCTAssert(successDoc == equivalentDocument)
    }
}

// MARK: - Test Type
extension SuccessAndErrorDocumentTests {
    enum TestTypeDescription: ResourceObjectDescription {
        static let jsonType: String = "tests"

        typealias Attributes = NoAttributes

        typealias Relationships = NoRelationships
    }

    struct TestMeta: JSONAPI.Meta {
        let hello: String
    }

    struct TestLinks: JSONAPI.Links {
        let testLink: Link<String, NoMetadata>
    }

    typealias TestType = ResourceObject<TestTypeDescription, NoMetadata, NoLinks, String>

    typealias TestDocument = Document<SingleResourceBody<TestType>, TestMeta, TestLinks, Include1<TestType>, APIDescription<NoMetadata>, BasicJSONAPIError<String>>

    typealias TestSuccessDocument = TestDocument.SuccessDocument
    typealias TestErrorDocument = TestDocument.ErrorDocument
}
