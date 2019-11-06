//
//  DocumentCompare.swift
//  JSONAPITesting
//
//  Created by Mathew Polzin on 11/4/19.
//

import JSONAPI

public struct DocumentComparison: Equatable, PropertyComparable {
    public let apiDescription: Comparison
    public let body: BodyComparison

    init(apiDescription: Comparison, body: BodyComparison) {
        self.apiDescription = apiDescription
        self.body = body
    }

    public var differences: NamedDifferences {
        return Dictionary(
            [
                apiDescription != .same ? ("API Description", apiDescription.rawValue) : nil,
                body != .same ? ("Body", body.rawValue) : nil
            ].compactMap { $0 },
            uniquingKeysWith: { $1 }
        )
    }
}

public enum BodyComparison: Equatable, CustomStringConvertible {
    case same
    case dataErrorMismatch(errorOnLeft: Bool)
    case differentErrors(ErrorComparison)
    case differentData(DocumentDataComparison)

    public typealias ErrorComparison = [Comparison]

    static func compare<E: JSONAPIError, M: JSONAPI.Meta, L: JSONAPI.Links>(errors errors1: [E], _ meta1: M?, _ links1: L?, with errors2: [E], _ meta2: M?, _ links2: L?) -> ErrorComparison {
        return errors1.compare(
            to: errors2,
            using: { error1, error2 in
                guard error1 != error2 else {
                    return .same
                }

                return .differentValues(
                    String(describing: error1),
                    String(describing: error2)
                )
            }
        ).map(Comparison.init) + [
            Comparison(meta1, meta2),
            Comparison(links1, links2)
        ]
    }

    public var description: String {
        switch self {
        case .same:
            return "same"
        case .dataErrorMismatch(errorOnLeft: let errorOnLeft):
            let errorString = "error response"
            let dataString = "data response"
            let left = errorOnLeft ? errorString : dataString
            let right = errorOnLeft ? dataString : errorString

            return "\(left) ≠ \(right)"
        case .differentErrors(let comparisons):
            return comparisons
                .filter { !$0.isSame }
                .map { $0.rawValue }
                .sorted()
                .joined(separator: ", ")
        case .differentData(let comparison):
            return comparison.rawValue
        }
    }

    public var rawValue: String { description }
}

extension Document {
    public func compare<T>(to other: Self) -> DocumentComparison where PrimaryResourceBody == SingleResourceBody<T>, T: ResourceObjectType {
        return DocumentComparison(
            apiDescription: Comparison(
                String(describing: apiDescription),
                String(describing: other.apiDescription)
            ),
            body: body.compare(to: other.body)
        )
    }

    public func compare<T>(to other: Self) -> DocumentComparison where PrimaryResourceBody == SingleResourceBody<T?>, T: ResourceObjectType {
        return DocumentComparison(
            apiDescription: Comparison(
                String(describing: apiDescription),
                String(describing: other.apiDescription)
            ),
            body: body.compare(to: other.body)
        )
    }

    public func compare<T>(to other: Self) -> DocumentComparison where PrimaryResourceBody == ManyResourceBody<T>, T: ResourceObjectType {
        return DocumentComparison(
            apiDescription: Comparison(
                String(describing: apiDescription),
                String(describing: other.apiDescription)
            ),
            body: body.compare(to: other.body)
        )
    }
}

extension Document.Body {
    public func compare<T>(to other: Self) -> BodyComparison where T: ResourceObjectType, PrimaryResourceBody == SingleResourceBody<T> {
        guard self != other else {
            return .same
        }

        switch (self, other) {
        case (.errors(let errors1), .errors(let errors2)):
            return .differentErrors(BodyComparison.compare(errors: errors1.0,
                                                           errors1.meta,
                                                           errors1.links,
                                                           with: errors2.0,
                                                           errors2.meta,
                                                           errors2.links))
        case (.errors, .data):
            return .dataErrorMismatch(errorOnLeft: true)
        case (.data, .errors):
            return .dataErrorMismatch(errorOnLeft: false)
        case (.data(let data1), .data(let data2)):
            return .differentData(data1.compare(to: data2))
        }
    }

    public func compare<T>(to other: Self) -> BodyComparison where T: ResourceObjectType, PrimaryResourceBody == SingleResourceBody<T?> {
        guard self != other else {
            return .same
        }

        switch (self, other) {
        case (.errors(let errors1), .errors(let errors2)):
            return .differentErrors(BodyComparison.compare(errors: errors1.0,
                                                           errors1.meta,
                                                           errors1.links,
                                                           with: errors2.0,
                                                           errors2.meta,
                                                           errors2.links))
        case (.errors, .data):
            return .dataErrorMismatch(errorOnLeft: true)
        case (.data, .errors):
            return .dataErrorMismatch(errorOnLeft: false)
        case (.data(let data1), .data(let data2)):
            return .differentData(data1.compare(to: data2))
        }
    }

    public func compare<T>(to other: Self) -> BodyComparison where T: ResourceObjectType, PrimaryResourceBody == ManyResourceBody<T> {
        guard self != other else {
            return .same
        }

        switch (self, other) {
        case (.errors(let errors1), .errors(let errors2)):
            return .differentErrors(BodyComparison.compare(errors: errors1.0,
                                                           errors1.meta,
                                                           errors1.links,
                                                           with: errors2.0,
                                                           errors2.meta,
                                                           errors2.links))
        case (.errors, .data):
            return .dataErrorMismatch(errorOnLeft: true)
        case (.data, .errors):
            return .dataErrorMismatch(errorOnLeft: false)
        case (.data(let data1), .data(let data2)):
            return .differentData(data1.compare(to: data2))
        }
    }
}
