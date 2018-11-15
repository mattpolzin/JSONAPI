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

/// An `EntityDescription` describes a JSON API
/// Resource Object. The Resource Object
/// itself is encoded and decoded as an
/// `Entity`, which gets specialized on an
/// `EntityDescription`.
public protocol EntityDescription {
	associatedtype Identifier: JSONAPI.Identifier
	associatedtype Attributes: JSONAPI.Attributes
	associatedtype Relationships: JSONAPI.Relationships
	
	static var type: String { get }
}

/// Shorthand for an `EntityDescription` that has an Id.
/// The only times you would not want an `EntityDescription`
/// to not be an `IdentifiedEntityDescription` are when you
/// are a client making a request to create a new `Entity`
/// or you are a server receiving a request to create a
/// new `Entity`.
public protocol IdentifiedEntityDescription: EntityDescription where Identifier: IdType {}

/// Shorthand for an `EntityDescription` that does not have an Id.
/// The only times you would not want an `EntityDescription`
/// to not be an `IdentifiedEntityDescription` are when you
/// are a client making a request to create a new `Entity`
/// or you are a server receiving a request to create a
/// new `Entity`.
public protocol UnidentifiedEntityDescription: EntityDescription where Identifier == Unidentified {}

/// An `Entity` is a single model type that can be
/// encoded to or decoded from a JSON API
/// "Resource Object."
/// See https://jsonapi.org/format/#document-resource-objects
public struct Entity<EntityType: JSONAPI.EntityDescription>: Codable, Equatable {
	public typealias Identifier = EntityType.Identifier
	
	/// The JSON API compliant "type" of this `Entity`.
	public static var type: String { return EntityType.type }
	
	/// The `Entity`'s Id. This can be of type `Unidentified` if
	/// the entity is being created clientside and the
	/// server is being asked to create a unique Id. Otherwise,
	/// this should be of a type conforming to `IdType`.
	public let id: Identifier
	
	/// The JSON API compliant attributes of this `Entity`.
	public let attributes: EntityType.Attributes
	
	/// The JSON API compliant relationships of this `Entity`.
	public let relationships: EntityType.Relationships
	
	public init(id: EntityType.Identifier, attributes: EntityType.Attributes, relationships: EntityType.Relationships) {
		self.id = id
		self.attributes = attributes
		self.relationships = relationships
	}
}

// MARK: Convenience initializers
extension Entity where EntityType.Identifier: CreatableIdType {
	public init(attributes: EntityType.Attributes, relationships: EntityType.Relationships) {
		self.id = EntityType.Identifier()
		self.attributes = attributes
		self.relationships = relationships
	}
}

extension Entity where EntityType.Attributes == NoAttributes {
	public init(id: EntityType.Identifier, relationships: EntityType.Relationships) {
		self.init(id: id, attributes: NoAttributes(), relationships: relationships)
	}
}

extension Entity where EntityType.Attributes == NoAttributes, EntityType.Identifier: CreatableIdType {
	public init(relationships: EntityType.Relationships) {
		self.init(attributes: NoAttributes(), relationships: relationships)
	}
}

extension Entity where EntityType.Relationships == NoRelatives {
	public init(id: EntityType.Identifier, attributes: EntityType.Attributes) {
		self.init(id: id, attributes: attributes, relationships: NoRelatives())
	}
}

extension Entity where EntityType.Relationships == NoRelatives, EntityType.Identifier: CreatableIdType {
	public init(attributes: EntityType.Attributes) {
		self.init(attributes: attributes, relationships: NoRelatives())
	}
}

extension Entity where EntityType.Attributes == NoAttributes, EntityType.Relationships == NoRelatives {
	public init(id: EntityType.Identifier) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelatives())
	}
}

extension Entity where EntityType.Attributes == NoAttributes, EntityType.Relationships == NoRelatives, EntityType.Identifier: CreatableIdType {
	public init() {
		self.init(attributes: NoAttributes(), relationships: NoRelatives())
	}
}

// MARK: Pointer for Relationships use.
public extension Entity where EntityType.Identifier: IdType {
	/// Get a pointer to this entity that can be used as a
	/// relationship to another entity.
	public var pointer: ToOneRelationship<Entity> {
		return ToOneRelationship(entity: self)
	}
}

// MARK: Attribute Access
public extension Entity {
	/// Access the attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T, TFRM: Transformer>(_ path: KeyPath<EntityType.Attributes, TransformAttribute<T, TFRM>>) -> TFRM.To {
		return attributes[keyPath: path].value
	}
	
	/// Access the attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T, TFRM: Transformer>(_ path: KeyPath<EntityType.Attributes, TransformAttribute<T, TFRM>?>) -> TFRM.To? {
		return attributes[keyPath: path]?.value
	}
	
	/// Access the attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T, TFRM: Transformer, U>(_ path: KeyPath<EntityType.Attributes, TransformAttribute<T, TFRM>?>) -> U? where TFRM.To == U? {
		return attributes[keyPath: path].flatMap { $0.value }
	}
}

// MARK: Relationship Access
public extension Entity {
	/// Access to an Id of a `ToOneRelationship`.
	/// This allows you to write `entity ~> \.other` instead
	/// of `entity.relationships.other.id`.
	public static func ~><OtherEntity: Relatable>(entity: Entity<EntityType>, path: KeyPath<EntityType.Relationships, ToOneRelationship<OtherEntity>>) -> OtherEntity.Description.Identifier {
		return entity.relationships[keyPath: path].id
	}

	/// Access to all Ids of a `ToManyRelationship`.
	/// This allows you to write `entity ~> \.others` instead
	/// of `entity.relationships.others.ids`.
	public static func ~><OtherEntity: Relatable>(entity: Entity<EntityType>, path: KeyPath<EntityType.Relationships, ToManyRelationship<OtherEntity>>) -> [OtherEntity.Description.Identifier] {
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
		
		if EntityType.Attributes.self != NoAttributes.self {
			try container.encode(attributes, forKey: .attributes)
		}
		
		if EntityType.Relationships.self != NoRelatives.self {
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
		
		attributes = try (NoAttributes() as? EntityType.Attributes) ?? container.decode(EntityType.Attributes.self, forKey: .attributes)
		
		relationships = try (NoRelatives() as? EntityType.Relationships) ?? container.decode(EntityType.Relationships.self, forKey: .relationships)
	}
}
