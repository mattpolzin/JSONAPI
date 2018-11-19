//
//  ResourceBody.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

public protocol ResourceBody: Codable, Equatable {
}

public struct SingleResourceBody<Entity: JSONAPI.EntityType>: ResourceBody {
	public let value: Entity?

	public init(entity: Entity?) {
		self.value = entity
	}
}

public struct ManyResourceBody<Entity: JSONAPI.EntityType>: ResourceBody {
	public let values: [Entity]

	public init(entities: [Entity]) {
		values = entities
	}
}

// MARK: Decodable
extension SingleResourceBody {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		if container.decodeNil() {
			value = nil
			return
		}

		value = try container.decode(Entity.self)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		if value == nil {
			try container.encodeNil()
			return
		}

		try container.encode(value)
	}
}

extension ManyResourceBody {
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		var valueAggregator = [Entity]()
		while !container.isAtEnd {
			valueAggregator.append(try container.decode(Entity.self))
		}
		values = valueAggregator
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()

		for value in values {
			try container.encode(value)
		}
	}
}

// MARK: CustomStringConvertible

extension SingleResourceBody: CustomStringConvertible {
	public var description: String {
		return "ResourceBody(\(String(describing: value)))"
	}
}

extension ManyResourceBody: CustomStringConvertible {
	public var description: String {
		return "ResourceBody(\(String(describing: values)))"
	}
}
