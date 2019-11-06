//
//  File.swift
//  
//
//  Created by Mathew Polzin on 11/3/19.
//

import JSONAPI

extension Attributes {
    public func compare(to other: Self) -> [String: Comparison] {
        let mirror1 = Mirror(reflecting: self)
        let mirror2 = Mirror(reflecting: other)

        var comparisons = [String: Comparison]()

        for child in mirror1.children {
            guard let childLabel = child.label else { continue }

            let childDescription = attributeDescription(of: child.value)

            guard let otherChild = mirror2.children.first(where: { $0.label == childLabel }) else {
                comparisons[childLabel] = .different(childDescription, "missing")
                continue
            }

            if (attributesEqual(child.value, otherChild.value)) {
                comparisons[childLabel] = .same
            } else {
                let otherChildDescription = attributeDescription(of: otherChild.value)

                comparisons[childLabel] = .different(childDescription, otherChildDescription)
            }
        }

        return comparisons
    }
}

fileprivate func attributesEqual(_ one: Any, _ two: Any) -> Bool {
    guard let attr = one as? AbstractAttribute else {
        return false
    }

    return attr.equals(two)
}

fileprivate func attributeDescription(of thing: Any) -> String {
    return (thing as? AbstractAttribute)?.abstractDescription ?? String(describing: thing)
}

protocol AbstractAttribute {
    var abstractDescription: String { get }

    func equals(_ other: Any) -> Bool
}

extension Attribute: AbstractAttribute {
    var abstractDescription: String { String(describing: value) }

    func equals(_ other: Any) -> Bool {
        guard let attributeB = other as? Self else {
            return false
        }
        return abstractDescription == attributeB.abstractDescription
    }
}

extension TransformedAttribute: AbstractAttribute {
    var abstractDescription: String { String(describing: value) }

    func equals(_ other: Any) -> Bool {
        guard let attributeB = other as? Self else {
            return false
        }
        return abstractDescription == attributeB.abstractDescription
    }
}
