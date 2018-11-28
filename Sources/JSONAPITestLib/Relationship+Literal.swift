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

extension ToManyRelationship: ExpressibleByArrayLiteral {
	public typealias ArrayLiteralElement = Relatable.Identifier

	public init(arrayLiteral elements: ArrayLiteralElement...) {
		self.init(ids: elements)
	}
}
