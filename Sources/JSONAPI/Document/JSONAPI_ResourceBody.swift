//
//  JSONAPI_ResourceBody.swift
//  ElevatedCore
//
//  Created by Mathew Polzin on 11/10/18.
//

import Foundation

public protocol ResourceBody: Decodable {
	typealias Single<EntityType: JSONAPI.EntityType> = SingleResourceBody<EntityType>
	typealias Many<EntityType: JSONAPI.EntityType> = ManyResourceBody<EntityType>
}

public struct SingleResourceBody<EntityType: JSONAPI.EntityType>: ResourceBody {
	public let value: Entity<EntityType>?
}

public struct ManyResourceBody<EntityType: JSONAPI.EntityType>: ResourceBody {
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
