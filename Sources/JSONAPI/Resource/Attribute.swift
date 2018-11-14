//
//  Attribute.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/13/18.
//

public struct Attribute<Value: Codable>: Codable {
	public let value: Value
}

extension Attribute: Equatable where Value: Equatable {}

// MARK: - Codable
extension Attribute {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		// A little trickery follows. If the value is nil, the
		// container.decode(Value.self) will fail even if Value
		// is Optional. However, we can check if decoding nil
		// succeeds and then attempt to coerce nil to a Value
		// type at which point we can store nil in `value`.
		let anyNil: Any? = nil
		if container.decodeNil(),
			let val = anyNil as? Value {
				value = val
				return
		}
		
		value = try container.decode(Value.self)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		
		// See note in decode above about the weirdness
		// going on here.
		let anyNil: Any? = nil
		if let _ = anyNil as? Value,
			(value as Any?) == nil {
			try container.encodeNil()
		}
		
		try container.encode(value)
	}
}
