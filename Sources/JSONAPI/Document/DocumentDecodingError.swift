//
//  DocumentDecodingError.swift
//  
//
//  Created by Mathew Polzin on 10/20/19.
//

public enum DocumentDecodingError: Swift.Error, Equatable {
    case primaryResource(error: ResourceObjectDecodingError, idx: Int?)
    case primaryResourceMissing
    case primaryResourcesMissing

    case includes(error: IncludesDecodingError)

    case foundErrorDocumentWhenExpectingSuccess
    case foundSuccessDocumentWhenExpectingError

    init(_ decodingError: ResourceObjectDecodingError) {
        self = .primaryResource(error: decodingError, idx: nil)
    }

    init(_ decodingError: ManyResourceBodyDecodingError) {
        self = .primaryResource(error: decodingError.error, idx: decodingError.idx)
    }

    init(_ decodingError: IncludesDecodingError) {
        self = .includes(error: decodingError)
    }

    init?(_ decodingError: DecodingError) {
        switch decodingError {
        case .valueNotFound(let type, let context) where Location(context) == .data && type is AbstractResourceObject.Type:
            self = .primaryResourceMissing
        case .valueNotFound(let type, let context) where Location(context) == .data && type == UnkeyedDecodingContainer.self:
            self = .primaryResourcesMissing
        case .valueNotFound(let type, let context) where Location(context) == .data && type is _ArrayType.Type && context.debugDescription.hasSuffix("found null value instead"):
            self = .primaryResourcesMissing
        case .valueNotFound(_, let context) where Location(context) == .data && context.debugDescription.hasSuffix("found null value instead"):
            self = .primaryResourceMissing
        case .typeMismatch(let type, let context) where Location(context) == .data && type is _ArrayType.Type && context.debugDescription.hasSuffix("but found null instead."):
            self = .primaryResourcesMissing
        case .typeMismatch(_, let context) where Location(context) == .data && context.debugDescription.hasSuffix("but found null instead."):
            self = .primaryResourceMissing
        default:
            return nil
        }
    }

    private enum Location: Equatable {
        case data

        init?(_ context: DecodingError.Context) {
            guard context.codingPath.contains(where: { $0.stringValue == "data" }) else {
                return nil
            }
            self = .data
        }
    }
}

extension DocumentDecodingError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .primaryResource(error: let error, idx: let idx):
            let idxString = idx.map { " \($0 + 1)" } ?? ""
            return "Primary Resource\(idxString) failed to parse because \(error)"
        case .primaryResourceMissing:
            return "Primary Resource missing."
        case .primaryResourcesMissing:
            return "Primary Resources array missing."

        case .includes(error: let error):
            return "\(error)"

        case .foundErrorDocumentWhenExpectingSuccess:
            return "Expected a success document with a 'data' property but found an error document."
        case .foundSuccessDocumentWhenExpectingError:
            return "Expected an error document but found a success document with a 'data' property."
        }
    }
}

private protocol _ArrayType {}
extension Array: _ArrayType {}
