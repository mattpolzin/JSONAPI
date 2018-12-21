//
//  Attribute.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/13/18.
//

public protocol AttributeType: Codable {
}

// MARK: TransformedAttribute
/// A TransformedAttribute takes a Codable type and attempts to turn it into another type.
public struct TransformedAttribute<RawValue: Codable, Transformer: JSONAPI.Transformer>: AttributeType where Transformer.From == RawValue {
	let rawValue: RawValue
	
	public let value: Transformer.To
	
	public init(rawValue: RawValue) throws {
		self.rawValue = rawValue
		value = try Transformer.transform(rawValue)
	}
}

// MARK: ValidatedAttribute
/// A ValidatedAttribute does not transform its raw value, but it throws
/// an error if the raw value does not match expectations.
public typealias ValidatedAttribute<RawValue: Codable, Validator: JSONAPI.Validator> = TransformedAttribute<RawValue, Validator> where RawValue == Validator.From

// MARK: Attribute
/// An Attribute simply represents a type that can be encoded and decoded.
public typealias Attribute<T: Codable> = TransformedAttribute<T, IdentityTransformer<T>>

extension TransformedAttribute where Transformer: ReversibleTransformer {
	public init(transformedValue: Transformer.To) throws {
		self.value = transformedValue
		rawValue = try Transformer.reverse(value)
	}
}

extension TransformedAttribute: CustomStringConvertible {
	public var description: String {
		return "Attribute<\(String(describing: Transformer.From.self)) -> \(String(describing: Transformer.To.self))>(\(String(describing: value)))"
	}
}

extension TransformedAttribute: Equatable where Transformer.From: Equatable, Transformer.To: Equatable {}

extension TransformedAttribute where Transformer == IdentityTransformer<RawValue> {
	// If we are using the identity transform, we can skip the transform and guarantee no
	// error is thrown.
	public init(value: RawValue) {
		rawValue = value
		self.value = value
	}
}

// MARK: - Codable
extension TransformedAttribute {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let rawVal: RawValue
		
		// A little trickery follows. If the value is nil, the
		// container.decode(Value.self) will fail even if Value
		// is Optional. However, we can check if decoding nil
		// succeeds and then attempt to coerce nil to a Value
		// type at which point we can store nil in `value`.
		let anyNil: Any? = nil
		if container.decodeNil(),
			let val = anyNil as? Transformer.From {
				rawVal = val
		} else {
			rawVal = try container.decode(Transformer.From.self)
		}
		
		rawValue = rawVal
		value = try Transformer.transform(rawVal)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		try container.encode(rawValue)
	}
}
