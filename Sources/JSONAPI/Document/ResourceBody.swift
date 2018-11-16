//
//  ResourceBody.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

public protocol ResourceBody: Decodable {
}

public struct SingleResourceBody<EntityDescription: JSONAPI.EntityDescription>: ResourceBody {
	public let value: Entity<EntityDescription>?
}

public struct ManyResourceBody<EntityDescription: JSONAPI.EntityDescription>: ResourceBody {
	public let values: [Entity<EntityDescription>]
}

// MARK: Decodable
extension SingleResourceBody {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		value = try container.decode(Entity<EntityDescription>.self)
	}
}

extension ManyResourceBody {
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		var valueAggregator = [Entity<EntityDescription>]()
		while !container.isAtEnd {
			valueAggregator.append(try container.decode(Entity<EntityDescription>.self))
		}
		values = valueAggregator
	}
}
