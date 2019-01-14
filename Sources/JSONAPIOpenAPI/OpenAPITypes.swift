//
//  OpenAPITypes.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 1/13/19.
//

public protocol OpenAPITyped {
	var openAPIType: OpenAPI.JSONTypeFormat { get }
}

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
}

public extension OpenAPI.JSONTypeFormat {
	public enum BooleanFormat: String, Equatable, Codable {
		case generic = ""
	}

	public enum ObjectFormat: String, Equatable, Codable {
		case generic = ""
	}

	public enum ArrayFormat: String, Equatable, Codable {
		case generic = ""
	}

	public enum NumberFormat: String, Equatable, Codable {
		case generic = ""
		case float = "float"
		case double = "double"
	}

	public enum IntegerFormat: String, Equatable, Codable {
		case generic = ""
		case int32 = "int32"
		case int64 = "int64"
	}

	public enum StringFormat: String, Equatable, Codable {
		case generic = ""
		case byte = "byte"
		case binary = "binary"
		case date = "date"
		case dateTime = "date-time"
		case password = "password"
	}

	public var type: OpenAPI.JSONType {
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
