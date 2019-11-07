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

extension DocumentBodyData where PrimaryResourceBody: _ResourceBody {
    public func compare(to other: Self) -> DocumentDataComparison {
        return .init(
            primary: primary.compare(to: other.primary),
            includes: includes.compare(to: other.includes),
            meta: Comparison(meta, other.meta),
            links: Comparison(links, other.links)
        )
    }
}

extension DocumentBodyData where PrimaryResourceBody: _OptionalResourceBody {
    public func compare(to other: Self) -> DocumentDataComparison {
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

extension _OptionalResourceBody where WrappedPrimaryResourceType: ResourceObjectType {
    public func compare(to other: Self) -> PrimaryResourceBodyComparison {
        guard let one = optionalResourceObject,
            let two = other.optionalResourceObject else {

                func nilOrName<T>(_ resObj: T?) -> String {
                    resObj.map { String(describing: type(of: $0)) } ?? "nil"
                }

                return .other(Comparison(nilOrName(optionalResourceObject), nilOrName(other.optionalResourceObject)))
        }
        return .single(.init(one, two))
    }
}

extension _ResourceBody where PrimaryResourceType: ResourceObjectType {
    public func compare(to other: Self) -> PrimaryResourceBodyComparison {
        return .many(.init(resourceObjects.compare(to: other.resourceObjects, using: { r1, r2 in
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

public protocol _ResourceBody {
    associatedtype PrimaryResourceType: ResourceObjectType
    var resourceObjects: [PrimaryResourceType] { get }
}

public protocol _OptionalResourceBody {
    associatedtype WrappedPrimaryResourceType: ResourceObjectType
    var optionalResourceObject: WrappedPrimaryResourceType? { get }
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

extension ManyResourceBody: _ResourceBody where PrimaryResource: ResourceObjectType {
    public var resourceObjects: [PrimaryResource] { values }
}

extension SingleResourceBody: _ResourceBody where PrimaryResource: ResourceObjectType {
    public typealias PrimaryResourceType = PrimaryResource
    public var resourceObjects: [PrimaryResource] { [value] }
}

extension SingleResourceBody: _OptionalResourceBody where PrimaryResource: _OptionalResourceObjectType {
    public typealias WrappedPrimaryResourceType = PrimaryResource.Wrapped

    public var optionalResourceObject: WrappedPrimaryResourceType? { value.maybeValue }
}
