//
//  ResourceObjectDecodingError.swift
//  
//
//  Created by Mathew Polzin on 11/10/19.
//

public struct ResourceObjectDecodingError: Swift.Error, Equatable {
    public let resourceObjectJsonAPIType: String
    public let subjectName: String
    public let cause: Cause
    public let location: Location

    static let entireObject = "entire object"

    public enum Cause: Equatable {
        case keyNotFound
        case valueNotFound
        case typeMismatch(expectedTypeName: String)
        case jsonTypeMismatch(foundType: String)
        case quantityMismatch(expected: JSONAPICodingError.Quantity)

        internal var isTypeMismatch: Bool {
            guard case .jsonTypeMismatch = self else { return false}
            return true
        }
    }

    public enum Location: String, Equatable {
        case attributes
        case relationships
        case relationshipType
        case relationshipId
        case type

        var singular: String {
            switch self {
            case .attributes: return "attribute"
            case .relationships: return "relationship"
            case .relationshipType: return "relationship type"
            case .relationshipId: return "relationship Id"
            case .type: return "type"
            }
        }
    }

    init?(_ decodingError: DecodingError, jsonAPIType: String) {
        self.resourceObjectJsonAPIType = jsonAPIType
        switch decodingError {
        case .typeMismatch(let expectedType, let ctx):
            (location, subjectName) = Self.context(ctx)
            let typeString = String(describing: expectedType)
            cause = .typeMismatch(expectedTypeName: typeString)
        case .valueNotFound(_, let ctx):
            (location, subjectName) = Self.context(ctx)
            cause = .valueNotFound
        case .keyNotFound(let missingKey, let ctx):
            let (location, name) = Self.context(ctx)
            let missingKeyString = missingKey.stringValue

            if location == .relationships && missingKeyString == "type" {
                self.location = .relationshipType
                subjectName = name
            } else if location == .relationships && missingKeyString == "id" {
                self.location = .relationshipId
                subjectName = name
            } else {
                self.location = location
                subjectName = missingKey.stringValue
            }
            cause = .keyNotFound
        default:
            return nil
        }
    }

    init?(_ jsonAPIError: JSONAPICodingError, jsonAPIType: String) {
        self.resourceObjectJsonAPIType = jsonAPIType
        switch jsonAPIError {
        case .typeMismatch(expected: _, found: let found, path: let path):
            (location, subjectName) = Self.context(path: path)
            cause = .jsonTypeMismatch(foundType: found)
        case .quantityMismatch(expected: let expected, path: let path):
            (location, subjectName) = Self.context(path: path)
            cause = .quantityMismatch(expected: expected)
        default:
            return nil
        }
    }

    init(expectedJSONAPIType: String, found: String) {
        resourceObjectJsonAPIType = expectedJSONAPIType
        location = .type
        subjectName = "self"
        cause = .jsonTypeMismatch(foundType: found)
    }

    init(subjectName: String, cause: Cause, location: Location, jsonAPIType: String) {
        self.resourceObjectJsonAPIType = jsonAPIType
        self.subjectName = subjectName
        self.cause = cause
        self.location = location
    }

    static func context(_ decodingContext: DecodingError.Context) -> (Location, name: String) {

        return context(path: decodingContext.codingPath)
    }

    static func context(path: [CodingKey]) -> (Location, name: String) {
        let location: Location
        if path.contains(where: { $0.stringValue == "attributes" }) {
            location = .attributes
        } else if path.contains(where: { $0.stringValue == "relationships" }) {
            location = .relationships
        } else {
            location = .type
        }

        return (
            location,
            name: path.last?.stringValue ?? "unnamed"
        )
    }
}

extension ResourceObjectDecodingError: CustomStringConvertible {
    public var description: String {
        switch cause {
        case .keyNotFound where subjectName == ResourceObjectDecodingError.entireObject:
            return "\(location) object is required and missing."
        case .keyNotFound where location == .type:
            return "'type' (a.k.a. JSON:API type name) is required and missing."
        case .keyNotFound where location == .relationshipType:
            return "'\(subjectName)' relationship does not have a 'type'."
        case .keyNotFound where location == .relationshipId:
            return "'\(subjectName)' relationship does not have an 'id'."
        case .keyNotFound:
            return "'\(subjectName)' \(location.singular) is required and missing."
        case .valueNotFound where location == .type:
            return "'\(location.singular)' (a.k.a. JSON:API type name) is not nullable but null was found."
        case .valueNotFound:
            return "'\(subjectName)' \(location.singular) is not nullable but null was found."
        case .typeMismatch(expectedTypeName: let expected) where location == .type:
            return "'\(location.singular)' (a.k.a. the JSON:API type name) is not a \(expected) as expected."
        case .typeMismatch(expectedTypeName: let expected):
            return "'\(subjectName)' \(location.singular) is not a \(expected) as expected."
        case .jsonTypeMismatch(foundType: let found) where location == .type:
            return "found JSON:API type \"\(found)\" but expected \"\(resourceObjectJsonAPIType)\""
        case .jsonTypeMismatch(foundType: let found):
            return "'\(subjectName)' \(location.singular) is of JSON:API type \"\(found)\" but it was expected to be \"\(resourceObjectJsonAPIType)\""
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
