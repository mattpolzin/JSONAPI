//
//  PolyProxyTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/29/18.
//

import XCTest
import JSONAPI
import Poly

public class PolyProxyTests: XCTestCase {
	func test_generalReasonableness() {
		XCTAssertNotEqual(decoded(type: User.self, data: poly_user_stub_1), decoded(type: User.self, data: poly_user_stub_2))
		XCTAssertEqual(User.jsonType, "users")
	}

	func test_UserADecode() {
		let polyUserA = decoded(type: User.self, data: poly_user_stub_1)
		let userA = decoded(type: UserA.self, data: poly_user_stub_1)

		XCTAssertEqual(polyUserA.userA, userA)
		XCTAssertNil(polyUserA.userB)
		XCTAssertEqual(polyUserA[\.name], "Ken Moore")
		XCTAssertEqual(polyUserA.id, "1")
		XCTAssertEqual(polyUserA.relationships, .none)
        XCTAssertEqual(polyUserA[direct: \.x], .init(x: "y"))
	}

	func test_UserAAndBEncodeEquality() {
		test_DecodeEncodeEquality(type: User.self, data: poly_user_stub_1)
		test_DecodeEncodeEquality(type: User.self, data: poly_user_stub_2)
	}

	func test_AsymmetricEncodeDecodeUserA() {
		let userA = decoded(type: UserA.self, data: poly_user_stub_1)
		let polyUserA = decoded(type: User.self, data: poly_user_stub_1)

		let encodedPoly = try! JSONEncoder().encode(polyUserA)

		XCTAssertEqual(decoded(type: UserA.self, data: encodedPoly), userA)
	}

	func test_AsymmetricEncodeDecodeUserB() {
		let userB = decoded(type: UserB.self, data: poly_user_stub_2)
		let polyUserB = decoded(type: User.self, data: poly_user_stub_2)

		let encodedPoly = try! JSONEncoder().encode(polyUserB)

		XCTAssertEqual(decoded(type: UserB.self, data: encodedPoly), userB)
	}

	func test_UserBDecode() {
		let polyUserB = decoded(type: User.self, data: poly_user_stub_2)
		let userB = decoded(type: UserB.self, data: poly_user_stub_2)

		XCTAssertEqual(polyUserB.userB, userB)
		XCTAssertNil(polyUserB.userA)
		XCTAssertEqual(polyUserB[\.name], "Ken Less")
		XCTAssertEqual(polyUserB.id, "2")
		XCTAssertEqual(polyUserB.relationships, .none)
        XCTAssertEqual(polyUserB[direct: \.x], .init(x: "y"))
	}
}

// MARK: - Test types
public extension PolyProxyTests {
	enum UserDescription1: ResourceObjectDescription {
		public static var jsonType: String { return "users" }

		public struct Attributes: JSONAPI.Attributes {
			let firstName: Attribute<String>
			let lastName: Attribute<String>
		}

		public typealias Relationships = NoRelationships
	}

	enum UserDescription2: ResourceObjectDescription {
		public static var jsonType: String { return "users" }

		public struct Attributes: JSONAPI.Attributes {
			let name: Attribute<[String]>
		}

		public typealias Relationships = NoRelationships
	}

	typealias UserA = BasicEntity<UserDescription1>
	typealias UserB = BasicEntity<UserDescription2>

	typealias User = Poly2<UserA, UserB>
}

extension Poly2: ResourceObjectProxy, JSONTyped where A == PolyProxyTests.UserA, B == PolyProxyTests.UserB {

	public var userA: PolyProxyTests.UserA? {
		return a
	}

	public var userB: PolyProxyTests.UserB? {
		return b
	}

	public var id: Id<EntityRawIdType, PolyProxyTests.User> {
		switch self {
		case .a(let a):
			return Id(rawValue: a.id.rawValue)
		case .b(let b):
			return Id(rawValue: b.id.rawValue)
		}
	}

	public var attributes: SharedUserDescription.Attributes {
		switch self {
		case .a(let a):
			return .init(name: .init(value: "\(a[\.firstName]) \(a[\.lastName])"), x: .init(x: "y"))
		case .b(let b):
			return .init(name: .init(value: b[\.name].joined(separator: " ")), x: .init(x: "y"))
		}
	}

	public var relationships: NoRelationships {
		return .none
	}

	public enum SharedUserDescription: ResourceObjectProxyDescription {
		public static var jsonType: String { return A.jsonType }

		public struct Attributes: Equatable {
			let name: Attribute<String>
			let x: SomeRandomThingThatIsNotCodable
		}

		public typealias Relationships = NoRelationships

		public struct SomeRandomThingThatIsNotCodable: Equatable {
			let x: String
		}
	}

	public typealias Description = SharedUserDescription

	public typealias EntityRawIdType = A.EntityRawIdType
}

// MARK: - Test stubs
private let poly_user_stub_1 = """
{
	"id": "1",
	"type": "users",
	"attributes": {
		"firstName": "Ken",
		"lastName": "Moore"
	}
}
""".data(using: .utf8)!

private let poly_user_stub_2 = """
{
	"id": "2",
	"type": "users",
	"attributes": {
		"name": ["Ken", "Less"]
	}
}
""".data(using: .utf8)!
