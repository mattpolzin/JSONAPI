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

            if (relationshipsEqual(child.value, otherChild.value)) {
                comparisons[childLabel] = .same
            } else {
                let otherChildDescription = relationshipDescription(of: otherChild.value)

                comparisons[childLabel] = .different(childDescription, otherChildDescription)
            }
        }

        return comparisons
    }
}

fileprivate func relationshipsEqual(_ one: Any, _ two: Any) -> Bool {
    guard let attr = one as? AbstractRelationship else {
        return false
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
