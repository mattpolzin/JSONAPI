//
//  Id+Literal.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/27/18.
//

import JSONAPI

extension Id: ExpressibleByUnicodeScalarLiteral where RawType: ExpressibleByUnicodeScalarLiteral {
    public typealias UnicodeScalarLiteralType = RawType.UnicodeScalarLiteralType
    
    public init(unicodeScalarLiteral value: RawType.UnicodeScalarLiteralType) {
        self.init(rawValue: RawType(unicodeScalarLiteral: value))
    }
}

extension Id: ExpressibleByExtendedGraphemeClusterLiteral where RawType: ExpressibleByExtendedGraphemeClusterLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = RawType.ExtendedGraphemeClusterLiteralType
    
    public init(extendedGraphemeClusterLiteral value: RawType.ExtendedGraphemeClusterLiteralType) {
        self.init(rawValue: RawType(extendedGraphemeClusterLiteral: value))
    }
}

extension Id: ExpressibleByStringLiteral where RawType: ExpressibleByStringLiteral {
    public typealias StringLiteralType = RawType.StringLiteralType
    
    public init(stringLiteral value: RawType.StringLiteralType) {
        self.init(rawValue: RawType(stringLiteral: value))
    }
}

extension Id: ExpressibleByIntegerLiteral where RawType: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = RawType.IntegerLiteralType
    
    public init(integerLiteral value: IntegerLiteralType) {
        self.init(rawValue: RawType(integerLiteral: value))
    }
}
