//
//  ResourceBody.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

public protocol ResourceBody: Decodable {
	typealias Single<EntityType: JSONAPI.EntityDescription> = SingleResourceBody<EntityType>
	typealias Many<EntityType: JSONAPI.EntityDescription> = ManyResourceBody<EntityType>
}

public struct SingleResourceBody<EntityType: JSONAPI.EntityDescription>: ResourceBody {
	public let value: Entity<EntityType>?
}

public struct ManyResourceBody<EntityType: JSONAPI.EntityDescription>: ResourceBody {
	public let values: [Entity<EntityType>]
}

// MARK: Decodable
extension SingleResourceBody {
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		value = try container.decode(Entity<EntityType>.self)
	}
}

extension ManyResourceBody {
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		var valueAggregator = [Entity<EntityType>]()
		while !container.isAtEnd {
			valueAggregator.append(try container.decode(Entity<EntityType>.self))
		}
		values = valueAggregator
	}
}
