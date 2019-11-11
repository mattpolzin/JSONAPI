//
//  JSONAPICodingError.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 12/7/18.
//

public enum JSONAPICodingError: Swift.Error {
    case typeMismatch(expected: String, found: String, path: [CodingKey])
    case quantityMismatch(expected: Quantity, path: [CodingKey])
    case illegalEncoding(String, path: [CodingKey])
    case illegalDecoding(String, path: [CodingKey])
    case missingOrMalformedMetadata(path: [CodingKey])
    case missingOrMalformedLinks(path: [CodingKey])

    public enum Quantity: String, Equatable {
        case one
        case many

        public var other: Quantity {
            switch self {
            case .one: return .many
            case .many: return .one
            }
        }
    }
}
