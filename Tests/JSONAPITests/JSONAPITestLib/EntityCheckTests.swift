//
//  EntityCheckTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/27/18.
//

import XCTest
import JSONAPI
import JSONAPITestLib

// Successes are fairly well-checked by the EntityTests. We will confirm failure cases are working
// in this file.
class EntityCheckTests: XCTestCase {
	func test_failsWithEnumAttributes() {
		let entity = EnumAttributesEntity(attributes: .hello)
		XCTAssertThrowsError(try EnumAttributesEntity.check(entity))
	}

	func test_failsWithEnumRelationships() {
		let entity = EnumRelationshipsEntity(relationships: .hello)
		XCTAssertThrowsError(try EnumRelationshipsEntity.check(entity))
	}

	func test_failsWithBadAttribute() {
		let entity = BadAttributeEntity(attributes: .init(x: "ok", y: "not ok"))
		XCTAssertThrowsError(try BadAttributeEntity.check(entity))
	}

	func test_failsWithBadRelationship() {
		let entity = BadRelationshipEntity(relationships: .init(x: OkEntity().pointer, y: OkEntity().id))
		XCTAssertThrowsError(try BadRelationshipEntity.check(entity))
	}

	func test_failsWithOptionalArrayAttribute() {
		let entity = OptionalArrayAttributeEntity(attributes: .init(x: ["hello"], y: nil))
		XCTAssertThrowsError(try OptionalArrayAttributeEntity.check(entity))
	}
}

// MARK: - Test types
extension EntityCheckTests {
	enum OkDescription: EntityDescription {
		public static var type: String { return "hello" }

		public typealias Attributes = NoAttributes
		public typealias Relationships = NoRelationships
	}

	public typealias OkEntity = Entity<OkDescription>

	enum OtherOkDescription: EntityDescription {
		public static var type: String { return "hmm" }

		public typealias Attributes = NoAttributes
		public typealias Relationships = NoRelationships
	}

	public typealias OtherOkEntity = Entity<OtherOkDescription>

	enum EnumAttributesDescription: EntityDescription {
		public static var type: String { return "hello" }

		public enum Attributes: Codable, Equatable {
			case hello

			public init(from decoder: Decoder) throws {
				self = .hello
			}

			public func encode(to encoder: Encoder) throws {
			}
		}

		public typealias Relationships = NoRelationships
	}

	public typealias EnumAttributesEntity = Entity<EnumAttributesDescription>

	enum EnumRelationshipsDescription: EntityDescription {
		public static var type: String { return "hello" }

		public typealias Attributes = NoAttributes

		public enum Relationships: Codable, Equatable {
			case hello

			public init(from decoder: Decoder) throws {
				self = .hello
			}

			public func encode(to encoder: Encoder) throws {
			}
		}
	}

	public typealias EnumRelationshipsEntity = Entity<EnumRelationshipsDescription>

	enum BadAttributeDescription: EntityDescription {
		public static var type: String { return "hello" }

		public struct Attributes: JSONAPI.Attributes {
			let x: Attribute<String>
			let y: String
		}

		public typealias Relationships = NoRelationships
	}

	public typealias BadAttributeEntity = Entity<BadAttributeDescription>

	enum BadRelationshipDescription: EntityDescription {
		public static var type: String { return "hello" }

		public typealias Attributes = NoAttributes

		public struct Relationships: JSONAPI.Relationships {
			let x: ToOneRelationship<OkEntity>
			let y: Id<String, OkEntity>
		}
	}

	public typealias BadRelationshipEntity = Entity<BadRelationshipDescription>

	enum OptionalArrayAttributeDescription: EntityDescription {
		public static var type: String { return "hello" }

		public struct Attributes: JSONAPI.Attributes {
			let x: Attribute<[String]>
			let y: Attribute<[String]?>
		}

		public typealias Relationships = NoRelationships
	}

	public typealias OptionalArrayAttributeEntity = Entity<OptionalArrayAttributeDescription>
}
