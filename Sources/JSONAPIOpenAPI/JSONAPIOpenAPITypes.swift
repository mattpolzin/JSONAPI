//
//  JSONAPIOpenAPITypes.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/13/19.
//

import JSONAPI

extension Attribute: OpenAPINodeType where RawValue: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return RawValue.openAPINode
	}
}

extension TransformedAttribute: OpenAPINodeType where RawValue: OpenAPINodeType {
	static public var openAPINode: OpenAPI.JSONNode {
		return RawValue.openAPINode
	}
}

private protocol _Optional {}
extension Optional: _Optional {}

extension ToOneRelationship: OpenAPINodeType {
	// TODO: const for json `type`
	static public var openAPINode: OpenAPI.JSONNode {
		let nullable = Identifiable.self is _Optional.Type
		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: [
						"data": .object(.init(format: .generic,
											  required: true,
											  nullable: nullable),
										.init(properties: [
											"id": .string(.init(format: .generic,
																required: true),
														  .init()),
											"type": .string(.init(format: .generic,
																  required: true),
															.init())
											]))
						]))
	}
}

extension ToManyRelationship: OpenAPINodeType {
	// TODO: const for json `type`
	static public var openAPINode: OpenAPI.JSONNode {
		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: [
						"data": .array(.init(format: .generic,
											 required: true),
									   .init(items: .object(.init(format: .generic,
																  required: true),
															.init(properties: [
																"id": .string(.init(format: .generic,
																					required: true),
																			  .init()),
																"type": .string(.init(format: .generic,
																					  required: true),
																				.init())
																]))))
						]))
	}
}
