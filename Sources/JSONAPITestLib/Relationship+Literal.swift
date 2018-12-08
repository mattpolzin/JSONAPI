//
//  Relationship+Literal.swift
//  JSONAPITestLib
//
//  Created by Mathew Polzin on 11/27/18.
//

import JSONAPI

extension ToOneRelationship: ExpressibleByNilLiteral where OptionalRelatable.WrappedId: ExpressibleByNilLiteral, MetaType == NoMetadata, LinksType == NoLinks {
	public init(nilLiteral: ()) {

		self.init(id: OptionalRelatable.WrappedId(nilLiteral: ()))
	}
}

extension ToOneRelationship: ExpressibleByUnicodeScalarLiteral where OptionalRelatable.WrappedId: ExpressibleByUnicodeScalarLiteral, MetaType == NoMetadata, LinksType == NoLinks {
	public typealias UnicodeScalarLiteralType =  OptionalRelatable.WrappedId.UnicodeScalarLiteralType

	public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
		self.init(id: OptionalRelatable.WrappedId(unicodeScalarLiteral: value))
	}
}

extension ToOneRelationship: ExpressibleByExtendedGraphemeClusterLiteral where OptionalRelatable.WrappedId: ExpressibleByExtendedGraphemeClusterLiteral, MetaType == NoMetadata, LinksType == NoLinks {
	public typealias ExtendedGraphemeClusterLiteralType =  OptionalRelatable.WrappedId.ExtendedGraphemeClusterLiteralType

	public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
		self.init(id: OptionalRelatable.WrappedId(extendedGraphemeClusterLiteral: value))
	}
}

extension ToOneRelationship: ExpressibleByStringLiteral where OptionalRelatable.WrappedId: ExpressibleByStringLiteral, MetaType == NoMetadata, LinksType == NoLinks {
	public typealias StringLiteralType = OptionalRelatable.WrappedId.StringLiteralType

	public init(stringLiteral value: StringLiteralType) {
		self.init(id: OptionalRelatable.WrappedId(stringLiteral: value))
	}
}

extension ToManyRelationship: ExpressibleByArrayLiteral where MetaType == NoMetadata, LinksType == NoLinks {
	public typealias ArrayLiteralElement = Relatable.Identifier

	public init(arrayLiteral elements: ArrayLiteralElement...) {
		self.init(ids: elements)
	}
}
