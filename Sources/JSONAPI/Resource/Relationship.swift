//
//  Relationship.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 8/31/18.
//

/// An Entity relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// You should use the `ToOneRelationship` and `ToManyRelationship`
/// concrete types.
/// See https://jsonapi.org/format/#document-resource-object-linkage
//public protocol Relationship: Equatable, Encodable, CustomStringConvertible {
//	associatedtype EntityType: JSONAPI.EntityDescription where EntityType.Identifier: IdType
//	var ids: [EntityType.Identifier] { get }
//}

/// An Entity relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `One<EntityDescription>`
public struct ToOneRelationship<Relatable: JSONAPI.OptionalRelatable>: Equatable, Codable {

	public let id: Relatable.Identifier
	
	public var ids: [Relatable.Identifier] {
		return [id]
	}
}

extension ToOneRelationship where Relatable.Description.Identifier == Relatable.Identifier {
	public init(entity: Entity<Relatable.Description>) {
		id = entity.id
	}
}

/// An Entity relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `Many<EntityDescription>`
public struct ToManyRelationship<Relatable: JSONAPI.Relatable>: Equatable, Codable {

	public let ids: [Relatable.Identifier]

	public init<T: JSONAPI.Relatable>(relationships: [ToOneRelationship<T>]) where T.Identifier == Relatable.Identifier {
		ids = relationships.map { $0.id }
	}

	private init() {
		ids = []
	}
	
	public static var none: ToManyRelationship {
		return .init()
	}
}

extension ToManyRelationship where Relatable.Description.Identifier == Relatable.Identifier {
	public init(entities: [Entity<Relatable.Description>]) {
		ids = entities.map { $0.id }
	}
}

/// The OptionalRelatable protocol ONLY describes
/// Optional<T: Relatable> types.
public protocol OptionalRelatable {
	associatedtype Description: EntityDescription where Description.Identifier: IdType
	associatedtype Identifier: Equatable & Codable
}

/// The Relatable protocol describes anything that
/// has an EntityDescription
public protocol Relatable: OptionalRelatable {}

extension Entity: Relatable, OptionalRelatable where EntityType.Identifier: IdType {
	public typealias Description = EntityType
}

extension Optional: OptionalRelatable where Wrapped: Relatable {
	public typealias Description = Wrapped.Description
	public typealias Identifier = Wrapped.Description.Identifier?
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

		// A little trickery follows. If the id is nil, the
		// container.decode(Identifier.self) will fail even if Identifier
		// is Optional. However, we can check if decoding nil
		// succeeds and then attempt to coerce nil to a Identifier
		// type at which point we can store nil in `id`.
		let anyNil: Any? = nil
		if try container.decodeNil(forKey: .data),
			let val = anyNil as? Relatable.Identifier {
			id = val
			return
		}

		let identifier = try container.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self, forKey: .data)
		
		let type = try identifier.decode(String.self, forKey: .entityType)
		
		guard type == Relatable.Description.type else {
			throw JSONAPIEncodingError.typeMismatch(expected: Relatable.Description.type, found: type)
		}
		
		id = try identifier.decode(Relatable.Identifier.self, forKey: .id)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ResourceLinkageCodingKeys.self)

		if (id as Any?) == nil {
			try container.encodeNil(forKey: .data)
		}

		var identifier = container.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self, forKey: .data)
		
		try identifier.encode(id, forKey: .id)
		try identifier.encode(Relatable.Description.type, forKey: .entityType)
	}
}

extension ToManyRelationship {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ResourceLinkageCodingKeys.self)
		
		var identifiers = try container.nestedUnkeyedContainer(forKey: .data)
		
		var newIds = [Relatable.Identifier]()
		while !identifiers.isAtEnd {
			let identifier = try identifiers.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self)
			
			let type = try identifier.decode(String.self, forKey: .entityType)
			
			guard type == Relatable.Description.type else {
				throw JSONAPIEncodingError.typeMismatch(expected: Relatable.Description.type, found: type)
			}
			
			newIds.append(try identifier.decode(Relatable.Identifier.self, forKey: .id))
		}
		ids = newIds
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ResourceLinkageCodingKeys.self)
		var identifiers = container.nestedUnkeyedContainer(forKey: .data)
		
		for id in ids {
			var identifier = identifiers.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self)
			
			try identifier.encode(id, forKey: .id)
			try identifier.encode(Relatable.Description.type, forKey: .entityType)
		}
	}
}

// MARK: CustomStringDescribable
public extension ToOneRelationship {
	var description: String { return "Relationship(\(String(describing: id)))" }
}

public extension ToManyRelationship {
	var description: String { return "Relationship(\(String(describing: ids)))" }
}
