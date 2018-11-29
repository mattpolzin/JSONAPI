//
//  Relationship+Literal.swift
//  JSONAPITestLib
//
//  Created by Mathew Polzin on 11/27/18.
//

import JSONAPI

extension ToOneRelationship: ExpressibleByNilLiteral where Relatable.WrappedIdentifier: ExpressibleByNilLiteral {
	public init(nilLiteral: ()) {

		self.init(id: Relatable.WrappedIdentifier(nilLiteral: ()))
	}
}

extension ToOneRelationship: ExpressibleByUnicodeScalarLiteral where Relatable.WrappedIdentifier: ExpressibleByUnicodeScalarLiteral {
	public typealias UnicodeScalarLiteralType =  Relatable.WrappedIdentifier.UnicodeScalarLiteralType

	public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
		self.init(id: Relatable.WrappedIdentifier(unicodeScalarLiteral: value))
	}
}

extension ToOneRelationship: ExpressibleByExtendedGraphemeClusterLiteral where Relatable.WrappedIdentifier: ExpressibleByExtendedGraphemeClusterLiteral {
	public typealias ExtendedGraphemeClusterLiteralType =  Relatable.WrappedIdentifier.ExtendedGraphemeClusterLiteralType

	public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
		self.init(id: Relatable.WrappedIdentifier(extendedGraphemeClusterLiteral: value))
	}
}

extension ToOneRelationship: ExpressibleByStringLiteral where Relatable.WrappedIdentifier: ExpressibleByStringLiteral {
	public typealias StringLiteralType = Relatable.WrappedIdentifier.StringLiteralType

	public init(stringLiteral value: StringLiteralType) {
		self.init(id: Relatable.WrappedIdentifier(stringLiteral: value))
	}
}

extension ToManyRelationship: ExpressibleByArrayLiteral {
	public typealias ArrayLiteralElement = Relatable.Identifier

	public init(arrayLiteral elements: ArrayLiteralElement...) {
		self.init(ids: elements)
	}
}
