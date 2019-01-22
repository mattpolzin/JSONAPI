//
//  JSONAPIInclude+OpenAPI.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/22/19.
//

import JSONAPI

extension Includes: OpenAPINodeType where I: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		let includeNode = try I.openAPINode()

		return .array(.init(format: .generic,
							required: true),
					  .init(items: includeNode,
							uniqueItems: true))
	}
}

extension Include0: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		throw OpenAPITypeError.invalidNode
	}
}

extension Include1: OpenAPINodeType where A: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try .one(of: [A.openAPINode()])
	}
}

extension Include2: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(),
			B.openAPINode()
		])
	}
}

extension Include3: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(),
			B.openAPINode(),
			C.openAPINode()
			])
	}
}

extension Include4: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(),
			B.openAPINode(),
			C.openAPINode(),
			D.openAPINode()
			])
	}
}

extension Include5: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(),
			B.openAPINode(),
			C.openAPINode(),
			D.openAPINode(),
			E.openAPINode()
			])
	}
}

extension Include6: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType, F: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(),
			B.openAPINode(),
			C.openAPINode(),
			D.openAPINode(),
			E.openAPINode(),
			F.openAPINode()
			])
	}
}

extension Include7: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType, F: OpenAPINodeType, G: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(),
			B.openAPINode(),
			C.openAPINode(),
			D.openAPINode(),
			E.openAPINode(),
			F.openAPINode(),
			G.openAPINode()
			])
	}
}

extension Include8: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType, F: OpenAPINodeType, G: OpenAPINodeType, H: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(),
			B.openAPINode(),
			C.openAPINode(),
			D.openAPINode(),
			E.openAPINode(),
			F.openAPINode(),
			G.openAPINode(),
			H.openAPINode()
			])
	}
}

extension Include9: OpenAPINodeType where A: OpenAPINodeType, B: OpenAPINodeType, C: OpenAPINodeType, D: OpenAPINodeType, E: OpenAPINodeType, F: OpenAPINodeType, G: OpenAPINodeType, H: OpenAPINodeType, I: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try .one(of: [
			A.openAPINode(),
			B.openAPINode(),
			C.openAPINode(),
			D.openAPINode(),
			E.openAPINode(),
			F.openAPINode(),
			G.openAPINode(),
			H.openAPINode(),
			I.openAPINode()
			])
	}
}
