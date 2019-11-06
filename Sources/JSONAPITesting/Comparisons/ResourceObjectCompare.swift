//
//  ResourceObjectCompare.swift
//  
//
//  Created by Mathew Polzin on 11/3/19.
//

import JSONAPI

public struct ResourceObjectComparison: Equatable, PropertyComparable {
    public typealias ComparisonHash = [String: Comparison]

    public let id: Comparison
    public let attributes: ComparisonHash
    public let relationships: ComparisonHash
    public let meta: Comparison
    public let links: Comparison

    public init<T: ResourceObjectType>(_ one: T, _ two: T) {
        id = Comparison(one.id.rawValue, two.id.rawValue)
        attributes = one.attributes.compare(to: two.attributes)
        relationships = one.relationships.compare(to: two.relationships)
        meta = Comparison(one.meta, two.meta)
        links = Comparison(one.links, two.links)
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
            .mapValues { $0.rawValue }
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
