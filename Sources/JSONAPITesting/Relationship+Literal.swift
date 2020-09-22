//
//  Relationship+Literal.swift
//  JSONAPITesting
//
//  Created by Mathew Polzin on 11/27/18.
//

import JSONAPI

extension ToOneRelationship: ExpressibleByNilLiteral where Identifiable.ID: ExpressibleByNilLiteral, IdMetaType == NoIdMetadata, MetaType == NoMetadata, LinksType == NoLinks {
    public init(nilLiteral: ()) {

        self.init(id: Identifiable.ID(nilLiteral: ()))
    }
}

extension ToOneRelationship: ExpressibleByUnicodeScalarLiteral where Identifiable.ID: ExpressibleByUnicodeScalarLiteral, IdMetaType == NoIdMetadata, MetaType == NoMetadata, LinksType == NoLinks {
    public typealias UnicodeScalarLiteralType =  Identifiable.ID.UnicodeScalarLiteralType

    public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        self.init(id: Identifiable.ID(unicodeScalarLiteral: value))
    }
}

extension ToOneRelationship: ExpressibleByExtendedGraphemeClusterLiteral where Identifiable.ID: ExpressibleByExtendedGraphemeClusterLiteral, IdMetaType == NoIdMetadata, MetaType == NoMetadata, LinksType == NoLinks {
    public typealias ExtendedGraphemeClusterLiteralType =  Identifiable.ID.ExtendedGraphemeClusterLiteralType

    public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        self.init(id: Identifiable.ID(extendedGraphemeClusterLiteral: value))
    }
}

extension ToOneRelationship: ExpressibleByStringLiteral where Identifiable.ID: ExpressibleByStringLiteral, IdMetaType == NoIdMetadata, MetaType == NoMetadata, LinksType == NoLinks {
    public typealias StringLiteralType = Identifiable.ID.StringLiteralType

    public init(stringLiteral value: StringLiteralType) {
        self.init(id: Identifiable.ID(stringLiteral: value))
    }
}

extension ToManyRelationship: ExpressibleByArrayLiteral where IdMetaType == NoIdMetadata, MetaType == NoMetadata, LinksType == NoLinks {
    public typealias ArrayLiteralElement = Relatable.ID

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(ids: elements)
    }
}
