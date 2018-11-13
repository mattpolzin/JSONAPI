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
		let document = try? JSONDecoder().decode(JSONAPIDocument<SingleResourceBody<ArticleType>, Include0, BasicJSONAPIError>.self, from: single_document_no_includes)
		
		XCTAssertNotNil(document)

		guard let d = document else { return }
		
		XCTAssertFalse(d.body.isError)
		XCTAssertNotNil(d.body.data)
		XCTAssertEqual(d.body.data?.0.value?.id.rawValue, "1")
		XCTAssertEqual(d.body.data?.included.count, 0)
	}
	
	func test_singleDocumentSomeIncludes() {
		let document = try? JSONDecoder().decode(JSONAPIDocument<SingleResourceBody<ArticleType>, Include1<AuthorType>, BasicJSONAPIError>.self, from: single_document_some_includes)
		
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
		let document = try? JSONDecoder().decode(JSONAPIDocument<ManyResourceBody<ArticleType>, Include0, BasicJSONAPIError>.self, from: many_document_no_includes)
		
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
		let document = try? JSONDecoder().decode(JSONAPIDocument<ManyResourceBody<ArticleType>, Include1<AuthorType>, BasicJSONAPIError>.self, from: many_document_some_includes)
		
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
	
	enum AuthorType: EntityType {
		static var type: String { return "authors" }
		
		typealias Identifier = Id<String, AuthorType>
		typealias AttributeType = NoAttributes
		typealias RelatedType = NoRelatives
	}

	typealias Author = Entity<AuthorType>
	
	enum ArticleType: EntityType {
		static var type: String { return "articles" }
		
		typealias Identifier = Id<String, ArticleType>
		typealias AttributeType = NoAttributes
		typealias RelatedType = Relationships
		
		struct Relationships: JSONAPI.Relationships {
			let author: ToOneRelationship<AuthorType>
		}
	}
	
	typealias Article = Entity<ArticleType>
}
