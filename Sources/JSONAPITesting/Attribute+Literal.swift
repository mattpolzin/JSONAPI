
import JSONAPI

extension Attribute: ExpressibleByUnicodeScalarLiteral where RawValue: ExpressibleByUnicodeScalarLiteral {
    public typealias UnicodeScalarLiteralType = RawValue.UnicodeScalarLiteralType

    public init(unicodeScalarLiteral value: RawValue.UnicodeScalarLiteralType) {
        self.init(value: RawValue(unicodeScalarLiteral: value))
    }
}

extension Attribute: ExpressibleByExtendedGraphemeClusterLiteral where RawValue: ExpressibleByExtendedGraphemeClusterLiteral {
    public typealias ExtendedGraphemeClusterLiteralType = RawValue.ExtendedGraphemeClusterLiteralType

    public init(extendedGraphemeClusterLiteral value: RawValue.ExtendedGraphemeClusterLiteralType) {
        self.init(value: RawValue(extendedGraphemeClusterLiteral: value))
    }
}

extension Attribute: ExpressibleByStringLiteral where RawValue: ExpressibleByStringLiteral {
    public typealias StringLiteralType = RawValue.StringLiteralType

    public init(stringLiteral value: RawValue.StringLiteralType) {
        self.init(value: RawValue(stringLiteral: value))
    }
}

extension Attribute: ExpressibleByNilLiteral where RawValue: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) {
        self.init(value: RawValue(nilLiteral: ()))
    }
}

extension Attribute: ExpressibleByFloatLiteral where RawValue: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = RawValue.FloatLiteralType

    public init(floatLiteral value: RawValue.FloatLiteralType) {
        self.init(value: RawValue(floatLiteral: value))
    }
}

extension Optional: ExpressibleByFloatLiteral where Wrapped: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Wrapped.FloatLiteralType

    public init(floatLiteral value: FloatLiteralType) {
        self = .some(Wrapped(floatLiteral: value))
    }
}

extension Attribute: ExpressibleByBooleanLiteral where RawValue: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = RawValue.BooleanLiteralType

    public init(booleanLiteral value: BooleanLiteralType) {
        self.init(value: RawValue(booleanLiteral: value))
    }
}

extension Optional: ExpressibleByBooleanLiteral where Wrapped: ExpressibleByBooleanLiteral {
    public typealias BooleanLiteralType = Wrapped.BooleanLiteralType

    public init(booleanLiteral value: BooleanLiteralType) {
        self = .some(Wrapped(booleanLiteral: value))
    }
}

extension Attribute: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = RawValue.IntegerLiteralType

    public init(integerLiteral value: IntegerLiteralType) {
        self.init(value: RawValue(integerLiteral: value))
    }
}

extension Optional: ExpressibleByIntegerLiteral where Wrapped: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Wrapped.IntegerLiteralType

    public init(integerLiteral value: IntegerLiteralType) {
        self = .some(Wrapped(integerLiteral: value))
    }
}

// regretably, array and dictionary literals are not so easy because Dictionaries and Arrays
// cannot be turned back into variadic arguments to pass onto the RawValue type's constructor.

// we can still provide a case for the Array and Dictionary types, though.
public protocol DictionaryType {
    associatedtype Key: Hashable
    associatedtype Value

    init<S>(_ keysAndValues: S, uniquingKeysWith combine: (Dictionary<Key, Value>.Value, Dictionary<Key, Value>.Value) throws -> Dictionary<Key, Value>.Value) rethrows where S : Sequence, S.Element == (Key, Value)
}
extension Dictionary: DictionaryType {}

extension Attribute: ExpressibleByDictionaryLiteral where RawValue: DictionaryType {
    public typealias Key = RawValue.Key

    public typealias Value = RawValue.Value

    public init(dictionaryLiteral elements: (RawValue.Key, RawValue.Value)...) {

        // we arbitrarily keep the first value if two values are assigned to the same key
        self.init(value: RawValue(elements, uniquingKeysWith: { val, _ in val }))
    }
}

extension Optional: DictionaryType where Wrapped: DictionaryType {
    public typealias Key = Wrapped.Key

    public typealias Value = Wrapped.Value

    public init<S>(_ keysAndValues: S, uniquingKeysWith combine: (Dictionary<Key, Value>.Value, Dictionary<Key, Value>.Value) throws -> Dictionary<Key, Value>.Value) rethrows where S : Sequence, S.Element == (Key, Value) {
        self = try .some(Wrapped(keysAndValues, uniquingKeysWith: combine))
    }
}

public protocol ArrayType {
    associatedtype Element

    init<S>(_ s: S) where Element == S.Element, S : Sequence
}
extension Array: ArrayType {}
extension ArraySlice: ArrayType {}

extension Attribute: ExpressibleByArrayLiteral where RawValue: ArrayType {
    public typealias ArrayLiteralElement = RawValue.Element

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(value: RawValue(elements))
    }
}

extension Optional: ArrayType where Wrapped: ArrayType {
    public typealias Element = Wrapped.Element

    public init<S>(_ s: S) where Element == S.Element, S : Sequence {
        self = .some(Wrapped(s))
    }
}
