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
		let document = decoded(type: JSONAPIDocument<SingleResourceBody<Article>, Include0, BasicJSONAPIError>.self,
							   data: single_document_null)

		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertNil(document.body.data?.primary.value)
		XCTAssertEqual(document.body.data?.included.count, 0)
	}

	func test_singleDocumentNull_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<SingleResourceBody<Article>, Include0, BasicJSONAPIError>.self,
							   data: single_document_null)
	}

	func test_singleDocumentNoIncludes() {
		let document = decoded(type: JSONAPIDocument<SingleResourceBody<Article>, Include0, BasicJSONAPIError>.self,
							   data: single_document_no_includes)
		
		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertEqual(document.body.data?.0.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.data?.included.count, 0)
	}

	func test_singleDocumentNoIncludes_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<SingleResourceBody<Article>, Include0, BasicJSONAPIError>.self,
							   data: single_document_no_includes)
	}
	
	func test_singleDocumentSomeIncludes() {
		let document = decoded(type: JSONAPIDocument<SingleResourceBody<Article>, Include1<Author>, BasicJSONAPIError>.self,
							   data: single_document_some_includes)

		XCTAssertFalse(document.body.isError)
		XCTAssertNotNil(document.body.data)
		XCTAssertEqual(document.body.data?.0.value?.id.rawValue, "1")
		XCTAssertEqual(document.body.data?.included.count, 1)
		XCTAssertEqual(document.body.data?.included[Author.self].count, 1)
		XCTAssertEqual(document.body.data?.included[Author.self][0].id.rawValue, "33")
	}

	func test_singleDocumentSomeIncludes_encode() {
		test_DecodeEncodeEquality(type: JSONAPIDocument<SingleResourceBody<Article>, Include1<Author>, BasicJSONAPIError>.self,
							   data: single_document_some_includes)
	}
	
	func test_manyDocumentNoIncludes() {
		let document = decoded(type: JSONAPIDocument<ManyResourceBody<Article>, Include0, BasicJSONAPIError>.self,
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
		test_DecodeEncodeEquality(type: JSONAPIDocument<ManyResourceBody<Article>, Include0, BasicJSONAPIError>.self,
							   data: many_document_no_includes)
	}
	
	func test_manyDocumentSomeIncludes() {
		let document = decoded(type: JSONAPIDocument<ManyResourceBody<Article>, Include1<Author>, BasicJSONAPIError>.self,
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
		test_DecodeEncodeEquality(type: JSONAPIDocument<ManyResourceBody<Article>, Include1<Author>, BasicJSONAPIError>.self,
							   data: many_document_some_includes)
	}
	
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
}
