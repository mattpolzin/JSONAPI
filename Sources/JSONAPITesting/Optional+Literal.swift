//
//  Optional+Literal.swift
//  JSONAPITestLib
//
//  Created by Mathew Polzin on 11/29/18.
//

extension Optional: ExpressibleByUnicodeScalarLiteral where Wrapped: ExpressibleByUnicodeScalarLiteral {
	public typealias UnicodeScalarLiteralType =  Wrapped.UnicodeScalarLiteralType

	public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
		self = .some(Wrapped(unicodeScalarLiteral: value))
	}
}

extension Optional: ExpressibleByExtendedGraphemeClusterLiteral where Wrapped: ExpressibleByExtendedGraphemeClusterLiteral {
	public typealias ExtendedGraphemeClusterLiteralType =  Wrapped.ExtendedGraphemeClusterLiteralType

	public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
		self = .some(Wrapped(extendedGraphemeClusterLiteral: value))
	}
}

extension Optional: ExpressibleByStringLiteral where Wrapped: ExpressibleByStringLiteral {
	public typealias StringLiteralType = Wrapped.StringLiteralType

	public init(stringLiteral value: StringLiteralType) {
		self = .some(Wrapped(stringLiteral: value))
	}
}
