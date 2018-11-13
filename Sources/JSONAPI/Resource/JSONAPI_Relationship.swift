//
//  Relationship.swift
//  ElevatedCore
//
//  Created by Mathew Polzin on 8/31/18.
//

import Foundation

/// An Entity relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// You should use the `ToOneRelationship` and `ToManyRelationship`
/// concrete types.
/// See https://jsonapi.org/format/#document-resource-object-linkage
public protocol Relationship: Equatable, Encodable {
	associatedtype EntityType: JSONAPI.EntityType where EntityType.Identifier: IdType
	var ids: [EntityType.Identifier] { get }
}

/// An Entity relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `One<Entity>`
public struct ToOneRelationship<EntityType: JSONAPI.EntityType>: Equatable, Relationship, Decodable where EntityType.Identifier: IdType {
	public let id: EntityType.Identifier

	public init(entity: Entity<EntityType>) {
		id = entity.id
	}
	
	public var ids: [EntityType.Identifier] {
		return [id]
	}
}

/// An Entity relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `Many<Entity>`
public struct ToManyRelationship<EntityType: JSONAPI.EntityType>: Equatable, Relationship, Decodable where EntityType.Identifier: IdType {
	public let ids: [EntityType.Identifier]
	
	public init(entities: [Entity<EntityType>]) {
		ids = entities.map { $0.id }
	}
	
	public init<T: Relationship>(relationships: [T]) where T.EntityType == EntityType {
		ids = relationships.flatMap { $0.ids }
	}
}

// MARK: Codable
private enum ResourceLinkageCodingKeys: String, CodingKey {
	case data = "data"
}
private enum ResourceIdentifierCodingKeys: String, CodingKey {
	case id = "id"
	case entityType = "type"
}

public enum JSONAPIEncodingError: Swift.Error {
	case typeMismatch(expected: String, found: String)
}

extension ToOneRelationship {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ResourceLinkageCodingKeys.self)
		let identifier = try container.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self, forKey: .data)
		
		let type = try identifier.decode(String.self, forKey: .entityType)
		
		guard type == EntityType.type else {
			throw JSONAPIEncodingError.typeMismatch(expected: EntityType.type, found: type)
		}
		
		id = try identifier.decode(EntityType.Identifier.self, forKey: .id)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ResourceLinkageCodingKeys.self)
		var identifier = container.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self, forKey: .data)
		
		try identifier.encode(id, forKey: .id)
		try identifier.encode(EntityType.type, forKey: .entityType)
	}
}

extension ToManyRelationship {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ResourceLinkageCodingKeys.self)
		
		var identifiers = try container.nestedUnkeyedContainer(forKey: .data)
		
		var newIds = [EntityType.Identifier]()
		while !identifiers.isAtEnd {
			let identifier = try identifiers.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self)
			
			let type = try identifier.decode(String.self, forKey: .entityType)
			
			guard type == EntityType.type else {
				throw JSONAPIEncodingError.typeMismatch(expected: EntityType.type, found: type)
			}
			
			newIds.append(try identifier.decode(EntityType.Identifier.self, forKey: .id))
		}
		ids = newIds
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ResourceLinkageCodingKeys.self)
		var identifiers = container.nestedUnkeyedContainer(forKey: .data)
		
		for id in ids {
			var identifier = identifiers.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self)
			
			try identifier.encode(id, forKey: .id)
			try identifier.encode(EntityType.type, forKey: .entityType)
		}
	}
}
