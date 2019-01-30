//
//  JSONAPIAttribute+OpenAPI.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/28/19.
//

import JSONAPI
import Foundation
import AnyCodable

private protocol _Optional {}
extension Optional: _Optional {}

private protocol Wrapper {
	associatedtype Wrapped
}
extension Optional: Wrapper {}

// MARK: Attribute
extension Attribute: OpenAPINodeType where RawValue: OpenAPINodeType {
	static public func openAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.openAPINode().required {
			return try RawValue.openAPINode().requiredNode().nullableNode()
		}
		return try RawValue.openAPINode()
	}
}

extension Attribute: RawOpenAPINodeType where RawValue: RawRepresentable, RawValue.RawValue: OpenAPINodeType {
	static public func rawOpenAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.RawValue.openAPINode().required {
			return try RawValue.RawValue.openAPINode().requiredNode().nullableNode()
		}
		return try RawValue.RawValue.openAPINode()
	}
}

extension Attribute: WrappedRawOpenAPIType where RawValue: RawOpenAPINodeType {
	public static func wrappedOpenAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.rawOpenAPINode().required {
			return try RawValue.rawOpenAPINode().requiredNode().nullableNode()
		}
		return try RawValue.rawOpenAPINode()
	}
}

extension Attribute: GenericOpenAPINodeType where RawValue: GenericOpenAPINodeType {
	public static func genericOpenAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.genericOpenAPINode(using: encoder).required {
			return try RawValue.genericOpenAPINode(using: encoder).requiredNode().nullableNode()
		}
		return try RawValue.genericOpenAPINode(using: encoder)
	}
}

extension Attribute: DateOpenAPINodeType where RawValue: DateOpenAPINodeType {
	public static func dateOpenAPINodeGuess(using encoder: JSONEncoder) -> JSONNode? {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if
			!(RawValue.dateOpenAPINodeGuess(using: encoder)?.required ?? true) {
			return RawValue.dateOpenAPINodeGuess(using: encoder)?.requiredNode().nullableNode()
		}
		return RawValue.dateOpenAPINodeGuess(using: encoder)
	}
}

extension Attribute: AnyJSONCaseIterable where RawValue: CaseIterable, RawValue: Codable {
	public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
		return (try? allCases(from: Array(RawValue.allCases), using: encoder)) ?? []
	}
}

extension Attribute: AnyWrappedJSONCaseIterable where RawValue: AnyJSONCaseIterable {
	public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
		return RawValue.allCases(using: encoder)
	}
}

// MARK: - TransformedAttribute
extension TransformedAttribute: OpenAPINodeType where RawValue: OpenAPINodeType {
	static public func openAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.openAPINode().required {
			return try RawValue.openAPINode().requiredNode().nullableNode()
		}
		return try RawValue.openAPINode()
	}
}

extension TransformedAttribute: RawOpenAPINodeType where RawValue: RawRepresentable, RawValue.RawValue: OpenAPINodeType {
	static public func rawOpenAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.RawValue.openAPINode().required {
			return try RawValue.RawValue.openAPINode().requiredNode().nullableNode()
		}
		return try RawValue.RawValue.openAPINode()
	}
}

extension TransformedAttribute: WrappedRawOpenAPIType where RawValue: RawOpenAPINodeType {
	public static func wrappedOpenAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.rawOpenAPINode().required {
			return try RawValue.rawOpenAPINode().requiredNode().nullableNode()
		}
		return try RawValue.rawOpenAPINode()
	}
}

extension TransformedAttribute: GenericOpenAPINodeType where RawValue: GenericOpenAPINodeType {
	public static func genericOpenAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.genericOpenAPINode(using: encoder).required {
			return try RawValue.genericOpenAPINode(using: encoder).requiredNode().nullableNode()
		}
		return try RawValue.genericOpenAPINode(using: encoder)
	}
}

extension TransformedAttribute: DateOpenAPINodeType where RawValue: DateOpenAPINodeType {
	public static func dateOpenAPINodeGuess(using encoder: JSONEncoder) -> JSONNode? {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if
			!(RawValue.dateOpenAPINodeGuess(using: encoder)?.required ?? true) {
			return RawValue.dateOpenAPINodeGuess(using: encoder)?.requiredNode().nullableNode()
		}
		return RawValue.dateOpenAPINodeGuess(using: encoder)
	}
}

extension TransformedAttribute: AnyJSONCaseIterable where RawValue: CaseIterable, RawValue: Codable {
	public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
		return (try? allCases(from: Array(RawValue.allCases), using: encoder)) ?? []
	}
}

extension TransformedAttribute: AnyWrappedJSONCaseIterable where RawValue: AnyJSONCaseIterable {
	public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
		return RawValue.allCases(using: encoder)
	}
}
