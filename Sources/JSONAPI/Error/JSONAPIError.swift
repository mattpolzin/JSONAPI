//
//  JSONAPIError.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

public protocol JSONAPIError: Swift.Error, Equatable, Codable {
    static var unknown: Self { get }
}

/// `UnknownJSONAPIError` can actually be used in any sitaution
/// where you don't know what errors are possible _or_ you just don't
/// care what errors might show up. If you don't know how the error
/// will be structured but you would like to have access to more
/// information the server might be providing in the error payload,
/// use `BasicJSONAPIError` instead.
public enum UnknownJSONAPIError: JSONAPIError {
    case unknownError

    public init(from decoder: Decoder) throws {
        self = .unknown
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode("unknown")
    }

    public static var unknown: Self {
        return .unknownError
    }
}
