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
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: single_document_null)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertNil(document.body.primaryData?.value)
		XCTAssertEqual(document.body.includes?.count, 0)
	}

	func test_singleDocumentNull_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
								  data: single_document_null)
	}

	func test_unknownErrorDocumentNoMeta() {
		let document = decoded(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertNil(document.body.primaryData)
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

	func test_unknownErrorDocumentNoMeta_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
								  data: error_document_no_metadata)
	}

	func test_unknownErrorDocumentMissingMeta() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self, data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.meta)
		XCTAssertNil(document.body.primaryData)
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
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self, data: error_document_no_metadata)
	}

	func test_errorDocumentNoMeta() {
		let document = decoded(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, TestError>.self,
							   data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertNil(document.body.primaryData)
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
		test_DecodeEncodeEquality(type: Document<NoResourceBody, NoMetadata, NoLinks, NoIncludes, TestError>.self,
							   data: error_document_no_metadata)
	}

	func test_unknownErrorDocumentWithMeta() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: error_document_with_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertNil(document.body.primaryData)
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
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: error_document_with_metadata)
	}

	func test_unknownErrorDocumentWithMetaWithLinks() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: error_document_with_metadata_with_links)

		XCTAssertTrue(document.body.isError)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertNil(document.body.primaryData)
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
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
								  data: error_document_with_metadata_with_links)
	}

	func test_unknownErrorDocumentWithLinks() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: error_document_with_links)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.primaryData)
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
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
								  data: error_document_with_links)
	}

	func test_unknownErrorDocumentMissingLinks() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.primaryData)
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
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
								  data: error_document_no_metadata)
	}

	func test_metaDataDocument() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: metadata_document)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertEqual(document.body.meta?.total, 100)
		XCTAssertEqual(document.body.meta?.limit, 50)
		XCTAssertEqual(document.body.meta?.offset, 0)
	}

	func test_metaDataDocument_encode() {
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: metadata_document)
	}

	func test_metaDataDocumentWithLinks() {
		let document = decoded(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
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
		test_DecodeEncodeEquality(type: Document<NoResourceBody, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: metadata_document_with_links)
	}

	func test_metaDocumentMissingMeta() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self, from: metadata_document_missing_metadata))

		XCTAssertThrowsError(try JSONDecoder().decode(Document<NoResourceBody, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self, from: metadata_document_missing_metadata2))
	}

	func test_singleDocumentNoIncludes() {
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: single_document_no_includes)
		
		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.primaryData?.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, NoMetadata())
	}

	func test_singleDocumentNoIncludes_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: single_document_no_includes)
	}

	func test_singleDocumentNoIncludesWithMetadata() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_metadata)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.primaryData?.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
	}

	func test_singleDocumentNoIncludesWithMetadata_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_metadata)
	}

	func test_singleDocumentNoIncludesWithLinks() {
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_links)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.primaryData?.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))

	}

	func test_singleDocumentNoIncludesWithLinks_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_links)
	}

	func test_singleDocumentNoIncludesWithMetadataWithLinks() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: single_document_no_includes_with_metadata_with_links)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.primaryData?.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 0)
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
		XCTAssertEqual(document.body.links?.link.url, "https://website.com")
		XCTAssertEqual(document.body.links?.link.meta, NoMetadata())
		XCTAssertEqual(document.body.links?.link2.url, "https://othersite.com")
		XCTAssertEqual(document.body.links?.link2.meta, TestLinks.TestMetadata(hello: "world"))

	}

	func test_singleDocumentNoIncludesWithMetadataWithLinks_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self,
								  data: single_document_no_includes_with_metadata_with_links)
	}

	func test_singleDocumentNoIncludesWithMetadataMissingLinks() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, NoIncludes, UnknownJSONAPIError>.self, from: single_document_no_includes_with_metadata))
	}

	func test_singleDocumentNoIncludesMissingMetadata() {
		XCTAssertThrowsError(try JSONDecoder().decode(Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self, from: single_document_no_includes))
	}
	
	func test_singleDocumentSomeIncludes() {
		let document = decoded(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, UnknownJSONAPIError>.self,
							   data: single_document_some_includes)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.primaryData?.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 1)
		XCTAssertEqual(document.body.includes?[Author.self].count, 1)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
	}

	func test_singleDocumentSomeIncludes_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, UnknownJSONAPIError>.self,
							   data: single_document_some_includes)
	}

	func test_singleDocumentSomeIncludesWithMetadata() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, Include1<Author>, UnknownJSONAPIError>.self,
							   data: single_document_some_includes_with_metadata)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.primaryData?.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.includes?.count, 1)
		XCTAssertEqual(document.body.includes?[Author.self].count, 1)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.body.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
	}

	func test_singleDocumentSomeIncludesWithMetadata_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, NoLinks, Include1<Author>, UnknownJSONAPIError>.self,
								  data: single_document_some_includes_with_metadata)
	}

	func test_singleDocumentNoIncludesWithSomeIncludesWithMetadataWithLinks() {
		let document = decoded(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, Include1<Author>, UnknownJSONAPIError>.self,
							   data: single_document_some_includes_with_metadata_with_links)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.primaryData?.value?.id.rawValue, "1")
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
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Article>, TestPageMetadata, TestLinks, Include1<Author>, UnknownJSONAPIError>.self,
								  data: single_document_some_includes_with_metadata_with_links)
	}

	func test_singleDocument_PolyPrimaryResource() {
		let article = Article(id: Id(rawValue: "1"), relationships: .init(author: ToOneRelationship(id: Id(rawValue: "33"))))
		let document = decoded(type: Document<SingleResourceBody<Poly2<Article, Author>>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self, data: single_document_no_includes)

		XCTAssertEqual(document.body.primaryData?.value?[Article.self], article)
		XCTAssertNil(document.body.primaryData?.value?[Author.self])
	}

	func test_singleDocument_PolyPrimaryResource_encode() {
		test_DecodeEncodeEquality(type: Document<SingleResourceBody<Poly2<Article, Author>>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self, data: single_document_no_includes)
	}
	
	func test_manyDocumentNoIncludes() {
		let document = decoded(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: many_document_no_includes)
		
		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.primaryData?.values.count, 3)
		XCTAssertEqual(document.body.primaryData?.values[0].id.rawValue, "1")
		XCTAssertEqual(document.body.primaryData?.values[1].id.rawValue, "2")
		XCTAssertEqual(document.body.primaryData?.values[2].id.rawValue, "3")
		XCTAssertEqual(document.body.includes?.count, 0)
	}

	func test_manyDocumentNoIncludes_encode() {
		test_DecodeEncodeEquality(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, NoIncludes, UnknownJSONAPIError>.self,
							   data: many_document_no_includes)
	}
	
	func test_manyDocumentSomeIncludes() {
		let document = decoded(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, UnknownJSONAPIError>.self,
							   data: many_document_some_includes)

		XCTAssertFalse(document.body.isError)
		XCTAssertNil(document.body.errors)
		XCTAssertNotNil(document.body.primaryData)
		XCTAssertEqual(document.body.primaryData?.values.count, 3)
		XCTAssertEqual(document.body.primaryData?.values[0].id.rawValue, "1")
		XCTAssertEqual(document.body.primaryData?.values[1].id.rawValue, "2")
		XCTAssertEqual(document.body.primaryData?.values[2].id.rawValue, "3")
		XCTAssertEqual(document.body.includes?.count, 3)
		XCTAssertEqual(document.body.includes?[Author.self].count, 3)
		XCTAssertEqual(document.body.includes?[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.body.includes?[Author.self][1].id.rawValue, "22")
		XCTAssertEqual(document.body.includes?[Author.self][2].id.rawValue, "11")
	}

	func test_manyDocumentSomeIncludes_encode() {
		test_DecodeEncodeEquality(type: Document<ManyResourceBody<Article>, NoMetadata, NoLinks, Include1<Author>, UnknownJSONAPIError>.self,
							   data: many_document_some_includes)
	}
}

// MARK: - Test Types
extension DocumentTests {
	enum AuthorType: EntityDescription {
		static var type: String { return "authors" }

		typealias Attributes = NoAttributes
		typealias Relationships = NoRelationships
	}

	typealias Author = Entity<AuthorType>
	
	enum ArticleType: EntityDescription {
		static var type: String { return "articles" }
		
		typealias Attributes = NoAttributes
		
		struct Relationships: JSONAPI.Relationships {
			let author: ToOneRelationship<Author>
		}
	}
	
	typealias Article = Entity<ArticleType>

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
