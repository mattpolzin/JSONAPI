//
//  JSONAPIOpenAPITypes.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/13/19.
//

import JSONAPI

extension Attribute: OpenAPITyped where RawValue: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return value.openAPIType
	}
}

extension TransformedAttribute: OpenAPITyped where RawValue: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return rawValue.openAPIType
	}
}

extension ToOneRelationship: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .object(.generic)
	}
}

extension ToManyRelationship: OpenAPITyped {
	public var openAPIType: OpenAPI.JSONTypeFormat {
		return .object(.generic)
	}
}
