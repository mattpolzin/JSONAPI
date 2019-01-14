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

An object:
.object(.generic)

**/

extension String: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .string(.generic)
	}
}

extension Bool: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .boolean(.generic)
	}
}

extension Array: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .array(.generic)
	}
}

extension Double: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .number(.double)
	}
}

extension Float: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .number(.float)
	}
}

extension Int: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .integer(.generic)
	}
}

extension Int32: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .integer(.int32)
	}
}

extension Int64: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .integer(.int64)
	}
}
