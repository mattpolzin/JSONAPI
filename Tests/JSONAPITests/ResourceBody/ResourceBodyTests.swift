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
		let _ = SingleResourceBody(resourceObject: articles[0])
		let _ = ManyResourceBody(resourceObjects: articles)
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
		let body1 = ManyResourceBody(resourceObjects: [
			Article(attributes: .init(title: "hello"),
					relationships: .none,
					meta: .none,
					links: .none),
			Article(attributes: .init(title: "world"),
					relationships: .none,
					meta: .none,
					links: .none)
			])

		let body2 = ManyResourceBody(resourceObjects: [
			Article(attributes: .init(title: "once more"),
					relationships: .none,
					meta: .none,
					links: .none)
			])

		let combined = body1 + body2

		XCTAssertEqual(combined.values.count, 3)
		XCTAssertEqual(combined.values, body1.values + body2.values)
	}
}

// MARK: - Sparse Fieldsets

extension ResourceBodyTests {
    func test_SparseSingleBodyEncode() {
        let sparseArticle = Article(attributes: .init(title: "hello world"),
                                    relationships: .none,
                                    meta: .none,
                                    links: .none)
            .sparse(with: [])
        let body = SingleResourceBody(resourceObject: sparseArticle)

        let encoded = try! JSONEncoder().encode(body)

        let deserialized = try! JSONSerialization.jsonObject(with: encoded,
                                                             options: [])

        let deserializedObj = deserialized as? [String: Any]

        XCTAssertNotNil(deserializedObj?["id"])
        XCTAssertEqual(deserializedObj?["id"] as? String, sparseArticle.resourceObject.id.rawValue)

        XCTAssertNotNil(deserializedObj?["type"])
        XCTAssertEqual(deserializedObj?["type"] as? String, Article.jsonType)

        XCTAssertEqual((deserializedObj?["attributes"] as? [String: Any])?.count, 0)

        XCTAssertNil(deserializedObj?["relationships"])
    }

    func test_SparseManyBodyEncode() {
        let fields: [Article.Attributes.CodingKeys] = [.title]
        let sparseArticle1 = Article(attributes: .init(title: "hello world"),
                                     relationships: .none,
                                     meta: .none,
                                     links: .none)
            .sparse(with: fields)
        let sparseArticle2 = Article(attributes: .init(title: "hello two"),
                                     relationships: .none,
                                     meta: .none,
                                     links: .none)
            .sparse(with: fields)

        let body = ManyResourceBody(resourceObjects: [sparseArticle1, sparseArticle2])

        let encoded = try! JSONEncoder().encode(body)

        let deserialized = try! JSONSerialization.jsonObject(with: encoded,
                                                             options: [])

        let deserializedObj = deserialized as? [Any]

        XCTAssertEqual(deserializedObj?.count, 2)

        guard let deserializedObj1 = deserializedObj?.first as? [String: Any],
            let deserializedObj2 = deserializedObj?.last as? [String: Any] else {
                XCTFail("Expected to deserialize two objects from array")
                return
        }

        // first article
        XCTAssertNotNil(deserializedObj1["id"])
        XCTAssertEqual(deserializedObj1["id"] as? String, sparseArticle1.resourceObject.id.rawValue)

        XCTAssertNotNil(deserializedObj1["type"])
        XCTAssertEqual(deserializedObj1["type"] as? String, Article.jsonType)

        XCTAssertEqual((deserializedObj1["attributes"] as? [String: Any])?.count, 1)
        XCTAssertEqual((deserializedObj1["attributes"] as? [String: Any])?["title"] as? String, "hello world")

        XCTAssertNil(deserializedObj1["relationships"])

        // second article
        XCTAssertNotNil(deserializedObj2["id"])
        XCTAssertEqual(deserializedObj2["id"] as? String, sparseArticle2.resourceObject.id.rawValue)

        XCTAssertNotNil(deserializedObj2["type"])
        XCTAssertEqual(deserializedObj2["type"] as? String, Article.jsonType)

        XCTAssertEqual((deserializedObj2["attributes"] as? [String: Any])?.count, 1)
        XCTAssertEqual((deserializedObj2["attributes"] as? [String: Any])?["title"] as? String, "hello two")

        XCTAssertNil(deserializedObj2["relationships"])
    }
}

// MARK: - Test Types

extension ResourceBodyTests {

	enum ArticleType: ResourceObjectDescription {
		public static var jsonType: String { return "articles" }

		typealias Relationships = NoRelationships

		struct Attributes: JSONAPI.SparsableAttributes {
			let title: Attribute<String>

            public enum CodingKeys: String, Equatable, CodingKey {
                case title
            }
		}
	}

	typealias Article = BasicEntity<ArticleType>
}
