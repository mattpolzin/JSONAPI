//
//  ResourceObjectCompare.swift
//  
//
//  Created by Mathew Polzin on 11/3/19.
//

import JSONAPI

public struct ResourceObjectComparison: Equatable, PropertyComparison {
    public typealias ComparisonHash = [String: BasicComparison]

    public let id: BasicComparison
    public let attributes: ComparisonHash
    public let relationships: ComparisonHash
    public let meta: BasicComparison
    public let links: BasicComparison

    public init<T: ResourceObjectType>(_ one: T, _ two: T) {
        id = BasicComparison(one.id.rawValue, two.id.rawValue)
        attributes = one.attributes.compare(to: two.attributes)
        relationships = one.relationships.compare(to: two.relationships)
        meta = BasicComparison(one.meta, two.meta)
        links = BasicComparison(one.links, two.links)
    }

    public var differences: NamedDifferences {
        return attributes.reduce(into: ComparisonHash()) { hash, next in
            hash["'\(next.key)' attribute"] = next.value
        }
            .merging(
                relationships.reduce(into: ComparisonHash()) { hash, next in
                    hash["'\(next.key)' relationship"] = next.value
                },
                uniquingKeysWith: { $1 }
        )
            .merging(
                [
                    "id": id,
                    "meta": meta,
                    "links": links
                ],
                uniquingKeysWith: { $1 }
        )
            .filter { $1 != .same }
            .mapValues(\.rawValue)
    }
}

extension ResourceObjectType {
    public func compare(to other: Self) -> ResourceObjectComparison {
        return ResourceObjectComparison(self, other)
    }
}

protocol AbstractResourceObjectType {
    func abstractCompare(to other: Any) throws -> ResourceObjectComparison
}

enum AbstractCompareError: Swift.Error {
    case typeMismatch
}

extension ResourceObject: AbstractResourceObjectType {
    func abstractCompare(to other: Any) throws -> ResourceObjectComparison {
        guard let otherResource = other as? Self else {
            throw AbstractCompareError.typeMismatch
        }
        return self.compare(to: otherResource)
    }
}
