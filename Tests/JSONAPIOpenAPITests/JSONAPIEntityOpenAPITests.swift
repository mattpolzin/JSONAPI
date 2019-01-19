//
//  JSONAPIEntityOpenAPITests.swift
//  JSONAPIOpenAPITests
//
//  Created by Mathew Polzin on 1/15/19.
//

import XCTest
import JSONAPI
import JSONAPIOpenAPI

class JSONAPIEntityOpenAPITests: XCTestCase {
	func test_EmptyEntity() {
		let node = try! TestType1.openAPINode()

		// TODO: Write test

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let string = String(data: try! encoder.encode(node), encoding: .utf8)!
		print(string)
	}

	func test_AttributesEntity() {

		let tmp = ["hello"] as [Any]
		let tmp2 = tmp as! [String]
		let tmp3 = tmp as? RawStringArrayRepresentable
		let tmp4 = tmp2 as? RawStringArrayRepresentable

		let y = TestType2Description.EnumType.one
		let z = y as Any

		let x = [y as? TestType2Description.EnumType]

		let node = try! TestType2.openAPINode()

		// TODO: Write test

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		let string = String(data: try! encoder.encode(node), encoding: .utf8)!
		print(string)
	}
}

// MARK: Test Types
extension JSONAPIEntityOpenAPITests {
	enum TestType1Description: EntityDescription {
		public static var jsonType: String { return "test1" }

		public typealias Attributes = NoAttributes

		public typealias Relationships = NoRelationships
	}

	typealias TestType1 = BasicEntity<TestType1Description>

	enum TestType2Description: EntityDescription {
		public static var jsonType: String { return "test1" }

		public enum EnumType: String, CaseIterable, Codable, Equatable {
			case one
			case two
		}

		public struct Attributes: JSONAPI.Attributes, Sampleable {
			let stringProperty: Attribute<String>
			let enumProperty: Attribute<EnumType>
			var computedProperty: Attribute<EnumType> {
				return enumProperty
			}

			public static var sample: Attributes {
				return Attributes(stringProperty: .init(value: "hello"),
								  enumProperty: .init(value: .one))
			}
		}

		public typealias Relationships = NoRelationships
	}

	typealias TestType2 = BasicEntity<TestType2Description>
}
