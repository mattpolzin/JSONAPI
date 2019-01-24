//
//  JSONAPIInclude+OpenAPI.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/22/19.
//

import JSONAPI
import Foundation

extension Includes: OpenAPINodeType where I: OpenAPINodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		let includeNode = try I.openAPINode(using: encoder)

		return .array(.init(format: .generic,
							required: true),
					  .init(items: includeNode,
							uniqueItems: true))
	}
}

extension Include0: OpenAPINodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		throw OpenAPITypeError.invalidNode
	}
}

extension Include1: OpenAPINodeType where A: OpenAPINodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [A.openAPINode(using: encoder)])
	}
}

extension Include2: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder)
		])
	}
}

extension Include3: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder),
			C.openAPINode(using: encoder)
			])
	}
}

extension Include4: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(using: encoder),
			B.openAPINode(using: encoder),
			C.openAPINode(using: encoder),
			D.openAPINode(using: encoder)
			])
	}
}

extension Include5: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType {
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

extension Include6: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType, F: OpenAPINodeType {
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

extension Include7: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType, F: OpenAPINodeType, G: OpenAPINodeType {
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

extension Include8: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType, F: OpenAPINodeType, G: OpenAPINodeType, H: OpenAPINodeType {
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

extension Include9: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType, F: OpenAPINodeType, G: OpenAPINodeType, H: OpenAPINodeType, I: OpenAPINodeType {
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
