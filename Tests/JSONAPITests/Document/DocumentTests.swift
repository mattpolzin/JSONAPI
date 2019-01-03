//
//  DocumentTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

import XCTest
import JSONAPI

class DocumentTests: XCTestCase {

	func test_singleDocumentNull() {
		let document = decoded(type: Document<SingleResourceBody<Article?>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_null)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertNil(document.body.primaryResource?.value)
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.links, NoLinks())
		XCTAssertEqual(document.apiDescription, .none)
	}

	func test_singleDocumentNull_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article?>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_null)
	}

	func test_singleDocumentNullWithAPIDescription() {
		let document = decoded(type: Document<SingleResourceBody<Article?>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_null_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertNil(document.body.primaryResource?.value)
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.links, NoLinks())
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_singleDocumentNullWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article?>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_null_with_api_description)
	}

	func test_singleDocumentNonOptionalFailsOnNull() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   from: single_document_null))
	}

	func test_singleDocumentNullFailsWithNoAPIDescription() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<SingleResourceBody<Article?>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
													  from: single_document_null))
	}
}

// MARK: - Error Document Tests
extension DocumentTests {

	func test_errorDocumentFailsWithNoAPIDescription() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
													  from: error_document_no_metadata))
	}

	func test_unknownErrorDocumentNoMeta() {
		let document = decoded(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertNil(document.body.data)
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.0[0], .unknown)
		XCTAssertEqual(errors.meta, NoMetadata())
	}

	func test_unknownErrorDocumentAddIncludingType() {
		let author = Author(id: "1",
							attributes: .none,
							relationships: .none,
							meta: .none,
							links: .none)

		let document = decoded(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_no_metadata)

		let documentWithIncludes = document.including(Includes<Include1<Author>>(values: [.init(author)]))

		XCTAssertEqual(document.body.errors, documentWithIncludes.body.errors)
		XCTAssertEqual(document.body.meta, documentWithIncludes.body.meta)
		XCTAssertEqual(document.body.links, documentWithIncludes.body.links)
		XCTAssertNil(documentWithIncludes.body.includes)
	}

	func test_unknownErrorDocumentAddIncludes() {
		let author = Author(id: "1",
							attributes: .none,
							relationships: .none,
							meta: .none,
							links: .none)

		let document = decoded(type: Document<NoResourceBody, NoMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_no_metadata)

		let documentWithIncludes = document.including(.init(values: [.init(author)]))

		XCTAssertEqual(document.body.errors, documentWithIncludes.body.errors)
		XCTAssertEqual(document.body.meta, documentWithIncludes.body.meta)
		XCTAssertEqual(document.body.links, documentWithIncludes.body.links)
		XCTAssertNil(documentWithIncludes.body.includes)
	}

	func test_unknownErrorDocumentNoMeta_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: error_document_no_metadata)
	}

	func test_unknownErrorDocumentNoMetaWithAPIDescription() {
		let document = decoded(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_no_metadata_with_api_description)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)
		XCTAssertEqual(document.apiDescription.version, "1.0")

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.0[0], .unknown)
		XCTAssertEqual(errors.meta, NoMetadata())
	}

	func test_unknownErrorDocumentNoMetaWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: error_document_no_metadata_with_api_description)
	}

	func test_unknownErrorDocumentMissingMeta() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self, data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.meta)
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.0[0], .unknown)
		XCTAssertNil(errors.meta)
	}

	func test_unknownErrorDocumentMissingMeta_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self, data: error_document_no_metadata)
	}

	func test_unknownErrorDocumentMissingMetaWithAPIDescription() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self, data: error_document_no_metadata_with_api_description)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.meta)
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)
		XCTAssertEqual(document.apiDescription.version, "1.0")

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.0[0], .unknown)
		XCTAssertNil(errors.meta)
	}

	func test_unknownErrorDocumentMissingMetaWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self, data: error_document_no_metadata_with_api_description)
	}

	func test_errorDocumentNoMeta() {
		let document = decoded(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, TestError>.self,
							   data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.0[0], TestError.basic(.init(code: 1, description: "Boooo!")))
		XCTAssertEqual(errors.meta, NoMetadata())
	}

	func test_errorDocumentNoMeta_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, TestError>.self,
							   data: error_document_no_metadata)
	}

	func test_errorDocumentNoMetaWithAPIDescription() {
		let document = decoded(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, TestError>.self,
							   data: error_document_no_metadata_with_api_description)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)
		XCTAssertEqual(document.apiDescription.version, "1.0")

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.0[0], TestError.basic(.init(code: 1, description: "Boooo!")))
		XCTAssertEqual(errors.meta, NoMetadata())
	}

	func test_errorDocumentNoMetaWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, TestError>.self,
								  data: error_document_no_metadata_with_api_description)
	}

	func test_unknownErrorDocumentWithMeta() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_with_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
	}

	func test_unknownErrorDocumentWithMeta_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_with_metadata)
	}

	func test_unknownErrorDocumentWithMetaWithAPIDescription() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_with_metadata_with_api_description)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)
		XCTAssertEqual(document.apiDescription.version, "1.0")

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
	}

	func test_unknownErrorDocumentWithMetaWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: error_document_with_metadata_with_api_description)
	}

	func test_unknownErrorDocumentWithMetaWithLinks() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_with_metadata_with_links)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
	}

	func test_unknownErrorDocumentWithMetaWithLinks_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: error_document_with_metadata_with_links)
	}

	func test_unknownErrorDocumentWithMetaWithLinksWithAPIDescription() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_with_metadata_with_links_with_api_description)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)
		XCTAssertEqual(document.apiDescription.version, "1.0")

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(errors.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
	}

	func test_unknownErrorDocumentWithMetaWithLinksWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: error_document_with_metadata_with_links_with_api_description)
	}

	func test_unknownErrorDocumentWithLinks() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_with_links)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
	}

	func test_unknownErrorDocumentWithLinks_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: error_document_with_links)
	}

	func test_unknownErrorDocumentWithLinksWithAPIDescription() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_with_links_with_api_description)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)
		XCTAssertEqual(document.apiDescription.version, "1.0")

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
	}

	func test_unknownErrorDocumentWithLinksWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: error_document_with_links_with_api_description)
	}

	func test_unknownErrorDocumentMissingLinks() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertNil(document.body.links)
	}

	func test_unknownErrorDocumentMissingLinks_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: error_document_no_metadata)
	}

	func test_unknownErrorDocumentMissingLinksWithAPIDescription() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: error_document_no_metadata_with_api_description)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.primaryResource)
		XCTAssertNil(document.body.includes)
		XCTAssertEqual(document.apiDescription.version, "1.0")

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0, document.body.errors)
		XCTAssertNil(document.body.links)
	}

	func test_unknownErrorDocumentMissingLinksWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: error_document_no_metadata_with_api_description)
	}
}

// MARK: - Meta Document Tests
extension DocumentTests {
	func test_metaDataDocumentFailsIfMissingAPIDescription() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self, from: metadata_document))
	}

	func test_metaDataDocument() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: metadata_document)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertEqual(document.body.meta?.total, 100)
		XCTAssertEqual(document.body.meta?.limit, 50)
		XCTAssertEqual(document.body.meta?.offset, 0)
	}

	func test_metaDataDocument_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: metadata_document)
	}

	func test_metaDataDocumentWithAPIDescription() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: metadata_document_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertEqual(document.body.meta?.total, 100)
		XCTAssertEqual(document.body.meta?.limit, 50)
		XCTAssertEqual(document.body.meta?.offset, 0)
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_metaDataDocumentWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: metadata_document_with_api_description)
	}

	func test_metaDataDocumentWithLinks() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: metadata_document_with_links)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertEqual(document.body.meta?.total, 100)
		XCTAssertEqual(document.body.meta?.limit, 50)
		XCTAssertEqual(document.body.meta?.offset, 0)
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
	}

	func test_metaDataDocumentWithLinks_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: metadata_document_with_links)
	}

	func test_metaDataDocumentWithLinksWithAPIDescription() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: metadata_document_with_links_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertEqual(document.body.meta?.total, 100)
		XCTAssertEqual(document.body.meta?.limit, 50)
		XCTAssertEqual(document.body.meta?.offset, 0)
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_metaDataDocumentWithLinksWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: metadata_document_with_links_with_api_description)
	}

	func test_metaDocumentMissingMeta() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self, from: metadata_document_missing_metadata))

		XCTAssertThrowsError(try JSONDecoder().decode(Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self, from: metadata_document_missing_metadata2))
	}
}


// MARK: Single Document Tests
extension DocumentTests {
	func test_singleDocumentNoIncludesMissingAPIDescription() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self, from: single_document_no_includes))
	}

	func test_singleDocumentNoIncludes() {
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes)
		
		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.data?.primary, document.body.primaryResource)
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, NoMetadata())
	}

	func test_singleDocumentNoIncludes_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes)
	}

	func test_singleDocumentNoIncludesAddIncludingType() {
		let author = Author(id: "1",
							attributes: .none,
							relationships: .none,
							meta: .none,
							links: .none)

		let document = decoded(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes)

		let documentWithIncludes = document.including(Includes<Include1<Author>>(values: [.init(author)]))

		XCTAssertEqual(document.body.errors, documentWithIncludes.body.errors)
		XCTAssertEqual(document.body.meta, documentWithIncludes.body.meta)
		XCTAssertEqual(document.body.links, documentWithIncludes.body.links)
		XCTAssertEqual(document.body.includes, Includes<NoIncludes>.none)
		XCTAssertEqual(documentWithIncludes.body.includes?[Author.self], [author])
	}

	func test_singleDocumentNoIncludesWithAPIDescription() {
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_singleDocumentNoIncludesWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_api_description)
	}

	func test_singleDocumentNoIncludesOptionalNotNull() {
		let document = decoded(type: Document<SingleResourceBody<Article?>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, NoMetadata())
	}

	func test_singleDocumentNoIncludesOptionalNotNull_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article?>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_no_includes)
	}

	func test_singleDocumentNoIncludesOptionalNotNullWithAPIDescription() {
		let document = decoded(type: Document<SingleResourceBody<Article?>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_singleDocumentNoIncludesOptionalNotNullWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article?>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_api_description)
	}

	func test_singleDocumentNoIncludesWithMetadata() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_metadata)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
	}

	func test_singleDocumentNoIncludesWithMetadata_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_metadata)
	}

	func test_singleDocumentNoIncludesWithMetadataWithAPIDescription() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_metadata_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_singleDocumentNoIncludesWithMetadataWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_metadata_with_api_description)
	}

	func test_singleDocumentNoIncludesWithLinks() {
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_links)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))

	}

	func test_singleDocumentNoIncludesWithLinks_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_links)
	}

	func test_singleDocumentNoIncludesWithLinksWithAPIDescription() {
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_links_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
		XCTAssertEqual(document.apiDescription.version, "1.0")

	}

	func test_singleDocumentNoIncludesWithLinksWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_links_with_api_description)
	}

	func test_singleDocumentNoIncludesWithMetadataWithLinks() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_metadata_with_links)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))

	}

	func test_singleDocumentNoIncludesWithMetadataWithLinks_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_metadata_with_links)
	}

	func test_singleDocumentNoIncludesWithMetadataWithLinksWithAPIDescription() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_metadata_with_links_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
		XCTAssertEqual(document.apiDescription.version, "1.0")

	}

	func test_singleDocumentNoIncludesWithMetadataWithLinksWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_metadata_with_links_with_api_description)
	}

	func test_singleDocumentNoIncludesWithMetadataMissingLinks() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self, from: single_document_no_includes_with_metadata))
	}

	func test_singleDocumentNoIncludesMissingMetadata() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self, from: single_document_no_includes))
	}
	
	func test_singleDocumentSomeIncludes() {
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_some_includes)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 1)
		XCTAssertEqual(document.body.includes?[Author.self].count, 1)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
	}

	func test_singleDocumentSomeIncludes_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_some_includes)
	}

	func test_singleDocumentSomeIncludesAddIncludes() {
		let existingAuthor = Author(id: "33",
									attributes: .none,
									relationships: .none,
									meta: .none,
									links: .none)

		let newAuthor = Author(id: "1",
							attributes: .none,
							relationships: .none,
							meta: .none,
							links: .none)

		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_some_includes)

		let documentWithIncludes = document.including(.init(values: [.init(newAuthor)]))

		XCTAssertEqual(document.body.errors, documentWithIncludes.body.errors)
		XCTAssertEqual(document.body.meta, documentWithIncludes.body.meta)
		XCTAssertEqual(document.body.links, documentWithIncludes.body.links)
		XCTAssertEqual(documentWithIncludes.body.includes?[Author.self], [existingAuthor, newAuthor])
	}

	func test_singleDocumentSomeIncludesWithAPIDescription() {
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_some_includes_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 1)
		XCTAssertEqual(document.body.includes?[Author.self].count, 1)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_singleDocumentSomeIncludesWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_some_includes_with_api_description)
	}

	func test_singleDocumentSomeIncludesWithMetadata() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_some_includes_with_metadata)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 1)
		XCTAssertEqual(document.body.includes?[Author.self].count, 1)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
	}

	func test_singleDocumentSomeIncludesWithMetadata_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_some_includes_with_metadata)
	}

	func test_singleDocumentSomeIncludesWithMetadataWithAPIDescription() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, Include1<Author>, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_some_includes_with_metadata_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 1)
		XCTAssertEqual(document.body.includes?[Author.self].count, 1)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_singleDocumentSomeIncludesWithMetadataWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, Include1<Author>, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_some_includes_with_metadata_with_api_description)
	}

	func test_singleDocumentNoIncludesWithSomeIncludesWithMetadataWithLinks() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_some_includes_with_metadata_with_links)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
		XCTAssertEqual(document.body.includes?.count, 1)
		XCTAssertEqual(document.body.includes?[Author.self].count, 1)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
	}

	func test_singleDocumentNoIncludesWithSomeIncludesMetadataWithLinks_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_some_includes_with_metadata_with_links)
	}

	func test_singleDocumentNoIncludesWithSomeIncludesWithMetadataWithLinksWithAPIDescription() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, Include1<Author>, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: single_document_some_includes_with_metadata_with_links_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.value.id.rawValue, "1")
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))
		XCTAssertEqual(document.body.includes?.count, 1)
		XCTAssertEqual(document.body.includes?[Author.self].count, 1)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_singleDocumentNoIncludesWithSomeIncludesMetadataWithLinksWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, Include1<Author>, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: single_document_some_includes_with_metadata_with_links_with_api_description)
	}
}

// MARK: Poly PrimaryResource Tests
extension DocumentTests {
	func test_singleDocument_PolyPrimaryResource() {
		let article = Article(id: Id(rawValue: "1"), attributes: .none, relationships: .init(author: ToOneRelationship(id: Id(rawValue: "33"))), meta: .none, links: .none)
		let document = decoded(type: Document<SingleResourceBody<Poly2<Article, Author>>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self, data: single_document_no_includes)

		XCTAssertEqual(document.body.primaryResource?.value[Article.self], article)
		XCTAssertNil(document.body.primaryResource?.value[Author.self])
	}

	func test_singleDocument_PolyPrimaryResource_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Poly2<Article, Author>>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self, data: single_document_no_includes)
	}

	func test_singleDocument_PolyPrimaryResourceWithAPIDescription() {
		let article = Article(id: Id(rawValue: "1"), attributes: .none, relationships: .init(author: ToOneRelationship(id: Id(rawValue: "33"))), meta: .none, links: .none)
		let document = decoded(type: Document<SingleResourceBody<Poly2<Article, Author>>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self, data: single_document_no_includes_with_api_description)

		XCTAssertEqual(document.body.primaryResource?.value[Article.self], article)
		XCTAssertNil(document.body.primaryResource?.value[Author.self])
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_singleDocument_PolyPrimaryResourceWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Poly2<Article, Author>>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self, data: single_document_no_includes_with_api_description)
	}
}

// MARK: - ManyResourceBody Tests
extension DocumentTests {
	func test_manyDocumentNoIncludes() {
		let document = decoded(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: many_document_no_includes)
		
		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.values.count, 3)
		XCTAssertEqual(document.body.primaryResource?.values[0].id.rawValue, "1")
		XCTAssertEqual(document.body.primaryResource?.values[1].id.rawValue, "2")
		XCTAssertEqual(document.body.primaryResource?.values[2].id.rawValue, "3")
		XCTAssertEqual(document.body.includes?.count, 0)
	}

	func test_manyDocumentNoIncludes_encode() {
		test_DecodeEncodeEquality(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: many_document_no_includes)
	}

	func test_manyDocumentNoIncludesWithAPIDescription() {
		let document = decoded(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: many_document_no_includes_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.values.count, 3)
		XCTAssertEqual(document.body.primaryResource?.values[0].id.rawValue, "1")
		XCTAssertEqual(document.body.primaryResource?.values[1].id.rawValue, "2")
		XCTAssertEqual(document.body.primaryResource?.values[2].id.rawValue, "3")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_manyDocumentNoIncludesWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: many_document_no_includes_with_api_description)
	}
	
	func test_manyDocumentSomeIncludes() {
		let document = decoded(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: many_document_some_includes)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.values.count, 3)
		XCTAssertEqual(document.body.primaryResource?.values[0].id.rawValue, "1")
		XCTAssertEqual(document.body.primaryResource?.values[1].id.rawValue, "2")
		XCTAssertEqual(document.body.primaryResource?.values[2].id.rawValue, "3")
		XCTAssertEqual(document.body.includes?.count, 3)
		XCTAssertEqual(document.body.includes?[Author.self].count, 3)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.body.includes?[Author.self][1].id.rawValue, "22")
		XCTAssertEqual(document.body.includes?[Author.self][2].id.rawValue, "11")
	}

	func test_manyDocumentSomeIncludes_encode() {
		test_DecodeEncodeEquality(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.self,
							   data: many_document_some_includes)
	}

	func test_manyDocumentSomeIncludesWithAPIDescription() {
		let document = decoded(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, TestAPIDescription, UnknownJSONAPIError>.self,
							   data: many_document_some_includes_with_api_description)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryResource)
		XCTAssertEqual(document.body.primaryResource?.values.count, 3)
		XCTAssertEqual(document.body.primaryResource?.values[0].id.rawValue, "1")
		XCTAssertEqual(document.body.primaryResource?.values[1].id.rawValue, "2")
		XCTAssertEqual(document.body.primaryResource?.values[2].id.rawValue, "3")
		XCTAssertEqual(document.body.includes?.count, 3)
		XCTAssertEqual(document.body.includes?[Author.self].count, 3)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.body.includes?[Author.self][1].id.rawValue, "22")
		XCTAssertEqual(document.body.includes?[Author.self][2].id.rawValue, "11")
		XCTAssertEqual(document.apiDescription.version, "1.0")
	}

	func test_manyDocumentSomeIncludesWithAPIDescription_encode() {
		test_DecodeEncodeEquality(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, TestAPIDescription, UnknownJSONAPIError>.self,
								  data: many_document_some_includes_with_api_description)
	}
}

// MARK: - Merging
extension DocumentTests {
	public func test_MergeBodyDataBasic(){
		let entity1 = Article(attributes: .none, relationships: .init(author: "2"), meta: .none, links: .none)
		let entity2 = Article(attributes: .none, relationships: .init(author: "3"), meta: .none, links: .none)

		let bodyData1 = Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.Body.Data(primary: .init(entities: [entity1]),
																																			  includes: .none,
																																			  meta: .none,
																																			  links: .none)
		let bodyData2 = Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>.Body.Data(primary: .init(entities: [entity2]),
																																			  includes: .none,
																																			  meta: .none,
																																			  links: .none)
		let combined = bodyData1.merging(bodyData2)

		XCTAssertEqual(combined.primary.values, bodyData1.primary.values + bodyData2.primary.values)
	}

	public func test_MergeBodyDataWithMergeFunctions() {
		let article1 = Article(attributes: .none, relationships: .init(author: "2"), meta: .none, links: .none)
		let author1 = Author(id: "2", attributes: .none, relationships: .none, meta: .none, links: .none)
		let article2 = Article(attributes: .none, relationships: .init(author: "3"), meta: .none, links: .none)
		let author2 = Author(id: "3", attributes: .none, relationships: .none, meta: .none, links: .none)

		let bodyData1 = Document<ManyResourceBody<Article>, TestPageMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.Body.Data(primary: .init(entities: [article1]),
																																						  includes: .init(values: [.init(author1)]),
																																						  meta: .init(total: 50, limit: 5, offset: 5),
																																						  links: .none)
		let bodyData2 = Document<ManyResourceBody<Article>, TestPageMetadata, NoLinks, Include1<Author>, NoAPIDescription, UnknownJSONAPIError>.Body.Data(primary: .init(entities: [article2]),
																																						  includes: .init(values: [.init(author2)]),
																																						  meta: .init(total: 60, limit: 5, offset: 5),
																																						  links: .none)

		let combined = bodyData1.merging(bodyData2,
										 combiningMetaWith: { (meta1, meta2) in
											return .init(total: max(meta1.total, meta2.total), limit: max(meta1.limit, meta2.limit), offset: max(meta1.offset, meta2.offset))
		},
										 combiningLinksWith: { _, _ in .none })

		XCTAssertEqual(combined.meta.total, bodyData2.meta.total)
		XCTAssertEqual(combined.meta.limit, bodyData2.meta.limit)
		XCTAssertEqual(combined.meta.offset, bodyData1.meta.offset)

		XCTAssertEqual(combined.includes, bodyData1.includes + bodyData2.includes)
		XCTAssertEqual(combined.primary, bodyData1.primary + bodyData2.primary)
	}
}

// MARK: - Test Types
extension DocumentTests {
	enum AuthorType: EntityDescription {
		static var jsonType: String { return "authors" }

		typealias Attributes = NoAttributes
		typealias Relationships = NoRelationships
	}

	typealias Author = BasicEntity<AuthorType>
	
	enum ArticleType: EntityDescription {
		static var jsonType: String { return "articles" }
		
		typealias Attributes = NoAttributes
		
		struct Relationships: JSONAPI.Relationships {
			let author: ToOneRelationship<Author, NoMetadata, NoLinks>
		}
	}
	
	typealias Article = BasicEntity<ArticleType>

	struct TestPageMetadata: JSONAPI.Meta {
		let total: Int
		let limit: Int
		let offset: Int
	}

	struct TestLinks: JSONAPI.Links {
		let link: Link<String, NoMetadata>
		let link2: Link<String,TestMetadata>

		struct TestMetadata: JSONAPI.Meta {
			let hello: String
		}
	}

	typealias TestAPIDescription = APIDescription<NoMetadata>

	enum TestError: JSONAPIError {
		case unknownError
		case basic(BasicError)

		struct BasicError: Codable, Equatable {
			let code: Int
			let description: String
		}

		public init(from decoder: Decoder) throws {
			let container = try decoder.singleValueContainer()

			self = (try? .basic(container.decode(BasicError.self))) ?? .unknown
		}

		public func encode(to encoder: Encoder) throws {
			var container = encoder.singleValueContainer()

			switch self {
			case .unknownError:
				try container.encode("unknown")
			case .basic(let error):
				try container.encode(error)
			}
		}

		public static var unknown: DocumentTests.TestError {
			return .unknownError
		}
	}
}

extension String: JSONAPI.JSONAPIURL {}
