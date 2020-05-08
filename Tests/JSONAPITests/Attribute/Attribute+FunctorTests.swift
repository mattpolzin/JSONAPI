//
//  Attribute+FunctorTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/28/18.
//

import XCTest
import JSONAPI
import JSONAPITesting

class Attribute_FunctorTests: XCTestCase {
	func test_mapGuaranteed() {
		let entity = try? TestType(attributes: .init(name: "Frankie", number: .init(rawValue: 22.0)), relationships: .none, meta: .none, links: .none)

		XCTAssertNotNil(entity)


        XCTAssertEqual(entity?.computedString, "Frankie2")
	}

	func test_mapOptionalSuccess() {
		let entity = try? TestType(attributes: .init(name: "Frankie", number: .init(rawValue: 22.0)), relationships: .none, meta: .none, links: .none)

		XCTAssertNotNil(entity)

        XCTAssertEqual(entity?.computedNumber, 22)
	}

	func test_mapOptionalFailure() {
		let entity = try? TestType(attributes: .init(name: "Frankie", number: .init(rawValue: 22.5)), relationships: .none, meta: .none, links: .none)

		XCTAssertNotNil(entity)

        XCTAssertNil(entity?.computedNumber)
	}
}

// MARK: Test types
extension Attribute_FunctorTests {
	enum TestTypeDescription: ResourceObjectDescription {
		public static var jsonType: String { return "test" }

		public struct Attributes: JSONAPI.Attributes {
			let name: Attribute<String>
			let number: TransformedAttribute<Double, DoubleToString>
			var computedString: Attribute<String> {
				return name.map { $0 + "2" }
			}
			var computedNumber: Attribute<Int>? {
				return try? number.map { string in
					let num = Double(string).flatMap { Int(exactly: $0) }
					guard let ret = num else {
						throw DecodingError.typeMismatch(Int.self, .init(codingPath: [], debugDescription: "String was not an Int."))
					}
					return ret
				}
			}
		}

		public typealias Relationships = NoRelationships
	}

	typealias TestType = BasicEntity<TestTypeDescription>

	enum DoubleToString: Transformer {
		public static func transform(_ from: Double) -> String {
			return String(from)
		}
	}
}
