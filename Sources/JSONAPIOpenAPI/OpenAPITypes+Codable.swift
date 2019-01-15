//
//  OpenAPITypes+Codable.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/14/19.
//

extension OpenAPI.JSONNode.Context: Encodable {

	private enum CodingKeys: String, CodingKey {
		case type
		case format
		case allowedValues = "enum"
		case nullable
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(format.jsonType, forKey: .type)

		if format != Format.unspecified {
			try container.encode(format, forKey: .format)
		}

		if allowedValues != nil {
			try container.encode(allowedValues, forKey: .allowedValues)
		}

		try container.encode(nullable, forKey: .nullable)
	}
}

extension OpenAPI.JSONNode.NumericContext: Encodable {
	private enum CodingKeys: String, CodingKey {
		case multipleOf
		case maximum
		case exclusiveMaximum
		case minimum
		case exclusiveMinimum
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		if multipleOf != nil {
			try container.encode(multipleOf, forKey: .multipleOf)
		}

		if maximum != nil {
			try container.encode(maximum, forKey: .maximum)
		}

		if exclusiveMaximum != nil {
			try container.encode(exclusiveMaximum, forKey: .exclusiveMaximum)
		}

		if minimum != nil {
			try container.encode(minimum, forKey: .minimum)
		}

		if exclusiveMinimum != nil {
			try container.encode(exclusiveMinimum, forKey: .exclusiveMinimum)
		}
	}
}

extension OpenAPI.JSONNode.StringContext: Encodable {
	private enum CodingKeys: String, CodingKey {
		case maxLength
		case minLength
		case pattern
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		if maxLength != nil {
			try container.encode(maxLength, forKey: .maxLength)
		}

		try container.encode(minLength, forKey: .minLength)

		if pattern != nil {
			try container.encode(pattern, forKey: .pattern)
		}
	}
}

extension OpenAPI.JSONNode.ArrayContext: Encodable {
	private enum CodingKeys: String, CodingKey {
		case items
		case maxItems
		case minItems
		case uniqueItems
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		try container.encode(items, forKey: .items)

		if maxItems != nil {
			try container.encode(maxItems, forKey: .maxItems)
		}

		try container.encode(minItems, forKey: .minItems)

		try container.encode(uniqueItems, forKey: .uniqueItems)
	}
}

extension OpenAPI.JSONNode.ObjectContext : Encodable{
	private enum CodingKeys: String, CodingKey {
		case maxProperties
		case minProperties
		case properties
		case additionalProperties
		case required
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)

		if maxProperties != nil {
			try container.encode(maxProperties, forKey: .maxProperties)
		}

		try container.encode(properties, forKey: .properties)

		if additionalProperties != nil {
			try container.encode(additionalProperties, forKey: .additionalProperties)
		}

		let required = properties.filter { (name, node) in
			node.required
		}.keys

		try container.encode(Array(required), forKey: .required)

		try container.encode(max(minProperties, required.count), forKey: .minProperties)
	}
}

extension OpenAPI.JSONNode: Encodable {
	public func encode(to encoder: Encoder) throws {
		switch self {
		case .boolean(let context):
			try context.encode(to: encoder)

		case .object(let contextA as Encodable, let contextB as Encodable),
			 .array(let contextA as Encodable, let contextB as Encodable),
			 .number(let contextA as Encodable, let contextB as Encodable),
			 .integer(let contextA as Encodable, let contextB as Encodable),
			 .string(let contextA as Encodable, let contextB as Encodable):
			try contextA.encode(to: encoder)
			try contextB.encode(to: encoder)

		case .allOf(let nodes):
			// TODO
			print("TODO")

		case .oneOf(let nodes):
			// TODO
			print("TODO")

		case .anyOf(let nodes):
			// TODO
			print("TODO")

		case .not(let node):
			// TODO
			print("TODO")
		}
	}
}
