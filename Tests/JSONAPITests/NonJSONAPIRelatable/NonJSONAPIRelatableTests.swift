//
//  NonJSONAPIRelatableTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 12/7/18.
//

import XCTest
import JSONAPI

class NonJSONAPIRelatableTests: XCTestCase {
	func test_initialization1() {
		let e1 = NonJSONAPIEntity(id: .init(rawValue: "hello"))
		let e2 = NonJSONAPIEntity(id: .init(rawValue: "world"))

		let entity = TestEntity(attributes: .none, relationships: .init(one: .init(id: e1.id), many: .init(ids: [e1.id, e2.id])), meta: .none, links: .none)

		XCTAssertEqual(entity ~> \.one, e1.id)
		XCTAssertEqual(entity ~> \.many, [e1.id, e2.id])

		XCTAssertNoThrow(try TestEntity.check(entity))
	}

	func test_initialization2_all_relationships_there() {
		let e1 = NonJSONAPIEntity(id: .init(rawValue: "hello"))
		let e2 = NonJSONAPIEntity(id: .init(rawValue: "world"))

		let entity = TestEntity2(attributes: .none, relationships: .init(nullableOne: .init(id: e1.id), nullableMaybeOne: .init(id: e2.id), maybeOne: .init(id: e2.id), maybeMany: .init(ids: [e2.id, e1.id])), meta: .none, links: .none)

		XCTAssertEqual((entity ~> \.nullableOne)?.rawValue, "hello")
		XCTAssertEqual((entity ~> \.nullableMaybeOne)?.rawValue, "world")
		XCTAssertEqual((entity ~> \.maybeOne)?.rawValue, "world")
		XCTAssertEqual((entity ~> \.maybeMany)?.map { $0.rawValue }, ["world", "hello"])
	}

	func test_initialization2_all_relationships_missing() {

		let entity = TestEntity2(attributes: .none, relationships: .init(nullableOne: .init(id: nil), nullableMaybeOne: .init(id: nil), maybeOne: nil, maybeMany: nil), meta: .none, links: .none)
		let entity2 = TestEntity2(attributes: .none, relationships: .init(nullableOne: .init(id: nil), nullableMaybeOne: nil, maybeOne: nil, maybeMany: nil), meta: .none, links: .none)

		XCTAssertNil((entity ~> \.nullableOne))
		XCTAssertNil((entity ~> \.nullableMaybeOne))
		XCTAssertNil((entity ~> \.maybeOne))
		XCTAssertNil((entity ~> \.maybeMany))

		XCTAssertNil((entity2 ~> \.nullableOne))
		XCTAssertNil((entity2 ~> \.nullableMaybeOne))
		XCTAssertNil((entity2 ~> \.maybeOne))
		XCTAssertNil((entity2 ~> \.maybeMany))
	}
}

// MARK: - Test Types
extension NonJSONAPIRelatableTests {
	enum TestEntityDescription: EntityDescription {
		static var type: String { return "test" }

		typealias Attributes = NoAttributes

		struct Relationships: JSONAPI.Relationships {
			let one: ToOneRelationship<NonJSONAPIEntity, NoMetadata, NoLinks>
			let many: ToManyRelationship<NonJSONAPIEntity, NoMetadata, NoLinks>
		}
	}

	typealias TestEntity = JSONAPI.Entity<TestEntityDescription, NoMetadata, NoLinks, String>

	enum TestEntity2Description: EntityDescription {
		static var type: String { return "test" }

		typealias Attributes = NoAttributes

		struct Relationships: JSONAPI.Relationships {
			let nullableOne: ToOneRelationship<NonJSONAPIEntity?, NoMetadata, NoLinks>
			let nullableMaybeOne: ToOneRelationship<NonJSONAPIEntity?, NoMetadata, NoLinks>?
			let maybeOne: ToOneRelationship<NonJSONAPIEntity, NoMetadata, NoLinks>?
			let maybeMany: ToManyRelationship<NonJSONAPIEntity, NoMetadata, NoLinks>?
		}
	}

	typealias TestEntity2 = JSONAPI.Entity<TestEntity2Description, NoMetadata, NoLinks, String>

	struct NonJSONAPIEntity: Relatable, JSONTyped {
		static var type: String { return "other" }

		typealias Identifier = NonJSONAPIEntity.Id

		let id: Id

		struct Id: IdType {
			var rawValue: String

			typealias IdentifiableType = NonJSONAPIEntity
			typealias RawType = String

			static func id(from rawValue: String) -> Id {
				return Id(rawValue: rawValue)
			}
		}
	}
}
