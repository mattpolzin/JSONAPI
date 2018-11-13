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
		let body = try? JSONDecoder().decode(SingleResourceBody<ArticleType>.self, from: single_resource_body)
		
		XCTAssertNotNil(body)

		guard let b = body else { return }

		XCTAssertEqual(b.value, Article(id: Id<String, ArticleType>(rawValue: "1"),
										attributes: ArticleType.Attributes(title: "JSON:API paints my bikeshed!")))
	}
	
	func test_manyResourceBody() {
		let body = try? JSONDecoder().decode(ManyResourceBody<ArticleType>.self, from: many_resource_body)
		
		XCTAssertNotNil(body)
		
		guard let b = body else { return }
		
		XCTAssertEqual(b.values, [
			Article(id: .init(rawValue: "1"), attributes: .init(title: "JSON:API paints my bikeshed!")),
			Article(id: .init(rawValue: "2"), attributes: .init(title: "Sick")),
			Article(id: .init(rawValue: "3"), attributes: .init(title: "Hello World"))
		])
	}

	enum ArticleType: EntityDescription {
		public static var type: String { return "articles" }
		
		typealias Identifier = Id<String, ArticleType>
		typealias Relationships = NoRelatives
		
		struct Attributes: JSONAPI.Attributes {
			let title: String
		}
	}
	
	typealias Article = Entity<ArticleType>
}
