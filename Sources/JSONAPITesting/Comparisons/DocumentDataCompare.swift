//
//  DocumentDataCompare.swift
//  
//
//  Created by Mathew Polzin on 11/5/19.
//

import JSONAPI

public struct DocumentDataComparison: Equatable, PropertyComparison {
    public let primary: PrimaryResourceBodyComparison
    public let includes: IncludesComparison
    public let meta: BasicComparison
    public let links: BasicComparison

    init(primary: PrimaryResourceBodyComparison, includes: IncludesComparison, meta: BasicComparison, links: BasicComparison) {
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

extension DocumentBodyData where PrimaryResourceBody: TestableResourceBody {
    public func compare(to other: Self) -> DocumentDataComparison {
        return .init(
            primary: primary.compare(to: other.primary),
            includes: includes.compare(to: other.includes),
            meta: BasicComparison(meta, other.meta),
            links: BasicComparison(links, other.links)
        )
    }
}

public enum PrimaryResourceBodyComparison: Equatable, CustomStringConvertible {
    case oneOrMore(ManyResourceObjectComparison)
    case optionalSingle(BasicComparison)

    public var isSame: Bool {
        switch self {
        case .optionalSingle(let comparison):
            return comparison == .same
        case .oneOrMore(let comparison):
            return comparison.isSame
        }
    }

    public var description: String {
        switch self {
        case .optionalSingle(let comparison):
            return comparison.rawValue
        case .oneOrMore(let comparison):
            return comparison.rawValue
        }
    }

    public var rawValue: String { return description }
}

public struct ManyResourceObjectComparison: Equatable, PropertyComparison {
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

extension TestableResourceBody {
    public func compare(to other: Self) -> PrimaryResourceBodyComparison {
        guard let one = testableResourceObject,
            let two = other.testableResourceObject else {

                func nilOrName<T>(_ resObj: [T]?) -> String {
                    resObj.map { _ in String(describing: T.self) } ?? "nil"
                }

                return .optionalSingle(BasicComparison(nilOrName(testableResourceObject), nilOrName(other.testableResourceObject)))
        }

        return .oneOrMore(.init(one.compare(to: two, using: { r1, r2 in
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

public protocol TestableResourceBody {
    associatedtype TestablePrimaryResourceType: ResourceObjectType
    var testableResourceObject: [TestablePrimaryResourceType]? { get }
}

public protocol OptionalResourceObjectType {
    associatedtype Wrapped: ResourceObjectType

    var maybeValue: Wrapped? { get }
}

extension Optional: OptionalResourceObjectType where Wrapped: ResourceObjectType {
    public var maybeValue: Wrapped? {
        switch self {
        case .none:
            return nil
        case .some(let value):
            return value
        }
    }
}

extension ResourceObject: OptionalResourceObjectType {
    public var maybeValue: Self? { self }
}

extension ManyResourceBody: TestableResourceBody where PrimaryResource: ResourceObjectType {
    public var testableResourceObject: [PrimaryResource]? { values }
}

extension SingleResourceBody: TestableResourceBody where PrimaryResource: OptionalResourceObjectType {
    public typealias TestablePrimaryResourceType = PrimaryResource.Wrapped

    public var testableResourceObject: [TestablePrimaryResourceType]? { value.maybeValue.map { [$0] } }
}
