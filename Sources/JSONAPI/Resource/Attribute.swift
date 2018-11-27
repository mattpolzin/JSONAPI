//
//  Attribute.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/13/18.
//

public struct TransformedAttribute<RawValue: Codable, Transformer: JSONAPI.Transformer>: Codable where Transformer.From == RawValue {
	private let rawValue: RawValue
	
	public let value: Transformer.To
	
	public init(rawValue: RawValue) throws {
		self.rawValue = rawValue
		value = try Transformer.transform(rawValue)
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

public typealias ValidatedAttribute<RawValue: Codable, Validator: JSONAPI.Validator> = TransformedAttribute<RawValue, Validator> where RawValue == Validator.From

public typealias Attribute<T: Codable> = TransformedAttribute<T, IdentityTransformer<T>>

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
		
		// See note in decode above about the weirdness
		// going on here.
		let anyNil: Any? = nil
		if let _ = anyNil as? Transformer.From,
			(rawValue as Any?) == nil {
			try container.encodeNil()
		}
		
		try container.encode(rawValue)
	}
}
