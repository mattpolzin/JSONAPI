//
//  GenericJSONAPIError.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 9/29/19.
//

/// `GenericJSONAPIError` can be used to specify whatever error
/// payload you expect to need to parse in responses and handle any
/// other payload structure as `.unknownError`.
public enum GenericJSONAPIError<ErrorPayload: Codable & Equatable>: JSONAPIError, CustomStringConvertible {
    case unknownError
    case error(ErrorPayload)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        do {
            self = .error(try container.decode(ErrorPayload.self))
        } catch {
            self = .unknown
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .error(let payload):
            try container.encode(payload)
        case .unknownError:
            try container.encode("unknown")
        }
    }

    public static var unknown: Self {
        return .unknownError
    }

    public var description: String {
        switch self {
        case .unknownError:
            return "unknown error"
        case .error(let payload):
            return String(describing: payload)
        }
    }
}

public extension GenericJSONAPIError {
    var payload: ErrorPayload? {
        switch self {
        case .unknownError:
            return nil
        case .error(let payload):
            return payload
        }
    }
}

public protocol ErrorDictType {
    var definedFields: [String: String] { get }
}

extension GenericJSONAPIError: ErrorDictType where ErrorPayload: ErrorDictType {
    /// Get a dictionary of all defined fields and their values.
    public var definedFields: [String: String] {
        switch self {
        case .unknownError:
            return [:]
        case .error(let basicPayload):
            return basicPayload.definedFields
        }
    }
}
