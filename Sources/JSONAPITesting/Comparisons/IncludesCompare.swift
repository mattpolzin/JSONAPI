//
//  IncludesCompare.swift
//  
//
//  Created by Mathew Polzin on 11/4/19.
//

import JSONAPI
import Poly

public struct IncludesComparison: Equatable, PropertyComparable {
    public let comparisons: [ArrayElementComparison]

    public init(_ comparisons: [ArrayElementComparison]) {
        self.comparisons = comparisons
    }

    public var differences: NamedDifferences {
        return comparisons
            .enumerated()
            .filter { $0.element != .same }
            .reduce(into: [String: String]()) { hash, next in
                hash["include \(next.offset + 1)"] = next.element.rawValue
        }
    }
}

extension Includes {
    public func compare(to other: Self) -> IncludesComparison {

        return IncludesComparison(
            values.compare(to: other.values) { thisInclude, otherInclude in
                guard thisInclude != otherInclude else {
                    return .same
                }

                let thisWrappedValue = thisInclude.value
                let otherWrappedValue = otherInclude.value
                guard type(of: thisWrappedValue) == type(of: otherWrappedValue) else {
                    return .differentTypes(
                        String(describing: type(of: thisWrappedValue)),
                        String(describing: type(of: otherWrappedValue))
                    )
                }

                let thisAsAResource = thisWrappedValue as? AbstractResourceObjectType

                let maybeComparison = thisAsAResource
                    .flatMap { resource in
                        try? ArrayElementComparison(
                            resourceObjectComparison: resource.abstractCompare(to: otherWrappedValue)
                        )
                }

                guard let comparison = maybeComparison else {
                    return .differentValues(
                        String(describing: thisWrappedValue),
                        String(describing: otherWrappedValue)
                    )
                }

                return comparison
            }
        )
    }
}
