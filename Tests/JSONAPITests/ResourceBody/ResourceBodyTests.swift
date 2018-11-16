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
		let body = try? JSONDecoder().decode(SingleResourceBody<Article>.self, from: single_resource_body)
		
		XCTAssertNotNil(body)

		guard let b = body else { return }

		XCTAssertEqual(b.value, Article(id: Id<String, ArticleType>(rawValue: "1"),
										attributes: ArticleType.Attributes(title: try! .init(rawValue: "JSON:API paints my bikeshed!"))))
	}
	
	func test_manyResourceBody() {
		let body = try? JSONDecoder().decode(ManyResourceBody<Article>.self, from: many_resource_body)
		
		XCTAssertNotNil(body)
		
		guard let b = body else { return }
		
		XCTAssertEqual(b.values, [
			Article(id: .init(rawValue: "1"), attributes: try! .init(title: .init(rawValue: "JSON:API paints my bikeshed!"))),
			Article(id: .init(rawValue: "2"), attributes: try! .init(title: .init(rawValue: "Sick"))),
			Article(id: .init(rawValue: "3"), attributes: try! .init(title: .init(rawValue: "Hello World")))
		])
	}

	enum ArticleType: EntityDescription {
		public static var type: String { return "articles" }
		
		typealias Identifier = Id<String, ArticleType>
		typealias Relationships = NoRelatives
		
		struct Attributes: JSONAPI.Attributes {
			let title: Attribute<String>
		}
	}
	
	typealias Article = Entity<ArticleType>
}
