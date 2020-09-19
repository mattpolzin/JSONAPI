//
//  EntityCheckTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/27/18.
//

import XCTest
import JSONAPI
import JSONAPITesting

// Successes are fairly well-checked by the EntityTests in the JSONAPITests target.
// We will confirm failure cases are working in this file.
class EntityCheckTests: XCTestCase {
	func test_failsWithEnumAttributes() {
		let entity = EnumAttributesEntity(attributes: .hello, relationships: .none, meta: .none, links: .none)
		XCTAssertThrowsError(try EnumAttributesEntity.check(entity))
	}

	func test_failsWithEnumRelationships() {
		let entity = EnumRelationshipsEntity(attributes: .none, relationships: .hello, meta: .none, links: .none)
		XCTAssertThrowsError(try EnumRelationshipsEntity.check(entity))
	}

	func test_failsWithBadAttribute() {
		let entity = BadAttributeEntity(attributes: .init(x: "ok", y: "not ok"), relationships: .none, meta: .none, links: .none)
		XCTAssertThrowsError(try BadAttributeEntity.check(entity))
	}

	func test_failsWithBadRelationship() {
		let entity = BadRelationshipEntity(attributes: .none, relationships: .init(x: OkEntity(attributes: .none, relationships: .none, meta: .none, links: .none).pointer, y: OkEntity(attributes: .none, relationships: .none, meta: .none, links: .none).id), meta: .none, links: .none)
		XCTAssertThrowsError(try BadRelationshipEntity.check(entity))
	}

	func test_failsWithOptionalArrayAttribute() {
		let entity = OptionalArrayAttributeEntity(attributes: .init(x: ["hello"], y: nil), relationships: .none, meta: .none, links: .none)
		XCTAssertThrowsError(try OptionalArrayAttributeEntity.check(entity))
	}
}

// MARK: - Test types
extension EntityCheckTests {
	enum OkDescription: ResourceObjectDescription {
		public static var jsonType: String { return "hello" }

		public typealias Attributes = NoAttributes
		public typealias Relationships = NoRelationships
	}

	public typealias OkEntity = BasicEntity<OkDescription>

	enum OtherOkDescription: ResourceObjectDescription {
		public static var jsonType: String { return "hmm" }

		public typealias Attributes = NoAttributes
		public typealias Relationships = NoRelationships
	}

	public typealias OtherOkEntity = BasicEntity<OtherOkDescription>

	enum EnumAttributesDescription: ResourceObjectDescription {
		public static var jsonType: String { return "hello" }

		public enum Attributes: JSONAPI.Attributes {
			case hello

			public init(from decoder: Decoder) throws {
				self = .hello
			}

			public func encode(to encoder: Encoder) throws {
			}
		}

		public typealias Relationships = NoRelationships
	}

	public typealias EnumAttributesEntity = BasicEntity<EnumAttributesDescription>

	enum EnumRelationshipsDescription: ResourceObjectDescription {
		public static var jsonType: String { return "hello" }

		public typealias Attributes = NoAttributes

		public enum Relationships: JSONAPI.Relationships {
			case hello

			public init(from decoder: Decoder) throws {
				self = .hello
			}

			public func encode(to encoder: Encoder) throws {
			}
		}
	}

	public typealias EnumRelationshipsEntity = BasicEntity<EnumRelationshipsDescription>

	enum BadAttributeDescription: ResourceObjectDescription {
		public static var jsonType: String { return "hello" }

		public struct Attributes: JSONAPI.Attributes {
			let x: Attribute<String>
			let y: String
		}

		public typealias Relationships = NoRelationships
	}

	public typealias BadAttributeEntity = BasicEntity<BadAttributeDescription>

	enum BadRelationshipDescription: ResourceObjectDescription {
		public static var jsonType: String { return "hello" }

		public typealias Attributes = NoAttributes

		public struct Relationships: JSONAPI.Relationships {
			let x: ToOneRelationship<OkEntity, NoIdMetadata, NoMetadata, NoLinks>
			let y: Id<String, OkEntity>
		}
	}

	public typealias BadRelationshipEntity = BasicEntity<BadRelationshipDescription>

	enum OptionalArrayAttributeDescription: ResourceObjectDescription {
		public static var jsonType: String { return "hello" }

		public struct Attributes: JSONAPI.Attributes {
			let x: Attribute<[String]>
			let y: Attribute<[String]?>
		}

		public typealias Relationships = NoRelationships
	}

	public typealias OptionalArrayAttributeEntity = BasicEntity<OptionalArrayAttributeDescription>
}
