//
//  DocumentCompoundResourceTests.swift
//  
//
//  Created by Mathew Polzin on 5/25/20.
//

import Foundation
import JSONAPITesting
import JSONAPI
import XCTest

final class DocumentCompoundResourceTests: XCTestCase {
    func test_singleDocumentNoIncludes() {
        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<SingleResourceBody<DocumentTests.Author>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>

        let compoundAuthor = Document.CompoundResource(primary: author, relatives: [])

        let document = Document(
            apiDescription: .none,
            resource: compoundAuthor,
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.value, author)
        XCTAssertEqual(document.body.includes!, .none)
    }

    func test_singleDocumentEmptyIncludes() {
        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let book = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<SingleResourceBody<DocumentTests.Book>, NoMetadata, NoLinks, Include1<DocumentTests.Author>, NoAPIDescription, UnknownJSONAPIError>

        let compoundBook = Document.CompoundResource(primary: book, relatives: [])

        let document = Document(
            apiDescription: .none,
            resource: compoundBook,
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.value, book)
        XCTAssertEqual(document.body.includes!, .none)
    }

    func test_singleDocumentWithIncludes() {
        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let book = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<SingleResourceBody<DocumentTests.Book>, NoMetadata, NoLinks, Include1<DocumentTests.Author>, NoAPIDescription, UnknownJSONAPIError>

        let compoundBook = Document.CompoundResource(
            primary: book,
            relatives: [.init(author)]
        )

        let document = Document(
            apiDescription: .none,
            resource: compoundBook,
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.value, book)
        XCTAssertEqual(document.body.includes?.values, [.init(author)])
    }

    func test_singleDocumentWithFilteredIncludes() {
        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let ids = [
            DocumentTests.Book.Id(),
            DocumentTests.Book.Id(),
            DocumentTests.Book.Id()
        ]

        let book = DocumentTests.Book(
            id: ids[0],
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: [ids[1], ids[2]]),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        let book2 = DocumentTests.Book(
            id: ids[1],
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: [ids[0], ids[2]]),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        let book3 = DocumentTests.Book(
            id: ids[2],
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: [ids[0], ids[1]]),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<SingleResourceBody<DocumentTests.Book>, NoMetadata, NoLinks, Include2<DocumentTests.Author, DocumentTests.Book>, NoAPIDescription, UnknownJSONAPIError>

        let compoundBook = Document.CompoundResource(
            primary: book,
            relatives: [.init(author), .init(book2), .init(book3)]
        )

        let document = Document(
            apiDescription: .none,
            resource: compoundBook.filteringRelatives { $0.value is DocumentTests.Author },
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.value, book)
        XCTAssertEqual(document.body.includes?.values, [.init(author)])

        let document2 = Document(
            apiDescription: .none,
            resource: compoundBook.filteringRelatives { $0.value is DocumentTests.Book },
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document2.body.primaryResource?.value, book)
        XCTAssertEqual(document2.body.includes?.values, [.init(book2), .init(book3)])

        let document3 = Document(
            apiDescription: .none,
            resource: compoundBook,
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document3.body.primaryResource?.value, book)
        XCTAssertEqual(document3.body.includes?.values, [.init(author), .init(book2), .init(book3)])
    }

    func test_batchDocumentNoIncludes() {
        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let author2 = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<ManyResourceBody<DocumentTests.Author>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>

        let compoundAuthor = Document.CompoundResource(primary: author, relatives: [])
        let compoundAuthor2 = Document.CompoundResource(primary: author2, relatives: [])

        let document = Document(
            apiDescription: .none,
            resources: [compoundAuthor, compoundAuthor2],
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.values, [author, author2])
        XCTAssertEqual(document.body.includes!, .none)
    }

    func test_batchDocumentEmptyIncludes() {
        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let book = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        let book2 = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<ManyResourceBody<DocumentTests.Book>, NoMetadata, NoLinks, Include1<DocumentTests.Author>, NoAPIDescription, UnknownJSONAPIError>

        let compoundBook = Document.CompoundResource(primary: book, relatives: [])
        let compoundBook2 = Document.CompoundResource(primary: book2, relatives: [])

        let document = Document(
            apiDescription: .none,
            resources: [compoundBook, compoundBook2],
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.values, [book, book2])
        XCTAssertEqual(document.body.includes!, .none)
    }

    func test_batchDocumentWithIncldues() {
        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let book = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        let book2 = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<ManyResourceBody<DocumentTests.Book>, NoMetadata, NoLinks, Include1<DocumentTests.Author>, NoAPIDescription, UnknownJSONAPIError>

        let compoundBook = Document.CompoundResource(
            primary: book,
            relatives: [.init(author)]
        )

        let compoundBook2 = Document.CompoundResource(
            primary: book2,
            relatives: []
        )

        let document = Document(
            apiDescription: .none,
            resources: [compoundBook, compoundBook2],
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.values, [book, book2])
        XCTAssertEqual(document.body.includes?.values, [.init(author)])
    }

    func test_batchDocumentWithSameIncludeTwice() {
        // should only add each unique include once

        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let book = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        let book2 = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<ManyResourceBody<DocumentTests.Book>, NoMetadata, NoLinks, Include1<DocumentTests.Author>, NoAPIDescription, UnknownJSONAPIError>

        let compoundBook = Document.CompoundResource(
            primary: book,
            relatives: [.init(author)]
        )

        // the key in this test case is that both compound resources
        // contain the same included relative.
        let compoundBook2 = Document.CompoundResource(
            primary: book2,
            relatives: [.init(author)]
        )

        let document = Document(
            apiDescription: .none,
            resources: [compoundBook, compoundBook2],
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.values, [book, book2])
        XCTAssertEqual(document.body.includes?.values, [.init(author)])
    }

    func test_batchDocumentWithTwoDifferentIncludes() {
        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let author2 = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let book = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        let book2 = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author2),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<ManyResourceBody<DocumentTests.Book>, NoMetadata, NoLinks, Include1<DocumentTests.Author>, NoAPIDescription, UnknownJSONAPIError>

        let compoundBook = Document.CompoundResource(
            primary: book,
            relatives: [.init(author)]
        )

        let compoundBook2 = Document.CompoundResource(
            primary: book2,
            relatives: [.init(author2)]
        )

        let document = Document(
            apiDescription: .none,
            resources: [compoundBook, compoundBook2],
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.values, [book, book2])
        XCTAssertEqual(document.body.includes?.values, [.init(author), .init(author2)])
    }

    func test_batchDocumentWithFilteredIncludes() {
        let author = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let author2 = DocumentTests.Author(
            attributes: .none,
            relationships: .none,
            meta: .none,
            links: .none
        )

        let book = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        let book2 = DocumentTests.Book(
            attributes: .init(pageCount: 10),
            relationships: .init(
                author: .init(resourceObject: author2),
                series: .init(ids: []),
                collection: nil
            ),
            meta: .none,
            links: .none
        )

        typealias Document = JSONAPI.Document<ManyResourceBody<DocumentTests.Book>, NoMetadata, NoLinks, Include1<DocumentTests.Author>, NoAPIDescription, UnknownJSONAPIError>

        let compoundBook = Document.CompoundResource(
            primary: book,
            relatives: [.init(author)]
        )

        let compoundBook2 = Document.CompoundResource(
            primary: book2,
            relatives: [.init(author2)]
        )

        let document = Document(
            apiDescription: .none,
            resources: [compoundBook, compoundBook2].filteringRelatives { $0.a?.id == author.id },
            meta: .none,
            links: .none
        )

        XCTAssertEqual(document.body.primaryResource?.values, [book, book2])
        XCTAssertEqual(document.body.includes?.values, [.init(author)])
    }
}
