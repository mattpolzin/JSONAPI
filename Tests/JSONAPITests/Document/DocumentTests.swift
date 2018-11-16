//
//  DocumentTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

import XCTest
import JSONAPI

class DocumentTests: XCTestCase {

	func test_singleDocumentNoIncludes() {
		let document = try? JSONDecoder().decode(JSONAPIDocument<SingleResourceBody<Article>, Include0, BasicJSONAPIError>.self, from: single_document_no_includes)
		
		XCTAssertNotNil(document)

		guard let d = document else { return }
		
		XCTAssertFalse(d.body.isError)
		XCTAssertNotNil(d.body.data)
		XCTAssertEqual(d.body.data?.0.value?.id.rawValue, "1")
		XCTAssertEqual(d.body.data?.included.count, 0)
	}
	
	func test_singleDocumentSomeIncludes() {
		let document = try? JSONDecoder().decode(JSONAPIDocument<SingleResourceBody<Article>, Include1<Author>, BasicJSONAPIError>.self, from: single_document_some_includes)
		
		XCTAssertNotNil(document)

		guard let d = document else { return }

		XCTAssertFalse(d.body.isError)
		XCTAssertNotNil(d.body.data)
		XCTAssertEqual(d.body.data?.0.value?.id.rawValue, "1")
		XCTAssertEqual(d.body.data?.included.count, 1)
		XCTAssertEqual(d.body.data?.included[Author.self].count, 1)
		XCTAssertEqual(d.body.data?.included[Author.self][0].id.rawValue, "33")
	}
	
	func test_manyDocumentNoIncludes() {
		let document = try? JSONDecoder().decode(JSONAPIDocument<ManyResourceBody<Article>, Include0, BasicJSONAPIError>.self, from: many_document_no_includes)
		
		XCTAssertNotNil(document)
		
		guard let d = document else { return }
		
		XCTAssertFalse(d.body.isError)
		XCTAssertNotNil(d.body.data)
		XCTAssertEqual(d.body.data?.0.values.count, 3)
		XCTAssertEqual(d.body.data?.0.values[0].id.rawValue, "1")
		XCTAssertEqual(d.body.data?.0.values[1].id.rawValue, "2")
		XCTAssertEqual(d.body.data?.0.values[2].id.rawValue, "3")
		XCTAssertEqual(d.body.data?.included.count, 0)
	}
	
	func test_manyDocumentSomeIncludes() {
		let document = try? JSONDecoder().decode(JSONAPIDocument<ManyResourceBody<Article>, Include1<Author>, BasicJSONAPIError>.self, from: many_document_some_includes)
		
		XCTAssertNotNil(document)
		
		guard let d = document else { return }
		
		XCTAssertFalse(d.body.isError)
		XCTAssertNotNil(d.body.data)
		XCTAssertEqual(d.body.data?.0.values.count, 3)
		XCTAssertEqual(d.body.data?.0.values[0].id.rawValue, "1")
		XCTAssertEqual(d.body.data?.0.values[1].id.rawValue, "2")
		XCTAssertEqual(d.body.data?.0.values[2].id.rawValue, "3")
		XCTAssertEqual(d.body.data?.included.count, 3)
		XCTAssertEqual(d.body.data?.included[Author.self].count, 3)
		XCTAssertEqual(d.body.data?.included[Author.self][0].id.rawValue, "33")
		XCTAssertEqual(d.body.data?.included[Author.self][1].id.rawValue, "22")
		XCTAssertEqual(d.body.data?.included[Author.self][2].id.rawValue, "11")
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
