
import JSONAPI

extension TransformedAttribute: ExpressibleByUnicodeScalarLiteral where RawValue: ExpressibleByUnicodeScalarLiteral, Transformer == IdentityTransformer<RawValue> {
	public typealias UnicodeScalarLiteralType = RawValue.UnicodeScalarLiteralType

	public init(unicodeScalarLiteral value: RawValue.UnicodeScalarLiteralType) {
		self.init(value: RawValue(unicodeScalarLiteral: value))
	}
}

extension TransformedAttribute: ExpressibleByExtendedGraphemeClusterLiteral where RawValue: ExpressibleByExtendedGraphemeClusterLiteral, Transformer == IdentityTransformer<RawValue> {
	public typealias ExtendedGraphemeClusterLiteralType = RawValue.ExtendedGraphemeClusterLiteralType

	public init(extendedGraphemeClusterLiteral value: RawValue.ExtendedGraphemeClusterLiteralType) {
		self.init(value: RawValue(extendedGraphemeClusterLiteral: value))
	}
}

extension TransformedAttribute: ExpressibleByStringLiteral where RawValue: ExpressibleByStringLiteral, Transformer == IdentityTransformer<RawValue> {
	public typealias StringLiteralType = RawValue.StringLiteralType

	public init(stringLiteral value: RawValue.StringLiteralType) {
		self.init(value: RawValue(stringLiteral: value))
	}
}

extension TransformedAttribute: ExpressibleByNilLiteral where RawValue: ExpressibleByNilLiteral, Transformer == IdentityTransformer<RawValue> {
	public init(nilLiteral: ()) {
		self.init(value: RawValue(nilLiteral: ()))
	}
}

extension TransformedAttribute: ExpressibleByFloatLiteral where RawValue: ExpressibleByFloatLiteral, Transformer == IdentityTransformer<RawValue> {
	public typealias FloatLiteralType = RawValue.FloatLiteralType

	public init(floatLiteral value: RawValue.FloatLiteralType) {
		self.init(value: RawValue(floatLiteral: value))
	}
}

extension TransformedAttribute: ExpressibleByBooleanLiteral where RawValue: ExpressibleByBooleanLiteral, Transformer == IdentityTransformer<RawValue> {
	public typealias BooleanLiteralType = RawValue.BooleanLiteralType

	public init(booleanLiteral value: BooleanLiteralType) {
		self.init(value: RawValue(booleanLiteral: value))
	}
}

extension TransformedAttribute: ExpressibleByIntegerLiteral where RawValue: ExpressibleByIntegerLiteral, Transformer == IdentityTransformer<RawValue> {
	public typealias IntegerLiteralType = RawValue.IntegerLiteralType

	public init(integerLiteral value: IntegerLiteralType) {
		self.init(value: RawValue(integerLiteral: value))
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

extension TransformedAttribute: ExpressibleByDictionaryLiteral where RawValue: DictionaryType, Transformer == IdentityTransformer<RawValue> {
	public typealias Key = RawValue.Key

	public typealias Value = RawValue.Value

	public init(dictionaryLiteral elements: (RawValue.Key, RawValue.Value)...) {

		// we arbitrarily keep the first value if two values are assigned to the same key
		self.init(value: RawValue(elements, uniquingKeysWith: { val, _ in val }))
	}
}

public protocol ArrayType {
	associatedtype Element

	init<S>(_ s: S) where Element == S.Element, S : Sequence
}
extension Array: ArrayType {}
extension ArraySlice: ArrayType {}

extension TransformedAttribute: ExpressibleByArrayLiteral where RawValue: ArrayType, Transformer == IdentityTransformer<RawValue> {
	public typealias ArrayLiteralElement = RawValue.Element

	public init(arrayLiteral elements: ArrayLiteralElement...) {
		self.init(value: RawValue(elements))
	}
}
