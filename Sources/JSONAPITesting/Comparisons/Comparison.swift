//
//  Comparison.swift
//  
//
//  Created by Mathew Polzin on 11/3/19.
//

public protocol Comparable: CustomStringConvertible {
    var rawValue: String { get }

    var isSame: Bool { get }
}

public enum Comparison: Comparable, Equatable {
    case same
    case different(String, String)
    case prebuilt(String)

    init<T: Equatable>(_ one: T, _ two: T) {
        guard one == two else {
            self = .different(String(describing: one), String(describing: two))
            return
        }
        self = .same
    }

    init(reducing other: ArrayElementComparison) {
        switch other {
        case .same:
            self = .same
        case .differentTypes(let one, let two),
             .differentValues(let one, let two):
            self = .different(one, two)
        case .missing:
            self = .different("array length 1", "array length 2")
        case .prebuilt(let str):
            self = .prebuilt(str)
        }
    }

    public var description: String {
        switch self {
        case .same:
            return "same"
        case .different(let one, let two):
            return "\(one) ≠ \(two)"
        case .prebuilt(let str):
            return str
        }
    }

    public var rawValue: String { description }

    public var isSame: Bool { self == .same }
}

public typealias NamedDifferences = [String: String]

public protocol PropertyComparable: Comparable {
    var differences: NamedDifferences { get }
}

extension PropertyComparable {
    public var description: String {
        return differences
            .map { "(\($0): \($1))" }
            .sorted()
            .joined(separator: ", ")
    }

    public var rawValue: String { description }

    public var isSame: Bool { differences.isEmpty }
}
