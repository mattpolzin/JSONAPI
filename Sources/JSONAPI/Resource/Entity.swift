//
//  Entity.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 7/24/18.
//

/// A JSON API structure within an Entity that contains
/// named properties of types `ToOneRelationship` and
/// `ToManyRelationship`.
public typealias Relationships = Codable & Equatable

/// A JSON API structure within an Entity that contains
/// properties of any types that are JSON encodable.
public typealias Attributes = Codable & Equatable

/// Can be used as `Relationships` Type for Entities that do not
/// have any Relationships.
public struct NoRelatives: Relationships {}

/// Can be used as `Attributes` Type for Entities that do not
/// have any Attributes.
public struct NoAttributes: Attributes {}

/// An `EntityType` describes a JSON API
/// Resource Object. The Resource Object
/// itself is encoded and decoded as an
/// `Entity`, which gets specialized on an
/// `EntityType`.
public protocol EntityType {
	associatedtype Identifier: JSONAPI.Identifier
	associatedtype AttributeType: Attributes
	associatedtype RelatedType: Relationships
	
	static var type: String { get }
}

/// Shorthand for an `EntityType` that has an Id.
/// The only times you would not want an `EntityType`
/// to not be an `IdentifiedEntityType` are when you
/// are a client making a request to create a new `Entity`
/// or you are a server receiving a request to create a
/// new `Entity`.
public protocol IdentifiedEntityType: EntityType where Identifier: IdType {}

/// Shorthand for an `EntityType` that does not have an Id.
/// The only times you would not want an `EntityType`
/// to not be an `IdentifiedEntityType` are when you
/// are a client making a request to create a new `Entity`
/// or you are a server receiving a request to create a
/// new `Entity`.
public protocol UnidentifiedEntityType: EntityType where Identifier == Unidentified {}

/// An `Entity` is a single model type that can be
/// encoded to or decoded from a JSON API
/// "Resource Object."
/// See https://jsonapi.org/format/#document-resource-objects
public struct Entity<EntityType: JSONAPI.EntityType>: Codable, Equatable {
	/// The JSON API compliant "type" of this `Entity`.
	public static var type: String { return EntityType.type }
	
	/// The `Entity`'s Id. This can be of type `Unidentified` if
	/// the entity is being created clientside and the
	/// server is being asked to create a unique Id. Otherwise,
	/// this should be of a type conforming to `IdType`.
	public let id: EntityType.Identifier
	
	/// The JSON API compliant attributes of this `Entity`.
	public let attributes: EntityType.AttributeType
	
	/// The JSON API compliant relationships of this `Entity`.
	public let relationships: EntityType.RelatedType
	
	public init(id: EntityType.Identifier, attributes: EntityType.AttributeType, relationships: EntityType.RelatedType) {
		self.id = id
		self.attributes = attributes
		self.relationships = relationships
	}
	
	public init(attributes: EntityType.AttributeType, relationships: EntityType.RelatedType) {
		self.id = .init()
		self.attributes = attributes
		self.relationships = relationships
	}
}

extension Entity where EntityType.AttributeType == NoAttributes {
	public init(id: EntityType.Identifier, relationships: EntityType.RelatedType) {
		self.init(id: id, attributes: NoAttributes(), relationships: relationships)
	}
	
	public init(relationships: EntityType.RelatedType) {
		self.init(attributes: NoAttributes(), relationships: relationships)
	}
}

extension Entity where EntityType.RelatedType == NoRelatives {
	public init(id: EntityType.Identifier, attributes: EntityType.AttributeType) {
		self.init(id: id, attributes: attributes, relationships: NoRelatives())
	}
	
	public init(attributes: EntityType.AttributeType) {
		self.init(attributes: attributes, relationships: NoRelatives())
	}
}

extension Entity where EntityType.AttributeType == NoAttributes, EntityType.RelatedType == NoRelatives {
	public init(id: EntityType.Identifier) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelatives())
	}
	
	public init() {
		self.init(attributes: NoAttributes(), relationships: NoRelatives())
	}
}

//public protocol IdentifiedEntityType: JSONAPI.EntityType where IdentifiedEntityType.Identifier: IdType, Identifier.Entity == Self {}

public extension Entity where EntityType.Identifier: IdType {
	/// Get a pointer to this entity that can be used as a
	/// relationship to another entity.
	public var pointer: ToOneRelationship<EntityType> {
		return ToOneRelationship(entity: self)
	}
}

// MARK: Attribute Access
public extension Entity {
	subscript<T>(_ path: KeyPath<EntityType.AttributeType, T>) -> T {
		return attributes[keyPath: path]
	}
}

// MARK: Relationship Access
public extension Entity {
	public static func ~><OtherEntityType: JSONAPI.EntityType>(entity: Entity<EntityType>, path: KeyPath<EntityType.RelatedType, ToOneRelationship<OtherEntityType>>) -> OtherEntityType.Identifier {
		return entity.relationships[keyPath: path].id
	}
	
	public static func ~><OtherEntityType: JSONAPI.EntityType>(entity: Entity<EntityType>, path: KeyPath<EntityType.RelatedType, ToManyRelationship<OtherEntityType>>) -> [OtherEntityType.Identifier] {
		return entity.relationships[keyPath: path].ids
	}
}

infix operator ~>

// MARK: - Codable
private enum ResourceObjectCodingKeys: String, CodingKey {
	case type = "type"
	case id = "id"
	case attributes = "attributes"
	case relationships = "relationships"
}

public extension Entity {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ResourceObjectCodingKeys.self)
		
		try container.encode(Entity.type, forKey: .type)
		
		if EntityType.Identifier.self != Unidentified.self {
			try container.encode(id, forKey: .id)
		}
		
		if EntityType.AttributeType.self != NoAttributes.self {
			try container.encode(attributes, forKey: .attributes)
		}
		
		if EntityType.RelatedType.self != NoRelatives.self {
			try container.encode(relationships, forKey: .relationships)
		}
	}

	public init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: ResourceObjectCodingKeys.self)
		
		let type = try container.decode(String.self, forKey: .type)
		
		guard Entity.type == type else {
			throw JSONAPIEncodingError.typeMismatch(expected: EntityType.type, found: type)
		}
		
		id = try (Unidentified() as? EntityType.Identifier) ?? container.decode(EntityType.Identifier.self, forKey: .id)
		
		attributes = try (NoAttributes() as? EntityType.AttributeType) ?? container.decode(EntityType.AttributeType.self, forKey: .attributes)
		
		relationships = try (NoRelatives() as? EntityType.RelatedType) ?? container.decode(EntityType.RelatedType.self, forKey: .relationships)
	}
}
