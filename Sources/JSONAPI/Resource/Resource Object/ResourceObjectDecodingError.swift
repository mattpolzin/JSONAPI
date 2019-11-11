//
//  ResourceObjectDecodingError.swift
//  
//
//  Created by Mathew Polzin on 11/10/19.
//

public struct ResourceObjectDecodingError: Swift.Error, Equatable {
    public let subjectName: String
    public let cause: Cause
    public let location: Location

    static let entireObject = "entire object"

    public enum Cause: Equatable {
        case keyNotFound
        case valueNotFound
        case typeMismatch(expectedTypeName: String)
        case jsonTypeMismatch(expectedType: String, foundType: String)
        case quantityMismatch(expected: JSONAPICodingError.Quantity)
    }

    public enum Location: String, Equatable {
        case attributes
        case relationships

        var singular: String {
            switch self {
            case .attributes: return "attribute"
            case .relationships: return "relationship"
            }
        }
    }

    init?(_ decodingError: DecodingError) {
        switch decodingError {
        case .typeMismatch(let expectedType, let ctx):
            (location, subjectName) = Self.context(ctx)
            let typeString = String(describing: expectedType)
            cause = .typeMismatch(expectedTypeName: typeString)
        case .valueNotFound(_, let ctx):
            (location, subjectName) = Self.context(ctx)
            cause = .valueNotFound
        case .keyNotFound(let missingKey, let ctx):
            (location, _) = Self.context(ctx)
            subjectName = missingKey.stringValue
            cause = .keyNotFound
        default:
            return nil
        }
    }

    init?(_ jsonAPIError: JSONAPICodingError) {
        switch jsonAPIError {
        case .typeMismatch(expected: let expected, found: let found, path: let path):
            (location, subjectName) = Self.context(path: path)
            cause = .jsonTypeMismatch(expectedType: expected, foundType: found)
        case .quantityMismatch(expected: let expected, path: let path):
            (location, subjectName) = Self.context(path: path)
            cause = .quantityMismatch(expected: expected)
        default:
            return nil
        }
    }

    init(subjectName: String, cause: Cause, location: Location) {
        self.subjectName = subjectName
        self.cause = cause
        self.location = location
    }

    static func context(_ decodingContext: DecodingError.Context) -> (Location, name: String) {

        return context(path: decodingContext.codingPath)
    }

    static func context(path: [CodingKey]) -> (Location, name: String) {
        return (
            path.contains { $0.stringValue == "attributes" } ? .attributes : .relationships,
            name: path.last?.stringValue ?? "unnamed"
        )
    }
}

extension ResourceObjectDecodingError: CustomStringConvertible {
    public var description: String {
        switch cause {
        case .keyNotFound:
            if subjectName == ResourceObjectDecodingError.entireObject {
                return "\(location) object is required and missing."
            }
            return "'\(subjectName)' \(location.singular) is required and missing."
        case .valueNotFound:
            return "'\(subjectName)' \(location.singular) is not nullable but null."
        case .typeMismatch(expectedTypeName: let expected):
            return "'\(subjectName)' \(location.singular) is not a \(expected) as expected."
        case .jsonTypeMismatch(expectedType: let expected, foundType: let found):
            return "'\(subjectName)' \(location.singular) is of JSON:API type \"\(found)\" but it was expected to be \"\(expected)\""
        case .quantityMismatch(expected: let expected):
            let expecation: String = {
                switch expected {
                case .many:
                    return "\(expected) values"
                case .one:
                    return "\(expected) value"
                }
            }()
            return "'\(subjectName)' \(location.singular) should contain \(expecation) but found \(expected.other)"
        }
    }
}
