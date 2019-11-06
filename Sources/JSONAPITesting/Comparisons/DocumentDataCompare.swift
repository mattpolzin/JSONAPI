//
//  DocumentDataCompare.swift
//  
//
//  Created by Mathew Polzin on 11/5/19.
//

import JSONAPI

public struct DocumentDataComparison: Equatable, PropertyComparable {
    public let primary: PrimaryResourceBodyComparison
    public let includes: IncludesComparison
    public let meta: Comparison
    public let links: Comparison

    init(primary: PrimaryResourceBodyComparison, includes: IncludesComparison, meta: Comparison, links: Comparison) {
        self.primary = primary
        self.includes = includes
        self.meta = meta
        self.links = links
    }

    public var differences: NamedDifferences {
        return Dictionary(
            [
                !primary.isSame ? ("Primary Resource", primary.rawValue) : nil,
                !includes.isSame ? ("Includes", includes.rawValue) : nil,
                !meta.isSame ? ("Meta", meta.rawValue) : nil,
                !links.isSame ? ("Links", links.rawValue) : nil
            ].compactMap { $0 },
            uniquingKeysWith: { $1 }
        )
    }
}

extension DocumentBodyData {
    public func compare<T>(to other: Self) -> DocumentDataComparison where T: ResourceObjectType, PrimaryResourceBody == SingleResourceBody<T> {
        return .init(
            primary: primary.compare(to: other.primary),
            includes: includes.compare(to: other.includes),
            meta: Comparison(meta, other.meta),
            links: Comparison(links, other.links)
        )
    }

    public func compare<T>(to other: Self) -> DocumentDataComparison where T: ResourceObjectType, PrimaryResourceBody == SingleResourceBody<T?> {
        return .init(
            primary: primary.compare(to: other.primary),
            includes: includes.compare(to: other.includes),
            meta: Comparison(meta, other.meta),
            links: Comparison(links, other.links)
        )
    }

    public func compare<T>(to other: Self) -> DocumentDataComparison where T: ResourceObjectType, PrimaryResourceBody == ManyResourceBody<T> {
        return .init(
            primary: primary.compare(to: other.primary),
            includes: includes.compare(to: other.includes),
            meta: Comparison(meta, other.meta),
            links: Comparison(links, other.links)
        )
    }
}

public enum PrimaryResourceBodyComparison: Equatable, CustomStringConvertible {
    case single(ResourceObjectComparison)
    case many(ManyResourceObjectComparison)
    case other(Comparison)

    public var isSame: Bool {
        switch self {
        case .other(let comparison):
            return comparison == .same
        case .single(let comparison):
            return comparison.isSame
        case .many(let comparison):
            return comparison.isSame
        }
    }

    public var description: String {
        switch self {
        case .other(let comparison):
            return comparison.rawValue
        case .single(let comparison):
            return comparison.rawValue
        case .many(let comparison):
            return comparison.rawValue
        }
    }

    public var rawValue: String { return description }
}

public struct ManyResourceObjectComparison: Equatable, PropertyComparable {
    public let comparisons: [ArrayElementComparison]

    public init(_ comparisons: [ArrayElementComparison]) {
        self.comparisons = comparisons
    }

    public var differences: NamedDifferences {
        return comparisons
            .enumerated()
            .filter { $0.element != .same }
            .reduce(into: [String: String]()) { hash, next in
                hash["resource \(next.offset + 1)"] = next.element.rawValue
        }
    }
}

extension SingleResourceBody where Entity: ResourceObjectType {
    public func compare(to other: Self) -> PrimaryResourceBodyComparison {
        return .single(.init(value, other.value))
    }
}

public protocol _OptionalResourceObjectType {
    associatedtype Wrapped: ResourceObjectType

    var maybeValue: Wrapped? { get }
}

extension Optional: _OptionalResourceObjectType where Wrapped: ResourceObjectType {
    public var maybeValue: Wrapped? {
        switch self {
        case .none:
            return nil
        case .some(let value):
            return value
        }
    }
}

extension SingleResourceBody where Entity: _OptionalResourceObjectType {
    public func compare(to other: Self) -> PrimaryResourceBodyComparison {
        guard let one = value.maybeValue,
            let two = other.value.maybeValue else {
                return .other(Comparison(value, other.value))
        }
        return .single(.init(one, two))
    }
}

extension ManyResourceBody where Entity: ResourceObjectType {
    public func compare(to other: Self) -> PrimaryResourceBodyComparison {
        return .many(.init(values.compare(to: other.values, using: { r1, r2 in
            let r1AsResource = r1 as? AbstractResourceObjectType

            let maybeComparison = r1AsResource
                .flatMap { resource in
                    try? ArrayElementComparison(
                        resourceObjectComparison: resource.abstractCompare(to: r2)
                    )
            }

            guard let comparison = maybeComparison else {
                return .differentValues(
                    String(describing: r1),
                    String(describing: r2)
                )
            }

            return comparison
        })))
    }
}
