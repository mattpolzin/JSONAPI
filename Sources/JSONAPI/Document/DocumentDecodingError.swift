//
//  DocumentDecodingError.swift
//  
//
//  Created by Mathew Polzin on 10/20/19.
//
import Foundation

public enum DocumentDecodingError: Swift.Error, Equatable {
    case primaryResource(error: ResourceObjectDecodingError, idx: Int?)
    case primaryResourceMissing
    case primaryResourcesMissing

    case includes(error: IncludesDecodingError, idx: Int?)

    case foundErrorDocumentWhenExpectingSuccess
    case foundSuccessDocumentWhenExpectingError

    init(_ decodingError: ResourceObjectDecodingError) {
        self = .primaryResource(error: decodingError, idx: nil)
    }

    init(_ decodingError: ManyResourceBodyDecodingError) {
        self = .primaryResource(error: decodingError.error, idx: decodingError.idx)
    }

    init(_ decodingError: IncludesDecodingError) {
        self = .includes(error: decodingError, idx: decodingError.idx)
    }

    init?(_ decodingError: DecodingError) {
        switch decodingError {
        case .valueNotFound(let type, let context) where Location(context) == .data && type is AbstractResourceObject.Type:
            self = .primaryResourceMissing
        case .valueNotFound(let type, let context) where Location(context) == .data && type == UnkeyedDecodingContainer.self:
            self = .primaryResourcesMissing
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

extension DocumentDecodingError: LocalizedError, CustomStringConvertible {
    public var description: String {
        switch self {
        case .primaryResource(error: let error, idx: let idx):
            let idxString = idx.map { " \($0 + 1)" } ?? ""
            return "Primary Resource\(idxString) failed to parse because \(error)"
        case .primaryResourceMissing:
            return "Primary Resource missing."
        case .primaryResourcesMissing:
            return "Primary Resources array missing."
        case .includes(error: let error, let idx):
            if let index = idx,
               let documentError = error.error as? IncludeDecodingError,
               documentError.failures.indices.contains(index-1) {
                let failure = documentError.failures[index-1]
                return "Include Resource\(index) failed to parse because of \(failure)"
            }
            return "\(error)"
        case .foundErrorDocumentWhenExpectingSuccess:
            return "Expected a success document with a 'data' property but found an error document."
        case .foundSuccessDocumentWhenExpectingError:
            return "Expected an error document but found a success document with a 'data' property."
        }
    }
    //No localization support. But matches the error description
    public var errorDescription: String? {
       return description
    }
}
