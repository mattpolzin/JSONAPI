//
//  RelationshipsCompare.swift
//  
//
//  Created by Mathew Polzin on 11/3/19.
//

import JSONAPI

extension Relationships {
    public func compare(to other: Self) -> [String: BasicComparison] {
        let mirror1 = Mirror(reflecting: self)
        let mirror2 = Mirror(reflecting: other)

        var comparisons = [String: BasicComparison]()

        for child in mirror1.children {
            guard let childLabel = child.label else { continue }

            let childDescription = relationshipDescription(of: child.value)

            guard let otherChild = mirror2.children.first(where: { $0.label == childLabel }) else {
                comparisons[childLabel] = .different(childDescription, "missing")
                continue
            }

            do {
                if (try relationshipsEqual(child.value, otherChild.value)) {
                    comparisons[childLabel] = .same
                } else {
                    let otherChildDescription = relationshipDescription(of: otherChild.value)

                    comparisons[childLabel] = .different(childDescription, otherChildDescription)
                }
            } catch let error {
                comparisons[childLabel] = .prebuilt(String(describing: error))
            }
        }

        return comparisons
    }
}

enum RelationshipCompareError: Swift.Error, CustomStringConvertible {
    case nonRelationshipTypeProperty(String)

    var description: String {
        switch self {
        case .nonRelationshipTypeProperty(let type):
            return "comparison on non-JSON:API Relationship type (\(type)) not supported."
        }
    }
}

fileprivate func relationshipsEqual(_ one: Any, _ two: Any) throws -> Bool {
    guard let attr = one as? AbstractRelationship else {
        throw RelationshipCompareError.nonRelationshipTypeProperty(String(describing: type(of: one)))
    }

    return attr.equals(two)
}

fileprivate func relationshipDescription(of thing: Any) -> String {
    return (thing as? AbstractRelationship)?.abstractDescription ?? String(describing: thing)
}

protocol AbstractRelationship {
    var abstractDescription: String { get }

    func equals(_ other: Any) -> Bool
}

extension Optional: AbstractRelationship where Wrapped: AbstractRelationship {
    var abstractDescription: String {
        switch self {
        case .none:
            return "nil"
        case .some(let rel):
            return rel.abstractDescription
        }
    }

    func equals(_ other: Any) -> Bool {
        switch self {
        case .none:
            return (other as? _AbstractWrapper).map { $0.abstractSelf == nil } ?? false
        case .some(let rel):
            guard case let .some(otherVal) = (other as? _AbstractWrapper)?.abstractSelf else {
                return rel.equals(other)
            }
            return rel.equals(otherVal)
        }
    }
}

extension MetaRelationship: AbstractRelationship {
    var abstractDescription: String {
        return String(describing:
            (
                String(describing: meta),
                String(describing: links)
            )
        )
    }

    func equals(_ other: Any) -> Bool {
        guard let attributeB = other as? Self else {
            return false
        }
        return abstractDescription == attributeB.abstractDescription
    }
}

extension ToOneRelationship: AbstractRelationship {
    var abstractDescription: String {
        if meta is NoMetadata && links is NoLinks {
            return String(describing: id)
        }

        return String(describing:
            (
                String(describing: id),
                String(describing: meta),
                String(describing: links)
            )
        )
    }

    func equals(_ other: Any) -> Bool {
        guard let attributeB = other as? Self else {
            return false
        }
        return abstractDescription == attributeB.abstractDescription
    }
}

extension ToManyRelationship: AbstractRelationship {
    var abstractDescription: String {

        let idsString = ids.map { String.init(describing: $0.rawValue) }.joined(separator: ", ")

        if meta is NoMetadata && links is NoLinks {
            return idsString
        }

        return String(describing:
            (
                idsString,
                String(describing: meta),
                String(describing: links)
            )
        )
    }

    func equals(_ other: Any) -> Bool {
        guard let attributeB = other as? Self else {
            return false
        }
        return abstractDescription == attributeB.abstractDescription
    }
}
