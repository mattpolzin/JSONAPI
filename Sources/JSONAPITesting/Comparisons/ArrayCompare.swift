//
//  File.swift
//  
//
//  Created by Mathew Polzin on 11/5/19.
//

import JSONAPI

public enum ArrayElementComparison: Equatable, CustomStringConvertible {
    case same
    case missing
    case differentTypes(String, String)
    case differentValues(String, String)
    case prebuilt(String)

    public init(resourceObjectComparison: ResourceObjectComparison) {
        guard !resourceObjectComparison.isSame else {
            self = .same
            return
        }

        self = .prebuilt(
            resourceObjectComparison
                .differences
                .sorted { $0.key < $1.key }
                .map { "\($0.key): \($0.value)" }
                .joined(separator: ", ")
        )
    }

    public var description: String {
        switch self {
        case .same:
            return "same"
        case .missing:
            return "missing"
        case .differentTypes(let one, let two),
             .differentValues(let one, let two):
            return "\(one) ≠ \(two)"
        case .prebuilt(let description):
            return description
        }
    }

    public var rawValue: String { description }
}

extension Array {
    func compare(to other: Self, using compare: (Element, Element) -> ArrayElementComparison) -> [ArrayElementComparison] {
        let isSelfLonger = count >= other.count

        let longer = isSelfLonger ? self : other
        let shorter = isSelfLonger ? other : self

        return longer.indices.map { idx in
            guard shorter.indices.contains(idx) else {
                return .missing
            }

            let this = longer[idx]
            let other = shorter[idx]

            return compare(this, other)
        }
    }
}
