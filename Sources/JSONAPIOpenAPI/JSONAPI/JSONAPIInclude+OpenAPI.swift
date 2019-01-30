//
//  JSONAPIInclude+OpenAPI.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/22/19.
//

import JSONAPI
import Foundation

extension Includes: OpenAPIEncodedNodeType where I: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		let includeNode = try I.openAPINode(using: encoder)

		return .array(.init(format: .generic,
							required: true),
					  .init(items: includeNode,
							uniqueItems: true))
	}
}

extension Include0: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		throw OpenAPITypeError.invalidNode
	}
}

extension Include1: OpenAPIEncodedNodeType where A: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try A.openAPINode(using: encoder)
	}
}

extension Include2: OpenAPIEncodedNodeType where A: OpenAPIEncodedNodeType, B: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder)
		])
	}
}

extension Include3: OpenAPIEncodedNodeType where A: OpenAPIEncodedNodeType, B: OpenAPIEncodedNodeType, C: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder),
			C.openAPINode(using: encoder)
			])
	}
}

extension Include4: OpenAPIEncodedNodeType where A: OpenAPIEncodedNodeType, B: OpenAPIEncodedNodeType, C: OpenAPIEncodedNodeType, D: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder),
			C.openAPINode(using: encoder),
			D.openAPINode(using: encoder)
			])
	}
}

extension Include5: OpenAPIEncodedNodeType where A: OpenAPIEncodedNodeType, B: OpenAPIEncodedNodeType, C: OpenAPIEncodedNodeType, D: OpenAPIEncodedNodeType, E: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder),
			C.openAPINode(using: encoder),
			D.openAPINode(using: encoder),
			E.openAPINode(using: encoder)
			])
	}
}

extension Include6: OpenAPIEncodedNodeType where A: OpenAPIEncodedNodeType, B: OpenAPIEncodedNodeType, C: OpenAPIEncodedNodeType, D: OpenAPIEncodedNodeType, E: OpenAPIEncodedNodeType, F: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder),
			C.openAPINode(using: encoder),
			D.openAPINode(using: encoder),
			E.openAPINode(using: encoder),
			F.openAPINode(using: encoder)
			])
	}
}

extension Include7: OpenAPIEncodedNodeType where A: OpenAPIEncodedNodeType, B: OpenAPIEncodedNodeType, C: OpenAPIEncodedNodeType, D: OpenAPIEncodedNodeType, E: OpenAPIEncodedNodeType, F: OpenAPIEncodedNodeType, G: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder),
			C.openAPINode(using: encoder),
			D.openAPINode(using: encoder),
			E.openAPINode(using: encoder),
			F.openAPINode(using: encoder),
			G.openAPINode(using: encoder)
			])
	}
}

extension Include8: OpenAPIEncodedNodeType where A: OpenAPIEncodedNodeType, B: OpenAPIEncodedNodeType, C: OpenAPIEncodedNodeType, D: OpenAPIEncodedNodeType, E: OpenAPIEncodedNodeType, F: OpenAPIEncodedNodeType, G: OpenAPIEncodedNodeType, H: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder),
			C.openAPINode(using: encoder),
			D.openAPINode(using: encoder),
			E.openAPINode(using: encoder),
			F.openAPINode(using: encoder),
			G.openAPINode(using: encoder),
			H.openAPINode(using: encoder)
			])
	}
}

extension Include9: OpenAPIEncodedNodeType where A: OpenAPIEncodedNodeType, B: OpenAPIEncodedNodeType, C: OpenAPIEncodedNodeType, D: OpenAPIEncodedNodeType, E: OpenAPIEncodedNodeType, F: OpenAPIEncodedNodeType, G: OpenAPIEncodedNodeType, H: OpenAPIEncodedNodeType, I: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder),
			C.openAPINode(using: encoder),
			D.openAPINode(using: encoder),
			E.openAPINode(using: encoder),
			F.openAPINode(using: encoder),
			G.openAPINode(using: encoder),
			H.openAPINode(using: encoder),
			I.openAPINode(using: encoder)
			])
	}
}
