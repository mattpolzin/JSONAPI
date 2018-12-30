//
//  ResourceBodyTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/12/18.
//

import XCTest
import JSONAPI

class ResourceBodyTests: XCTestCase {

	func test_initializers() {
		let articles = [
			Article(attributes: .init(title: "hello"), relationships: .none, meta: .none, links: .none),
			Article(attributes: .init(title: "world"), relationships: .none, meta: .none, links: .none)
		]
		let _ = SingleResourceBody(entity: articles[0])
		let _ = ManyResourceBody(entities: articles)
		let _: NoResourceBody = .none
	}

	func test_singleResourceBody() {
		let body = decoded(type: SingleResourceBody<Article>.self,
						   data: single_resource_body)

		XCTAssertEqual(body.value, Article(id: Id<String, Article>(rawValue: "1"),
										   attributes: ArticleType.Attributes(title: .init(value: "JSON:API paints my bikeshed!")),
										   relationships: .none,
										   meta: .none,
										   links: .none))
	}

	func test_singleResourceBody_encode() {
		test_DecodeEncodeEquality(type: SingleResourceBody<Article>.self,
						   data: single_resource_body)
	}

	func test_manyResourceBody() {
		let body = decoded(type: ManyResourceBody<Article>.self,
						   data: many_resource_body)

		XCTAssertEqual(body.values, [
			Article(id: .init(rawValue: "1"),
					attributes: .init(title: .init(value: "JSON:API paints my bikeshed!")),
					relationships: .none,
					meta: .none,
					links: .none),
			Article(id: .init(rawValue: "2"),
					attributes: .init(title: .init(value: "Sick")),
					relationships: .none,
					meta: .none,
					links: .none),
			Article(id: .init(rawValue: "3"),
					attributes: .init(title: .init(value: "Hello World")),
					relationships: .none,
					meta: .none,
					links: .none)
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

	func test_manyResourceBodyMerge() {
		let body1 = ManyResourceBody(entities: [
			Article(attributes: .init(title: "hello"),
					relationships: .none,
					meta: .none,
					links: .none),
			Article(attributes: .init(title: "world"),
					relationships: .none,
					meta: .none,
					links: .none)
			])

		let body2 = ManyResourceBody(entities: [
			Article(attributes: .init(title: "once more"),
					relationships: .none,
					meta: .none,
					links: .none)
			])

		let combined = body1 + body2

		XCTAssertEqual(combined.values.count, 3)
		XCTAssertEqual(combined.values, body1.values + body2.values)
	}

	enum ArticleType: EntityDescription {
		public static var type: String { return "articles" }

		typealias Relationships = NoRelationships

		struct Attributes: JSONAPI.Attributes {
			let title: Attribute<String>
		}
	}

	typealias Article = BasicEntity<ArticleType>
}
