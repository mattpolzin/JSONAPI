//
//  ResourceBodyTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

import XCTest
import JSONAPI

class ResourceBodyTests: XCTestCase {

	func test_singleResourceBody() {
		let body = decoded(type: SingleResourceBody<Article>.self,
						   data: single_resource_body)

		XCTAssertEqual(body.value, Article(id: Id<String, Article>(rawValue: "1"),
										attributes: ArticleType.Attributes(title: try! .init(rawValue: "JSON:API paints my bikeshed!"))))
	}

	func test_singleResourceBody_encode() {
		test_DecodeEncodeEquality(type: SingleResourceBody<Article>.self,
						   data: single_resource_body)
	}

	func test_manyResourceBody() {
		let body = decoded(type: ManyResourceBody<Article>.self,
						   data: many_resource_body)

		XCTAssertEqual(body.values, [
			Article(id: .init(rawValue: "1"), attributes: try! .init(title: .init(rawValue: "JSON:API paints my bikeshed!"))),
			Article(id: .init(rawValue: "2"), attributes: try! .init(title: .init(rawValue: "Sick"))),
			Article(id: .init(rawValue: "3"), attributes: try! .init(title: .init(rawValue: "Hello World")))
		])
	}

	func test_manyResourceBody_encode() {
		test_DecodeEncodeEquality(type: ManyResourceBody<Article>.self,
						   data: many_resource_body)
	}

	func test_manyResourceBodyEmpty() {
		let body = decoded(type: ManyResourceBody<Article>.self,
						   data: many_resource_body_empty)

		XCTAssertEqual(body.values.count, 0)
	}

	func test_manyResourceBodyEmpty_encode() {
		test_DecodeEncodeEquality(type: ManyResourceBody<Article>.self,
						   data: many_resource_body_empty)
	}

	enum ArticleType: EntityDescription {
		public static var type: String { return "articles" }

		typealias Relationships = NoRelationships

		struct Attributes: JSONAPI.Attributes {
			let title: Attribute<String>
		}
	}

	typealias Article = Entity<ArticleType>
}
