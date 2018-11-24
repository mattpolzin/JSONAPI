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
		let document = decoded(type: JSONAPIDocument<SingleResourceBody<Article>, NoMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: single_document_null)

		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertNil(document.body.meta)
		XCTAssertNil(document.body.data?.primary.value)
		XCTAssertEqual(document.body.data?.included.count, 0)
	}

	func test_singleDocumentNull_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<SingleResourceBody<Article>, NoMetadata, NoIncludes, BasicJSONAPIError>.self,
								  data: single_document_null)
	}

	func test_unknownErrorDocumentNoMeta() {
		let document = decoded(type: JSONAPIDocument<NoResourceBody, NoMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.meta)
		XCTAssertNil(document.body.data)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0[0], .unknown)
		XCTAssertEqual(errors.meta, NoMetadata())
	}

	func test_unknownErrorDocumentNoMeta_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<NoResourceBody, NoMetadata, NoIncludes, BasicJSONAPIError>.self,
								  data: error_document_no_metadata)
	}

	func test_errorDocumentNoMeta() {
		let document = decoded(type: JSONAPIDocument<NoResourceBody, NoMetadata, NoIncludes, TestError>.self,
							   data: error_document_no_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.meta)
		XCTAssertNil(document.body.data)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.0[0], TestError.basic(.init(code: 1, description: "Boooo!")))
		XCTAssertEqual(errors.meta, NoMetadata())
	}

	func test_errorDocumentNoMeta_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<NoResourceBody, NoMetadata, NoIncludes, TestError>.self,
							   data: error_document_no_metadata)
	}

	func test_unknownErrorDocumentWithMeta() {
		let document = decoded(type: JSONAPIDocument<NoResourceBody, TestPageMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: error_document_with_metadata)

		XCTAssertTrue(document.body.isError)
		XCTAssertNil(document.body.meta)
		XCTAssertNil(document.body.data)

		guard case let .errors(errors) = document.body else {
			XCTFail("Needed body to be in errors case but it was not.")
			return
		}

		XCTAssertEqual(errors.0.count, 1)
		XCTAssertEqual(errors.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
	}

	func test_unknownErrorDocumentWithMeta_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<NoResourceBody, TestPageMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: error_document_with_metadata)
	}

	func test_metaDataDocument() {
		let document = decoded(type: JSONAPIDocument<NoResourceBody, TestPageMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: metadata_document)

		XCTAssertFalse(document.body.isError)
		XCTAssertEqual(document.body.meta?.total, 100)
		XCTAssertEqual(document.body.meta?.limit, 50)
		XCTAssertEqual(document.body.meta?.offset, 0)
	}

	func test_metaDataDocument_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<NoResourceBody, TestPageMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: metadata_document)
	}

	func test_singleDocumentNoIncludes() {
		let document = decoded(type: JSONAPIDocument<SingleResourceBody<Article>, NoMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: single_document_no_includes)
		
		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertEqual(document.body.data?.0.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.data?.included.count, 0)
		XCTAssertEqual(document.body.data?.meta, NoMetadata())
	}

	func test_singleDocumentNoIncludes_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<SingleResourceBody<Article>, NoMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: single_document_no_includes)
	}

	func test_singleDocumentNoIncludesWithMetadata() {
		let document = decoded(type: JSONAPIDocument<SingleResourceBody<Article>, TestPageMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: single_document_no_includes_with_metadata)

		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertEqual(document.body.data?.0.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.data?.included.count, 0)
		XCTAssertEqual(document.body.data?.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
	}

	func test_singleDocumentNoIncludesWithMetadata_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<SingleResourceBody<Article>, TestPageMetadata, NoIncludes, BasicJSONAPIError>.self,
								  data: single_document_no_includes_with_metadata)
	}
	
	func test_singleDocumentSomeIncludes() {
		let document = decoded(type: JSONAPIDocument<SingleResourceBody<Article>, NoMetadata, Include1<Author>, BasicJSONAPIError>.self,
							   data: single_document_some_includes)

		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertEqual(document.body.data?.0.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.data?.included.count, 1)
		XCTAssertEqual(document.body.data?.included[Author.self].count, 1)
		XCTAssertEqual(document.body.data?.included[Author.self][0].id.rawValue, "33")
	}

	func test_singleDocumentSomeIncludes_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<SingleResourceBody<Article>, NoMetadata, Include1<Author>, BasicJSONAPIError>.self,
							   data: single_document_some_includes)
	}

	func test_singleDocumentSomeIncludesWithMetadata() {
		let document = decoded(type: JSONAPIDocument<SingleResourceBody<Article>, TestPageMetadata, Include1<Author>, BasicJSONAPIError>.self,
							   data: single_document_some_includes_with_metadata)

		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertEqual(document.body.data?.0.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.data?.included.count, 1)
		XCTAssertEqual(document.body.data?.included[Author.self].count, 1)
		XCTAssertEqual(document.body.data?.included[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.body.data?.meta, TestPageMetadata(total: 70, limit: 40, offset: 10))
	}

	func test_singleDocumentSomeIncludesWithMetadata_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<SingleResourceBody<Article>, TestPageMetadata, Include1<Author>, BasicJSONAPIError>.self,
								  data: single_document_some_includes_with_metadata)
	}

	func test_singleDocument_PolyPrimaryResource() {
		let article = Article(id: Id(rawValue: "1"), relationships: .init(author: ToOneRelationship(id: Id(rawValue: "33"))))
		let document = decoded(type: JSONAPIDocument<SingleResourceBody<Poly2<Article, Author>>, NoMetadata, NoIncludes, BasicJSONAPIError>.self, data: single_document_no_includes)

		XCTAssertEqual(document.body.data?.primary.value?[Article.self], article)
		XCTAssertNil(document.body.data?.primary.value?[Author.self])
	}
	
	func test_manyDocumentNoIncludes() {
		let document = decoded(type: JSONAPIDocument<ManyResourceBody<Article>, NoMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: many_document_no_includes)
		
		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertEqual(document.body.data?.0.values.count, 3)
		XCTAssertEqual(document.body.data?.0.values[0].id.rawValue, "1")
		XCTAssertEqual(document.body.data?.0.values[1].id.rawValue, "2")
		XCTAssertEqual(document.body.data?.0.values[2].id.rawValue, "3")
		XCTAssertEqual(document.body.data?.included.count, 0)
	}

	func test_manyDocumentNoIncludes_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<ManyResourceBody<Article>, NoMetadata, NoIncludes, BasicJSONAPIError>.self,
							   data: many_document_no_includes)
	}
	
	func test_manyDocumentSomeIncludes() {
		let document = decoded(type: JSONAPIDocument<ManyResourceBody<Article>, NoMetadata, Include1<Author>, BasicJSONAPIError>.self,
							   data: many_document_some_includes)

		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertEqual(document.body.data?.0.values.count, 3)
		XCTAssertEqual(document.body.data?.0.values[0].id.rawValue, "1")
		XCTAssertEqual(document.body.data?.0.values[1].id.rawValue, "2")
		XCTAssertEqual(document.body.data?.0.values[2].id.rawValue, "3")
		XCTAssertEqual(document.body.data?.included.count, 3)
		XCTAssertEqual(document.body.data?.included[Author.self].count, 3)
		XCTAssertEqual(document.body.data?.included[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(document.body.data?.included[Author.self][1].id.rawValue, "22")
		XCTAssertEqual(document.body.data?.included[Author.self][2].id.rawValue, "11")
	}

	func test_manyDocumentSomeIncludes_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<ManyResourceBody<Article>, NoMetadata, Include1<Author>, BasicJSONAPIError>.self,
							   data: many_document_some_includes)
	}
}

// MARK: - Test Types
extension DocumentTests {
	enum AuthorType: EntityDescription {
		static var type: String { return "authors" }

		typealias Attributes = NoAttributes
		typealias Relationships = NoRelatives
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
