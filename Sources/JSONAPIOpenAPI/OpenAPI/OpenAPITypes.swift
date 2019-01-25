//
//  OpenAPITypes.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/13/19.
//

import AnyCodable
import Foundation

// MARK: Node (i.e. schema) Protocols

/// Anything conforming to `OpenAPINodeType` can provide an
/// OpenAPI schema representing itself.
public protocol OpenAPINodeType {
	static func openAPINode() throws -> JSONNode
}

/// Anything conforming to `OpenAPIEncodedNodeType` can provide an
/// OpenAPI schema representing itself but it may need an Encoder
/// to do its job.
public protocol OpenAPIEncodedNodeType: OpenAPINodeType {
	static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode
}

extension OpenAPIEncodedNodeType where Self: Sampleable, Self: Encodable {
	public static func openAPINodeWithExample(using encoder: JSONEncoder = JSONEncoder()) throws -> JSONNode {
		return try openAPINode(using: encoder).with(example: Self.successSample ?? Self.sample, using: encoder)
	}
}

extension OpenAPIEncodedNodeType {
	public static func openAPINode() throws -> JSONNode {
		return try openAPINode(using: JSONEncoder())
	}
}

/// Anything conforming to `RawOpenAPINodeType` can provide an
/// OpenAPI schema representing itself. This second protocol is
/// necessary so that one type can conditionally provide a
/// schema and then (under different conditions) provide a
/// different schema. The "different" conditions have to do
/// with Raw Representability, hence the name of this protocol.
public protocol RawOpenAPINodeType {
	static func rawOpenAPINode() throws -> JSONNode
}

/// Anything conforming to `RawOpenAPINodeType` can provide an
/// OpenAPI schema representing itself. This third protocol is
/// necessary so that one type can conditionally provide a
/// schema and then (under different conditions) provide a
/// different schema. The "different" conditions have to do
/// with Optionality, hence the name of this protocol.
public protocol WrappedRawOpenAPIType {
	static func wrappedOpenAPINode() throws -> JSONNode
}

/// Anything conforming to `RawOpenAPINodeType` can provide an
/// OpenAPI schema representing itself. This third protocol is
/// necessary so that one type can conditionally provide a
/// schema and then (under different conditions) provide a
/// different schema. The "different" conditions have to do
/// with Optionality, hence the name of this protocol.
public protocol DoubleWrappedRawOpenAPIType {
	// NOTE: This is definitely a rabbit hole... hopefully I
	// will realize I've been missing something obvious
	// and dig my way back out at some point...
	static func wrappedOpenAPINode() throws -> JSONNode
}

/// A GenericOpenAPINodeType can take a stab at
/// determining its OpenAPINode because it is sampleable.
public protocol GenericOpenAPINodeType {
	static func genericOpenAPINode(using encoder: JSONEncoder) throws -> JSONNode
}

/// Anything conforming to `DateOpenAPINodeType` is
/// able to attempt to represent itself as a date OpenAPINode
public protocol DateOpenAPINodeType {
	static func dateOpenAPINodeGuess(using encoder: JSONEncoder) -> JSONNode?
}

/// Anything conforming to `AnyJSONCaseIterable` can provide a
/// list of its possible values.
public protocol AnyJSONCaseIterable {
	static func allCases(using encoder: JSONEncoder) -> [AnyCodable]
}

extension AnyJSONCaseIterable {
	/// Given an array of Codable values, retrieve an array of AnyCodables.
	static func allCases<T: Codable>(from input: [T], using encoder: JSONEncoder) throws -> [AnyCodable] {
		if let alreadyGoodToGo = input as? [AnyCodable] {
			return alreadyGoodToGo
		}

		// The following is messy, but it does get us the intended result:
		// Given any array of things that can be encoded, we want
		// to map to an array of AnyCodable so we can store later. We need to
		// muck with JSONSerialization because something like an `enum` may
		// very well be encoded as a string, and therefore representable
		// by AnyCodable, but AnyCodable wants it to actually BE a String
		// upon initialization.

		guard let arrayOfCodables = try JSONSerialization.jsonObject(with: encoder.encode(input), options: []) as? [Any] else {
			throw OpenAPICodableError.allCasesArrayNotCodable
		}
		return arrayOfCodables.map(AnyCodable.init)
	}
}

/// Anything conforming to `AnyJSONCaseIterable` can provide a
/// list of its possible values. This second protocol is
/// necessary so that one type can conditionally provide a
/// list of possible values and then (under different conditions)
/// provide a different list of possible values.
/// The "different" conditions have to do
/// with Optionality, hence the name of this protocol.
public protocol AnyWrappedJSONCaseIterable {
	static func allCases(using encoder: JSONEncoder) -> [AnyCodable]
}

public protocol SwiftTyped {
	associatedtype SwiftType: Codable, Equatable
}

public protocol OpenAPIFormat: SwiftTyped, Codable, Equatable {
	static var unspecified: Self { get }

	var jsonType: JSONType { get }
}

public protocol JSONNodeContext {
	var required: Bool { get }
}

public enum JSONType: String, Codable {
	case boolean = "boolean"
	case object = "object"
	case array = "array"
	case number = "number"
	case integer = "integer"
	case string = "string"
}

public enum JSONTypeFormat: Equatable {
	case boolean(BooleanFormat)
	case object(ObjectFormat)
	case array(ArrayFormat)
	case number(NumberFormat)
	case integer(IntegerFormat)
	case string(StringFormat)

	public enum BooleanFormat: String, Equatable, OpenAPIFormat {
		case generic = ""

		public typealias SwiftType = Bool

		public static var unspecified: BooleanFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .boolean
		}
	}

	public enum ObjectFormat: String, Equatable, OpenAPIFormat {
		case generic = ""

		public typealias SwiftType = AnyCodable

		public static var unspecified: ObjectFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .object
		}
	}

	public enum ArrayFormat: String, Equatable, OpenAPIFormat {
		case generic = ""

		public typealias SwiftType = [AnyCodable]

		public static var unspecified: ArrayFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .array
		}
	}

	public enum NumberFormat: String, Equatable, OpenAPIFormat {
		case generic = ""
		case float = "float"
		case double = "double"

		public typealias SwiftType = Double

		public static var unspecified: NumberFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .number
		}
	}

	public enum IntegerFormat: String, Equatable, OpenAPIFormat {
		case generic = ""
		case int32 = "int32"
		case int64 = "int64"

		public typealias SwiftType = Int

		public static var unspecified: IntegerFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .integer
		}
	}

	public enum StringFormat: String, Equatable, OpenAPIFormat {
		case generic = ""
		case byte = "byte"
		case binary = "binary"
		case date = "date"
		case dateTime = "date-time"
		case password = "password"

		public typealias SwiftType = String

		public static var unspecified: StringFormat {
			return .generic
		}

		public var jsonType: JSONType {
			return .string
		}
	}

	public var jsonType: JSONType {
		switch self {
		case .boolean:
			return .boolean
		case .object:
			return .object
		case .array:
			return .array
		case .number:
			return .number
		case .integer:
			return .integer
		case .string:
			return .string
		}
	}
}

/// A JSON Node is what OpenAPI calls a
/// "Schema Object"
public enum JSONNode: Equatable {
	case boolean(Context<JSONTypeFormat.BooleanFormat>)
	indirect case object(Context<JSONTypeFormat.ObjectFormat>, ObjectContext)
	indirect case array(Context<JSONTypeFormat.ArrayFormat>, ArrayContext)
	case number(Context<JSONTypeFormat.NumberFormat>, NumericContext)
	case integer(Context<JSONTypeFormat.IntegerFormat>, NumericContext)
	case string(Context<JSONTypeFormat.StringFormat>, StringContext)
	indirect case all(of: [JSONNode])
	indirect case one(of: [JSONNode])
	indirect case any(of: [JSONNode])
	indirect case not(JSONNode)

	public struct Context<Format: OpenAPIFormat>: JSONNodeContext, Equatable {
		public let format: Format
		public let required: Bool
		public let nullable: Bool

		// NOTE: "const" is supported by the newest JSON Schema spec but not
		// yet by OpenAPI. Instead, will use "enum" with one possible value for now.
//		public let constantValue: Format.SwiftType?

		/// The OpenAPI spec calls this "enum"
		/// If not specified, it is assumed that any
		/// value of the given format is allowed.
		/// NOTE: I would like the array of allowed
		/// values to have the type `Format.SwiftType`
		/// but this is not tractable because I also
		/// want to be able to automatically turn any
		/// Swift type that will get _encoded as
		/// something compatible with_ `Format.SwiftType`
		/// into an allowed value.
		public let allowedValues: [AnyCodable]?

		// I wanted example to be AnyCodable, but alas that causes
		// runtime problems when encoding in a very strange way.
		// For now, a String (which is OK by the OpenAPI spec) will
		// have to do.
		public let example: String?

		public init(format: Format,
					required: Bool,
					nullable: Bool = false,
//					constantValue: Format.SwiftType? = nil,
					allowedValues: [AnyCodable]? = nil,
					example: (codable: AnyCodable, encoder: JSONEncoder)? = nil) {
			self.format = format
			self.required = required
			self.nullable = nullable
//			self.constantValue = constantValue
			self.allowedValues = allowedValues
			self.example = example
				.flatMap { try? $0.encoder.encode($0.codable)}
				.flatMap { String(data: $0, encoding: .utf8) }
		}

		/// Return the optional version of this Context
		public func optionalContext() -> Context {
			return .init(format: format,
						 required: false,
						 nullable: nullable,
//						 constantValue: constantValue,
						 allowedValues: allowedValues)
		}

		/// Return the required version of this context
		public func requiredContext() -> Context {
			return .init(format: format,
						 required: true,
						 nullable: nullable,
//						 constantValue: constantValue,
						 allowedValues: allowedValues)
		}

		/// Return the nullable version of this context
		public func nullableContext() -> Context {
			return .init(format: format,
						 required: required,
						 nullable: true,
//						 constantValue: constantValue,
						 allowedValues: allowedValues)
		}

		/// Return this context with the given list of possible values
		public func with(allowedValues: [AnyCodable]) -> Context {
			return .init(format: format,
						 required: required,
						 nullable: nullable,
//						 constantValue: constantValue,
						 allowedValues: allowedValues)
		}

		/// Return this context with the given example
		public func with(example: AnyCodable, using encoder: JSONEncoder) -> Context {
			return .init(format: format,
						 required: required,
						 nullable: nullable,
//						 constantValue: constantValue,
						 allowedValues: allowedValues,
						 example: (codable: example, encoder: encoder))
		}
	}

	public struct NumericContext: Equatable {
		/// A numeric instance is valid only if division by this keyword's value results in an integer. Defaults to nil.
		public let multipleOf: Double?
		public let maximum: Double?
		public let exclusiveMaximum: Double?
		public let minimum: Double?
		public let exclusiveMinimum: Double?

		public init(multipleOf: Double? = nil,
					maximum: Double? = nil,
					exclusiveMaximum: Double? = nil,
					minimum: Double? = nil,
					exclusiveMinimum: Double? = nil) {
			self.multipleOf = multipleOf
			self.maximum = maximum
			self.exclusiveMaximum = exclusiveMaximum
			self.minimum = minimum
			self.exclusiveMinimum = exclusiveMinimum
		}
	}

	public struct StringContext: Equatable {
		public let maxLength: Int?
		public let minLength: Int

		/// Regular expression
		public let pattern: String?

		public init(maxLength: Int? = nil,
					minLength: Int = 0,
					pattern: String? = nil) {
			self.maxLength = maxLength
			self.minLength = minLength
			self.pattern = pattern
		}
	}

	public struct ArrayContext: Equatable {
		/// A JSON Type Node that describes
		/// the type of each element in the array.
		public let items: JSONNode

		/// Maximum number of items in array.
		public let maxItems: Int?

		/// Minimum number of items in array.
		/// Defaults to 0.
		public let minItems: Int

		/// Setting to true indicates all
		/// elements of the array are expected
		/// to be unique. Defaults to false.
		public let uniqueItems: Bool

		public init(items: JSONNode,
					maxItems: Int? = nil,
					minItems: Int = 0,
					uniqueItems: Bool = false) {
			self.items = items
			self.maxItems = maxItems
			self.minItems = minItems
			self.uniqueItems = uniqueItems
		}
	}

	public struct ObjectContext: Equatable {
		public let maxProperties: Int?
		let _minProperties: Int
		public let properties: [String: JSONNode]
		public let additionalProperties: [String: JSONNode]?

		/*
		// NOTE that an object's required properties
		// array is determined by looking at its properties'
		// required Bool.
		*/
		public var requiredProperties: [String] {
			return Array(properties.filter { (name, node) in
				node.required
			}.keys)
		}

		public var minProperties: Int {
			return max(_minProperties, requiredProperties.count)
		}

		public init(properties: [String: JSONNode],
					additionalProperties: [String: JSONNode]? = nil,
					maxProperties: Int? = nil,
					minProperties: Int = 0) {
			self.properties = properties
			self.additionalProperties = additionalProperties
			self.maxProperties = maxProperties
			self._minProperties = minProperties
		}
	}

	public var jsonTypeFormat: JSONTypeFormat? {
		switch self {
		case .boolean(let context):
			return .boolean(context.format)
		case .object(let context, _):
			return .object(context.format)
		case .array(let context, _):
			return .array(context.format)
		case .number(let context, _):
			return .number(context.format)
		case .integer(let context, _):
			return .integer(context.format)
		case .string(let context, _):
			return .string(context.format)
		case .all, .one, .any, .not:
			return nil
		}
	}

	public var required: Bool {
		switch self {
		case .boolean(let contextA as JSONNodeContext),
			 .object(let contextA as JSONNodeContext, _),
			 .array(let contextA as JSONNodeContext, _),
			 .number(let contextA as JSONNodeContext, _),
			 .integer(let contextA as JSONNodeContext, _),
			 .string(let contextA as JSONNodeContext, _):
			return contextA.required
		case .all, .one, .any, .not:
			return true
		}
	}

	/// Return the optional version of this JSONNode
	public func optionalNode() -> JSONNode {
		switch self {
		case .boolean(let context):
			return .boolean(context.optionalContext())
		case .object(let contextA, let contextB):
			return .object(contextA.optionalContext(), contextB)
		case .array(let contextA, let contextB):
			return .array(contextA.optionalContext(), contextB)
		case .number(let context, let contextB):
			return .number(context.optionalContext(), contextB)
		case .integer(let context, let contextB):
			return .integer(context.optionalContext(), contextB)
		case .string(let context, let contextB):
			return .string(context.optionalContext(), contextB)
		case .all, .one, .any, .not:
			return self
		}
	}

	/// Return the required version of this JSONNode
	public func requiredNode() -> JSONNode {
		switch self {
		case .boolean(let context):
			return .boolean(context.requiredContext())
		case .object(let contextA, let contextB):
			return .object(contextA.requiredContext(), contextB)
		case .array(let contextA, let contextB):
			return .array(contextA.requiredContext(), contextB)
		case .number(let context, let contextB):
			return .number(context.requiredContext(), contextB)
		case .integer(let context, let contextB):
			return .integer(context.requiredContext(), contextB)
		case .string(let context, let contextB):
			return .string(context.requiredContext(), contextB)
		case .all, .one, .any, .not:
			return self
		}
	}

	/// Return the nullable version of this JSONNode
	public func nullableNode() -> JSONNode {
		switch self {
		case .boolean(let context):
			return .boolean(context.nullableContext())
		case .object(let contextA, let contextB):
			return .object(contextA.nullableContext(), contextB)
		case .array(let contextA, let contextB):
			return .array(contextA.nullableContext(), contextB)
		case .number(let context, let contextB):
			return .number(context.nullableContext(), contextB)
		case .integer(let context, let contextB):
			return .integer(context.nullableContext(), contextB)
		case .string(let context, let contextB):
			return .string(context.nullableContext(), contextB)
		case .all, .one, .any, .not:
			return self
		}
	}

	public func with(allowedValues: [AnyCodable]) throws -> JSONNode {

		switch self {
		case .boolean(let context):
			return .boolean(context.with(allowedValues: allowedValues))
		case .object(let contextA, let contextB):
			return .object(contextA.with(allowedValues: allowedValues), contextB)
		case .array(let contextA, let contextB):
			return .array(contextA.with(allowedValues: allowedValues), contextB)
		case .number(let context, let contextB):
			return .number(context.with(allowedValues: allowedValues), contextB)
		case .integer(let context, let contextB):
			return .integer(context.with(allowedValues: allowedValues), contextB)
		case .string(let context, let contextB):
			return .string(context.with(allowedValues: allowedValues), contextB)
		case .all, .one, .any, .not:
			return self
		}
	}

	public func with<T: Encodable>(example codableExample: T,
								   using encoder: JSONEncoder) throws -> JSONNode {
		let example: AnyCodable
		if let goodToGo = codableExample as? AnyCodable {
			example = goodToGo
		} else {
			example = AnyCodable(try JSONSerialization.jsonObject(with: encoder.encode(codableExample), options: []))
		}

		switch self {
		case .boolean(let context):
			return .boolean(context.with(example: example, using: encoder))
		case .object(let contextA, let contextB):
			return .object(contextA.with(example: example, using: encoder), contextB)
		case .array(let contextA, let contextB):
			return .array(contextA.with(example: example, using: encoder), contextB)
		case .number(let context, let contextB):
			return .number(context.with(example: example, using: encoder), contextB)
		case .integer(let context, let contextB):
			return .integer(context.with(example: example, using: encoder), contextB)
		case .string(let context, let contextB):
			return .string(context.with(example: example, using: encoder), contextB)
		case .all, .one, .any, .not:
			return self
		}
	}
}

public enum OpenAPICodableError: Swift.Error, Equatable {
	case allCasesArrayNotCodable
	case exampleNotCodable
	case primitiveGuessFailed
}

public enum OpenAPITypeError: Swift.Error {
	case invalidNode
	case unknownNodeType(Any.Type)
}
