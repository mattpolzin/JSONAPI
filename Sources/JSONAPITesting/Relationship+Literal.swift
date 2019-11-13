//
//  Relationship+Literal.swift
//  JSONAPITesting
//
//  Created by Mathew Polzin on 11/27/18.
//

import JSONAPI

extension ToOneRelationship: ExpressibleByNilLiteral where Identifiable.Identifier: ExpressibleByNilLiteral, MetaType == NoMetadata, LinksType == NoLinks {
    public init(nilLiteral: ()) {

        self.init(id: Identifiable.Identifier(nilLiteral: ()))
    }
}

extension ToOneRelationship: ExpressibleByUnicodeScalarLiteral where Identifiable.Identifier: ExpressibleByUnicodeScalarLiteral, MetaType == NoMetadata, LinksType == NoLinks {
    public typealias UnicodeScalarLiteralType =  Identifiable.Identifier.UnicodeScalarLiteralType

    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(id: Identifiable.Identifier(unicodeScalarLiteral: value))
    }
}

extension ToOneRelationship: ExpressibleByExtendedGraphemeClusterLiteral where Identifiable.Identifier: ExpressibleByExtendedGraphemeClusterLiteral, MetaType == NoMetadata, LinksType == NoLinks {
    public typealias ExtendedGraphemeClusterLiteralType =  Identifiable.Identifier.ExtendedGraphemeClusterLiteralType

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(id: Identifiable.Identifier(extendedGraphemeClusterLiteral: value))
    }
}

extension ToOneRelationship: ExpressibleByStringLiteral where Identifiable.Identifier: ExpressibleByStringLiteral, MetaType == NoMetadata, LinksType == NoLinks {
    public typealias StringLiteralType = Identifiable.Identifier.StringLiteralType

    public init(stringLiteral value: StringLiteralType) {
        self.init(id: Identifiable.Identifier(stringLiteral: value))
    }
}

extension ToManyRelationship: ExpressibleByArrayLiteral where MetaType == NoMetadata, LinksType == NoLinks {
    public typealias ArrayLiteralElement = Relatable.Identifier

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(ids: elements)
    }
}
