//
//  DocumentCompare.swift
//  JSONAPITesting
//
//  Created by Mathew Polzin on 11/4/19.
//

import JSONAPI

public struct DocumentComparison: Equatable, PropertyComparison {
    public let apiDescription: BasicComparison
    public let body: BodyComparison

    init(apiDescription: BasicComparison, body: BodyComparison) {
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

    public typealias ErrorComparison = [String: BasicComparison]

    static func compare<E: JSONAPIError, M: JSONAPI.Meta, L: JSONAPI.Links>(errors errors1: [E], _ meta1: M?, _ links1: L?, with errors2: [E], _ meta2: M?, _ links2: L?) -> ErrorComparison {
        let errorComparisons = errors1.compare(
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
        ).map(BasicComparison.init)
            .filter { !$0.isSame }
            .map(\.rawValue)
            .joined(separator: ", ")

        let errorComparisonString = errorComparisons.isEmpty
            ? nil
            : errorComparisons

        return [
            "Errors": errorComparisonString.map { BasicComparison.prebuilt("(\($0))") } ?? .same,
            "Metadata": BasicComparison(meta1, meta2),
            "Links": BasicComparison(links1, links2)
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
                .filter { !$0.value.isSame }
                .map { "\($0.key): \($0.value.rawValue)" }
                .sorted()
                .joined(separator: ", ")
        case .differentData(let comparison):
            return comparison.rawValue
        }
    }

    public var rawValue: String { description }
}

extension EncodableJSONAPIDocument where Body: Equatable, PrimaryResourceBody: TestableResourceBody {
    public func compare(to other: Self) -> DocumentComparison {
        return DocumentComparison(
            apiDescription: BasicComparison(
                String(describing: apiDescription),
                String(describing: other.apiDescription)
            ),
            body: body.compare(to: other.body)
        )
    }
}

extension DocumentBody where Self: Equatable, PrimaryResourceBody: TestableResourceBody {
    public func compare(to other: Self) -> BodyComparison {

        // rule out case where they are the same
        guard self != other else {
            return .same
        }

        // rule out case where they are both error bodies
        if let errors1 = errors, let errors2 = other.errors {
            return .differentErrors(
                BodyComparison.compare(
                    errors: errors1, meta, links,
                    with: errors2, other.meta, other.links
                )
            )
        }

        // rule out the case where they are both data
        if let data1 = data, let data2 = other.data {
            return .differentData(data1.compare(to: data2))
        }

        // we are left with the case where one is data and the
        // other is an error if self.isError, then "the error
        // is on the left"
        return .dataErrorMismatch(errorOnLeft: isError)
    }
}
