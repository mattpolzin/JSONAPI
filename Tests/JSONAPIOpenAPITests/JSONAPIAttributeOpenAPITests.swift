//
//  JSONAPIAttributeOpenAPITests.swift
//  JSONAPIOpenAPITests
//
//  Created by Mathew Polzin on 1/20/19.
//

import XCTest
import JSONAPI
import JSONAPIOpenAPI
import SwiftCheck
import AnyCodable

class JSONAPIAttributeOpenAPITests: XCTestCase {
}

// MARK: - Boolean
extension JSONAPIAttributeOpenAPITests {
	func test_BooleanAttribute() {
		let node = try! Attribute<Bool>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .boolean(.generic))

		guard case .boolean(let contextA) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))
	}

	func test_NullableBooleanAttribute() {
		let node = try! Attribute<Bool?>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .boolean(.generic))

		guard case .boolean(let contextA) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: true,
									   allowedValues: nil))
	}

	func test_OptionalBooleanAttribute() {
		let node = try! Attribute<Bool>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .boolean(.generic))

		guard case .boolean(let contextA) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: false,
									   allowedValues: nil))
	}

	func test_OptionalNullableBooleanAttribute() {
		let node = try! Attribute<Bool?>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .boolean(.generic))

		guard case .boolean(let contextA) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: true,
									   allowedValues: nil))
	}
}

// MARK: - Array of Strings
extension JSONAPIAttributeOpenAPITests {
	func test_Arrayttribute() {
		let node = try! Attribute<[String]>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .array(.generic))

		guard case .array(let contextA, let arrayContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		let stringNode = JSONNode.string(.init(format: .generic,
											   required: true),
										 .init())

		XCTAssertEqual(arrayContext, .init(items: stringNode))
	}

	func test_NullableArrayAttribute() {
		let node = try! Attribute<[String]?>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .array(.generic))

		guard case .array(let contextA, let arrayContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: true,
									   allowedValues: nil))

		let stringNode = JSONNode.string(.init(format: .generic,
											   required: true),
										 .init())

		XCTAssertEqual(arrayContext, .init(items: stringNode))
	}

	func test_OptionalArrayAttribute() {
		let node = try! Attribute<[String]>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .array(.generic))

		guard case .array(let contextA, let arrayContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: false,
									   allowedValues: nil))

		let stringNode = JSONNode.string(.init(format: .generic,
											   required: true),
										 .init())

		XCTAssertEqual(arrayContext, .init(items: stringNode))
	}

	func test_OptionalNullableArrayAttribute() {
		let node = try! Attribute<[String]?>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .array(.generic))

		guard case .array(let contextA, let arrayContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: true,
									   allowedValues: nil))

		let stringNode = JSONNode.string(.init(format: .generic,
											   required: true),
										 .init())

		XCTAssertEqual(arrayContext, .init(items: stringNode))
	}
}

// MARK: - Number
extension JSONAPIAttributeOpenAPITests {
	func test_NumberAttribute() {
		let node = try! Attribute<Double>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}

	func test_NullableNumberAttribute() {
		let node = try! Attribute<Double?>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: true,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}

	func test_OptionalNumberAttribute() {
		let node = try! Attribute<Double>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: false,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}

	func test_OptionalNullableNumberAttribute() {
		let node = try! Attribute<Double?>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: false,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}

	func test_FloatNumberAttribute() {
		let node = try! Attribute<Float>.openAPINode()

		XCTAssertEqual(node.jsonTypeFormat, .number(.float))
	}
}

// MARK: - Integer
extension JSONAPIAttributeOpenAPITests {
	func test_IntegerAttribute() {
		let node = try! Attribute<Int>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .integer(.generic))

		guard case .integer(let contextA, let intContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(intContext, .init())
	}

	func test_NullableIntegerAttribute() {
		let node = try! Attribute<Int?>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .integer(.generic))

		guard case .integer(let contextA, let intContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(intContext, .init())
	}

	func test_OptionalIntegerAttribute() {
		let node = try! Attribute<Int>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .integer(.generic))

		guard case .integer(let contextA, let intContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(intContext, .init())
	}

	func test_OptionalNullableIntegerAttribute() {
		let node = try! Attribute<Int?>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .integer(.generic))

		guard case .integer(let contextA, let intContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(intContext, .init())
	}
}

// MARK: - String
extension JSONAPIAttributeOpenAPITests {
	func test_StringAttribute() {
		let node = try! Attribute<String>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.generic))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_NullableStringAttribute() {
		let node = try! Attribute<String?>.openAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.generic))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_OptionalStringAttribute() {
		let node = try! Attribute<String>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.generic))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_OptionalNullableStringAttribute() {
		let node = try! Attribute<String?>?.openAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.generic))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}
}

// MARK: - Enum
// NOTE: `enum` Attributes only gain the automatic support for allowed values
// (`enum` property in the OpenAPI Spec) at the Entity scope. These attributes
// will all still have `allowedValues: nil` at the attribute scope.
extension JSONAPIAttributeOpenAPITests {
	func test_EnumAttribute() {
		let node = try! Attribute<EnumAttribute>.rawOpenAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.generic))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_NullableEnumAttribute() {
		let node = try! Attribute<EnumAttribute?>.wrappedOpenAPINode()

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.generic))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: true,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_OptionalEnumAttribute() {
		let node = try! Attribute<EnumAttribute>?.wrappedOpenAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.generic))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_OptionalNullableEnumAttribute() {
		let node = try! Attribute<EnumAttribute?>?.wrappedOpenAPINode()

		XCTAssertFalse(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.generic))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .generic,
									   required: false,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}
}

// MARK: - Date
extension JSONAPIAttributeOpenAPITests {
	func test_DateStringAttribute() {
		// TEST:
		// Encoder is set to use
		// formatter with date
		// with no time.

		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale(identifier: "en_US")

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .formatted(dateFormatter)

		let node = Attribute<Date>.dateOpenAPINodeGuess(using: encoder)

		XCTAssertNotNil(node)

		XCTAssertTrue(node?.required ?? false)
		XCTAssertEqual(node?.jsonTypeFormat, .string(.date))

		guard case .string(let contextA, let stringContext)? = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .date,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_DateStringAttribute_Sampleable() {
		// TEST:
		// Encoder is set to use
		// formatter with date
		// with no time.

		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .none
		dateFormatter.locale = Locale(identifier: "en_US")

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .formatted(dateFormatter)

		let node = try! Attribute<Date>.genericOpenAPINode(using: encoder)

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.date))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .date,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_DateTimeStringAttribute() {
		// TEST:
		// Encoder is set to use
		// formatter with date
		// with time.

		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		dateFormatter.locale = Locale(identifier: "en_US")

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .formatted(dateFormatter)

		let node = Attribute<Date>.dateOpenAPINodeGuess(using: encoder)

		XCTAssertNotNil(node)

		XCTAssertTrue(node?.required ?? false)
		XCTAssertEqual(node?.jsonTypeFormat, .string(.dateTime))

		guard case .string(let contextA, let stringContext)? = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .dateTime,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_DateTimeStringAttribute_Sampleable() {
		// TEST:
		// Encoder is set to use
		// formatter with date
		// with time.

		let dateFormatter = DateFormatter()
		dateFormatter.dateStyle = .medium
		dateFormatter.timeStyle = .short
		dateFormatter.locale = Locale(identifier: "en_US")

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .formatted(dateFormatter)

		let node = try! Attribute<Date>.genericOpenAPINode(using: encoder)

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .string(.dateTime))

		guard case .string(let contextA, let stringContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .dateTime,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(stringContext, .init())
	}

	func test_8601DateStringAttribute() {
		if #available(OSX 10.12, *) {
			// TEST:
			// Encoder is set to use
			// iso8601 date format

			let encoder = JSONEncoder()
			encoder.outputFormatting = .prettyPrinted
			encoder.dateEncodingStrategy = .iso8601

			let node = Attribute<Date>.dateOpenAPINodeGuess(using: encoder)

			XCTAssertNotNil(node)

			XCTAssertTrue(node?.required ?? false)
			XCTAssertEqual(node?.jsonTypeFormat, .string(.dateTime))

			guard case .string(let contextA, let stringContext)? = node else {
				XCTFail("Expected string Node")
				return
			}

			XCTAssertEqual(contextA, .init(format: .dateTime,
										   required: true,
										   nullable: false,
										   allowedValues: nil))

			XCTAssertEqual(stringContext, .init())
		}
	}

	func test_8601DateStringAttribute_Sampleable() {
		if #available(OSX 10.12, *) {
			// TEST:
			// Encoder is set to use
			// iso8601 date format

			let encoder = JSONEncoder()
			encoder.outputFormatting = .prettyPrinted
			encoder.dateEncodingStrategy = .iso8601

			let node = try! Attribute<Date>.genericOpenAPINode(using: encoder)

			XCTAssertTrue(node.required)
			XCTAssertEqual(node.jsonTypeFormat, .string(.dateTime))

			guard case .string(let contextA, let stringContext) = node else {
				XCTFail("Expected string Node")
				return
			}

			XCTAssertEqual(contextA, .init(format: .dateTime,
										   required: true,
										   nullable: false,
										   allowedValues: nil))

			XCTAssertEqual(stringContext, .init())
		}
	}

	func test_DateNumberAttribute() {
		// TEST:
		// Encoder is set to use
		// seconds since 1970 as
		// date format

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .secondsSince1970

		let node = Attribute<Date>.dateOpenAPINodeGuess(using: encoder)

		XCTAssertNotNil(node)

		XCTAssertTrue(node?.required ?? false)
		XCTAssertEqual(node?.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext)? = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}

	func test_DateNumberAttribute_Sampleable() {
		// TEST:
		// Encoder is set to use
		// seconds since 1970 as
		// date format

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .secondsSince1970

		let node = try! Attribute<Date>.genericOpenAPINode(using: encoder)

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}

	func test_DateDeferredAttribute() {
		// TEST:
		// Encoder is set to use
		// Date default encoding

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .deferredToDate

		let node = Attribute<Date>.dateOpenAPINodeGuess(using: encoder)

		XCTAssertNil(node)
	}

	func test_DateDeferredAttribute_Sampleable() {
		// TEST:
		// Encoder is set to use
		// Date default encoding

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .deferredToDate

		let node = try! Attribute<Date>.genericOpenAPINode(using: encoder)

		XCTAssertTrue(node.required)
		XCTAssertEqual(node.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext) = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: true,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}

	func test_NullableDateAttribute() {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .secondsSince1970

		let node = Attribute<Date?>.dateOpenAPINodeGuess(using: encoder)

		XCTAssertNotNil(node)

		XCTAssertTrue(node?.required ?? false)
		XCTAssertEqual(node?.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext)? = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: true,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}

	func test_OptionalDateAttribute() {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .secondsSince1970

		let node = Attribute<Date>?.dateOpenAPINodeGuess(using: encoder)

		XCTAssertNotNil(node)

		XCTAssertFalse(node?.required ?? true)
		XCTAssertEqual(node?.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext)? = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: false,
									   nullable: false,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}

	func test_OptionalNullableDateAttribute() {
		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted
		encoder.dateEncodingStrategy = .secondsSince1970

		let node = Attribute<Date?>?.dateOpenAPINodeGuess(using: encoder)

		XCTAssertNotNil(node)

		XCTAssertFalse(node?.required ?? true)
		XCTAssertEqual(node?.jsonTypeFormat, .number(.double))

		guard case .number(let contextA, let numberContext)? = node else {
			XCTFail("Expected string Node")
			return
		}

		XCTAssertEqual(contextA, .init(format: .double,
									   required: false,
									   nullable: true,
									   allowedValues: nil))

		XCTAssertEqual(numberContext, .init())
	}
}

// MARK: - Test Types
extension JSONAPIAttributeOpenAPITests {
	enum EnumAttribute: String, Codable, CaseIterable {
		case one
		case two
	}
}

extension Date: SampleableOpenAPIType {
	public static var sample: Date {
		return TimeInterval.arbitrary.map { Date(timeIntervalSince1970: $0) }.generate
	}
}
