//
//  AttributesCompare.swift
//  
//
//  Created by Mathew Polzin on 11/3/19.
//

import JSONAPI

extension Attributes {
    public func compare(to other: Self) -> [String: BasicComparison] {
        let mirror1 = Mirror(reflecting: self)
        let mirror2 = Mirror(reflecting: other)

        var comparisons = [String: BasicComparison]()

        for child in mirror1.children {
            guard let childLabel = child.label else { continue }

            let childDescription = attributeDescription(of: child.value)

            guard let otherChild = mirror2.children.first(where: { $0.label == childLabel }) else {
                comparisons[childLabel] = .different(childDescription, "missing")
                continue
            }

            do {
                if (try attributesEqual(child.value, otherChild.value)) {
                    comparisons[childLabel] = .same
                } else {
                    let otherChildDescription = attributeDescription(of: otherChild.value)

                    comparisons[childLabel] = .different(childDescription, otherChildDescription)
                }
            } catch let error {
                comparisons[childLabel] = .prebuilt(String(describing: error))
            }
        }

        return comparisons
    }
}

enum AttributeCompareError: Swift.Error, CustomStringConvertible {
    case nonAttributeTypeProperty(String)

    var description: String {
        switch self {
        case .nonAttributeTypeProperty(let type):
            return "comparison on non-JSON:API Attribute type (\(type)) not supported."
        }
    }
}

fileprivate func attributesEqual(_ one: Any, _ two: Any) throws -> Bool {
    guard let attr = one as? AbstractAttribute else {
        throw AttributeCompareError.nonAttributeTypeProperty(String(describing: type(of: one)))
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

extension Optional: AbstractAttribute where Wrapped: AbstractAttribute {
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
