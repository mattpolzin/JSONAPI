//
//  ResourceBody.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

public protocol ResourceBody: Decodable {
}

public struct SingleResourceBody<Entity: JSONAPI.EntityType>: ResourceBody {
	public let value: Entity?
}

public struct ManyResourceBody<Entity: JSONAPI.EntityType>: ResourceBody {
	public let values: [Entity]
}

// MARK: Decodable
extension SingleResourceBody {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		value = try container.decode(Entity.self)
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
}
