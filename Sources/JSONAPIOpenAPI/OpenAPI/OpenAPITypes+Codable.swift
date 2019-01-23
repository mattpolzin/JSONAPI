//
//  OpenAPITypes+Codable.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/14/19.
//

extension JSONNode.Context: Encodable {

	private enum CodingKeys: String, CodingKey {
		case type
		case format
		case allowedValues = "enum"
		case nullable
		case example
//		case constantValue = "const"
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

//		if constantValue != nil {
//			try container.encode(constantValue, forKey: .constantValue)
//		}

		try container.encode(nullable, forKey: .nullable)

		if example != nil {
			try container.encode(example, forKey: .example)
		}
	}
}

extension JSONNode.NumericContext: Encodable {
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

extension JSONNode.StringContext: Encodable {
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

extension JSONNode.ArrayContext: Encodable {
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

extension JSONNode.ObjectContext : Encodable {
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

		try container.encode(requiredProperties, forKey: .required)

		try container.encode(minProperties, forKey: .minProperties)
	}
}

extension JSONNode: Encodable {

	private enum SubschemaCodingKeys: String, CodingKey {
		case allOf
		case oneOf
		case anyOf
		case not
		case reference = "$ref"
	}

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

		case .all(of: let nodes):
			var container = encoder.container(keyedBy: SubschemaCodingKeys.self)

			try container.encode(nodes, forKey: .allOf)

		case .one(of: let nodes):
			var container = encoder.container(keyedBy: SubschemaCodingKeys.self)

			try container.encode(nodes, forKey: .oneOf)

		case .any(of: let nodes):
			var container = encoder.container(keyedBy: SubschemaCodingKeys.self)

			try container.encode(nodes, forKey: .anyOf)

		case .not(let node):
			var container = encoder.container(keyedBy: SubschemaCodingKeys.self)

			try container.encode(node, forKey: .not)

		case .reference(let reference):
			var container = encoder.container(keyedBy: SubschemaCodingKeys.self)

			try container.encode(reference, forKey: .reference)
		}
	}
}

extension JSONReference: Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		try container.encode("#/\(Root.refName)/\(refName)/\(selector)")
	}
}

extension RefDict: Encodable {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		try container.encode(dict)
	}
}
