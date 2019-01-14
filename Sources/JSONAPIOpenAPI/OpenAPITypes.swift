//
//  OpenAPITypes.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/13/19.
//

public protocol OpenAPITyped {
	var openAPIType: OpenAPI.JSONTypeFormat { get }
}

public protocol SwiftTyped {
	associatedtype SwiftType
}

public protocol OpenAPIFormat: SwiftTyped {}

public extension OpenAPI {
	enum JSONType: String {
		case boolean = "boolean"
		case object = "object"
		case array = "array"
		case number = "number"
		case integer = "integer"
		case string = "string"
	}

	enum JSONTypeFormat: Equatable {
		case boolean(BooleanFormat)
		case object(ObjectFormat)
		case array(ArrayFormat)
		case number(NumberFormat)
		case integer(IntegerFormat)
		case string(StringFormat)
	}

	enum JSONTypeNode {
		case boolean(Context<JSONTypeFormat.BooleanFormat>)
		indirect case object(Context<JSONTypeFormat.ObjectFormat>, ObjectContext)
		indirect case array(Context<JSONTypeFormat.ArrayFormat>, ArrayContext)
		case number(Context<JSONTypeFormat.NumberFormat>, NumericContext)
		case integer(Context<JSONTypeFormat.IntegerFormat>, NumericContext)
		case string(Context<JSONTypeFormat.StringFormat>, StringContext)
		indirect case allOf([JSONTypeNode])
		indirect case oneOf([JSONTypeNode])
		indirect case anyOf([JSONTypeNode])
		indirect case not(JSONTypeNode)
	}
}

extension OpenAPI.JSONType {
	public var swiftType: Any.Type {
		switch self {
		case .boolean:
			return Bool.self
		case .object:
			return Any.self
		case .array:
			return [Any].self
		case .number:
			return Double.self
		case .integer:
			return Int.self
		case .string:
			return String.self
		}
	}
}

public extension OpenAPI.JSONTypeFormat {
	public enum BooleanFormat: String, Equatable, Codable, OpenAPIFormat {
		case generic = ""

		public typealias SwiftType = Bool
	}

	public enum ObjectFormat: String, Equatable, Codable, OpenAPIFormat {
		case generic = ""

		public typealias SwiftType = Any
	}

	public enum ArrayFormat: String, Equatable, Codable, OpenAPIFormat {
		case generic = ""

		public typealias SwiftType = [Any]
	}

	public enum NumberFormat: String, Equatable, Codable, OpenAPIFormat {
		case generic = ""
		case float = "float"
		case double = "double"

		public typealias SwiftType = Double
	}

	public enum IntegerFormat: String, Equatable, Codable, OpenAPIFormat {
		case generic = ""
		case int32 = "int32"
		case int64 = "int64"

		public typealias SwiftType = Int
	}

	public enum StringFormat: String, Equatable, Codable, OpenAPIFormat {
		case generic = ""
		case byte = "byte"
		case binary = "binary"
		case date = "date"
		case dateTime = "date-time"
		case password = "password"

		public typealias SwiftType = String
	}

	public var jsonType: OpenAPI.JSONType {
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

extension OpenAPI.JSONTypeNode {
	public struct Context<Format: OpenAPIFormat> {
		public let format: Format
		public let required: Bool

		/// The OpenAPI spec calls this "enum"
		/// If not specified, it is assumed that any
		/// value of the given format is allowed.
		public let allowedValues: [Format.SwiftType]?

		public init(format: Format,
					required: Bool,
					allowedValues: [Format.SwiftType]? = nil) {
			self.format = format
			self.required = required
			self.allowedValues = allowedValues
		}
	}

	public struct NumericContext {
		public let multipleOf: Double?
		public let maximum: Double?
		public let exclusiveMaximum: Double?
		public let minimum: Double?
		public let exclusiveMinimum: Double?
	}

	public struct StringContext {
		public let maxLength: Int?
		public let minLength: Int?

		/// Regular expression
		public let pattern: String?
	}

	public struct ArrayContext {
		/// A JSON Type Node that describes
		/// the type of each element in the array.
		public let items: OpenAPI.JSONTypeNode

		public let maxItems: Int?
		public let minItems: Int?
		public let uniqueItems: Bool?
	}

	public struct ObjectContext {
		public let maxProperties: Int?
		public let minProperties: Int?
		public let properties: [String: OpenAPI.JSONTypeNode]
		public let additionalProperties: [String: OpenAPI.JSONTypeNode]

		/*
		// NOTE that an object's required properties
		// array is determined by looking at its properties'
		// required Bool.
		public let required: [String]
		*/
	}

	public var jsonTypeFormat: OpenAPI.JSONTypeFormat? {
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
		case .allOf, .oneOf, .anyOf, .not:
			return nil
		}
	}
}
