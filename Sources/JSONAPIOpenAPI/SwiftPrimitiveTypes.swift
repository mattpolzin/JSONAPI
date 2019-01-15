//
//  PrimitiveTypes.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 01/13/19.
//

/**

Notable omissions in this library's default offerings:

Base 64 encoded characters:
.string(.byte)

Any sequence of octets:
.string(.binary)

RFC3339 full-date:
.string(.date)

RFC3339 date-time:
.string(.dateTime)

A hint to UIs to obscure input:
.string(.password)

Any object:
.object(.generic)

**/

extension Optional: OpenAPINodeType where Wrapped: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return Wrapped.openAPINode.optionalNode()
	}
}

extension String: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return .string(.init(format: .generic,
							 required: true),
					   .init())
	}
}

extension Bool: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return .boolean(.init(format: .generic,
							  required: true))
	}
}

extension Array: OpenAPINodeType where Element: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return .array(.init(format: .generic,
							required: true),
					  .init(items: Element.openAPINode))
	}
}

extension Double: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return .number(.init(format: .double,
							 required: true),
					   .init())
	}
}

extension Float: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return .number(.init(format: .float,
							 required: true),
					   .init())
	}
}

extension Int: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return .integer(.init(format: .generic,
							  required: true),
						.init())
	}
}

extension Int32: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return .integer(.init(format: .int32,
							  required: true),
						.init())
	}
}

extension Int64: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return .integer(.init(format: .int64,
							  required: true),
						.init())
	}
}
