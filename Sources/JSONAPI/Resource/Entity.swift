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
public struct NoRelationships: Relationships {
	public static var none: NoRelationships { return .init() }
}

/// Can be used as `Attributes` Type for Entities that do not
/// have any Attributes.
public struct NoAttributes: Attributes {
	public static var none: NoAttributes { return .init() }
}

/// An `EntityDescription` describes a JSON API
/// Resource Object. The Resource Object
/// itself is encoded and decoded as an
/// `Entity`, which gets specialized on an
/// `EntityDescription`.
public protocol EntityDescription {
	associatedtype Attributes: JSONAPI.Attributes
	associatedtype Relationships: JSONAPI.Relationships
	
	static var type: String { get }
}

/// EntityProxy is a protocol that can be used to create
/// types that _act_ like Entities but cannot be encoded
/// or decoded as Entities.
public protocol EntityProxy: Equatable {
	associatedtype Description: EntityDescription
	associatedtype EntityRawIdType: JSONAPI.MaybeRawId

	typealias Id = JSONAPI.Id<EntityRawIdType, Self>

	typealias Attributes = Description.Attributes
	typealias Relationships = Description.Relationships

	/// The `Entity`'s Id. This can be of type `Unidentified` if
	/// the entity is being created clientside and the
	/// server is being asked to create a unique Id. Otherwise,
	/// this should be of a type conforming to `IdType`.
	var id: Id { get }

	/// The JSON API compliant attributes of this `Entity`.
	var attributes: Attributes { get }

	/// The JSON API compliant relationships of this `Entity`.
	var relationships: Relationships { get }
}

extension EntityProxy {
	/// The JSON API compliant "type" of this `Entity`.
	public static var type: String { return Description.type }
}

/// EntityType is the protocol that Entity conforms to. This
/// protocol lets other types accept any Entity as a generic
/// specialization.
public protocol EntityType: EntityProxy, PrimaryResource {
}

public protocol IdentifiableEntityType: EntityType, Relatable where EntityRawIdType: JSONAPI.RawIdType {}

/// An `Entity` is a single model type that can be
/// encoded to or decoded from a JSON API
/// "Resource Object."
/// See https://jsonapi.org/format/#document-resource-objects
public struct Entity<Description: JSONAPI.EntityDescription, EntityRawIdType: JSONAPI.MaybeRawId>: EntityType {
	/// The `Entity`'s Id. This can be of type `Unidentified` if
	/// the entity is being created clientside and the
	/// server is being asked to create a unique Id. Otherwise,
	/// this should be of a type conforming to `IdType`.
	public let id: Entity.Id
	
	/// The JSON API compliant attributes of this `Entity`.
	public let attributes: Description.Attributes
	
	/// The JSON API compliant relationships of this `Entity`.
	public let relationships: Description.Relationships
	
	public init(id: Entity.Id, attributes: Description.Attributes, relationships: Description.Relationships) {
		self.id = id
		self.attributes = attributes
		self.relationships = relationships
	}
}

extension Entity: IdentifiableEntityType, Relatable, WrappedRelatable where EntityRawIdType: JSONAPI.RawIdType {
	public typealias Identifier = Entity.Id
	public typealias WrappedIdentifier = Identifier
}

extension Entity: CustomStringConvertible {
	public var description: String {
		return "Entity<\(Entity.type)>(id: \(String(describing: id)), attributes: \(String(describing: attributes)), relationships: \(String(describing: relationships)))"
	}
}

// MARK: Convenience initializers
extension Entity where EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, relationships: Description.Relationships) {
		self.id = Entity.Id()
		self.attributes = attributes
		self.relationships = relationships
	}
}

extension Entity where EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, relationships: Description.Relationships) {
		self.id = .unidentified
		self.attributes = attributes
		self.relationships = relationships
	}
}

extension Entity where Description.Attributes == NoAttributes {
	public init(id: Entity.Id, relationships: Description.Relationships) {
		self.init(id: id, attributes: NoAttributes(), relationships: relationships)
	}
}

extension Entity where Description.Attributes == NoAttributes, EntityRawIdType: CreatableRawIdType {
	public init(relationships: Description.Relationships) {
		self.init(attributes: NoAttributes(), relationships: relationships)
	}
}

extension Entity where Description.Relationships == NoRelationships {
	public init(id: Entity.Id, attributes: Description.Attributes) {
		self.init(id: id, attributes: attributes, relationships: NoRelationships())
	}
}

extension Entity where Description.Relationships == NoRelationships, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes) {
		self.init(attributes: attributes, relationships: NoRelationships())
	}
}

extension Entity where Description.Relationships == NoRelationships, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes) {
		self.init(attributes: attributes, relationships: NoRelationships())
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships {
	public init(id: Entity.Id) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelationships())
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, EntityRawIdType: CreatableRawIdType {
	public init() {
		self.init(attributes: NoAttributes(), relationships: NoRelationships())
	}
}

// MARK: Pointer for Relationships use.
public extension Entity where EntityRawIdType: JSONAPI.RawIdType {
	/// Get a pointer to this entity that can be used as a
	/// relationship to another entity.
	public var pointer: ToOneRelationship<Entity> {
		return ToOneRelationship(entity: self)
	}
}

// MARK: Attribute Access
public extension EntityProxy {
	/// Access the attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T, TFRM: Transformer>(_ path: KeyPath<Description.Attributes, TransformedAttribute<T, TFRM>>) -> TFRM.To {
		return attributes[keyPath: path].value
	}

	/// Access the attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T, TFRM: Transformer>(_ path: KeyPath<Description.Attributes, TransformedAttribute<T, TFRM>?>) -> TFRM.To? {
		return attributes[keyPath: path]?.value
	}

	/// Access the attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T, TFRM: Transformer, U>(_ path: KeyPath<Description.Attributes, TransformedAttribute<T, TFRM>?>) -> U? where TFRM.To == U? {
		return attributes[keyPath: path].flatMap { $0.value }
	}
}

// MARK: Relationship Access
public extension EntityProxy {
	/// Access to an Id of a `ToOneRelationship`.
	/// This allows you to write `entity ~> \.other` instead
	/// of `entity.relationships.other.id`.
	public static func ~><OtherEntity: OptionalRelatable>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity>>) -> OtherEntity.WrappedIdentifier {
		return entity.relationships[keyPath: path].id
	}

	/// Access to all Ids of a `ToManyRelationship`.
	/// This allows you to write `entity ~> \.others` instead
	/// of `entity.relationships.others.ids`.
	public static func ~><OtherEntity: Relatable>(entity: Self, path: KeyPath<Description.Relationships, ToManyRelationship<OtherEntity>>) -> [OtherEntity.Identifier] {
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
		
		if EntityRawIdType.self != Unidentified.self {
			try container.encode(id, forKey: .id)
		}
		
		if Description.Attributes.self != NoAttributes.self {
			try container.encode(attributes, forKey: .attributes)
		}
		
		if Description.Relationships.self != NoRelationships.self {
			try container.encode(relationships, forKey: .relationships)
		}
	}

	public init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: ResourceObjectCodingKeys.self)
		
		let type = try container.decode(String.self, forKey: .type)
		
		guard Entity.type == type else {
			throw JSONAPIEncodingError.typeMismatch(expected: Description.type, found: type)
		}

		let maybeUnidentified = Unidentified() as? EntityRawIdType
		id = try maybeUnidentified.map { Entity.Id(rawValue: $0) } ?? container.decode(Entity.Id.self, forKey: .id)
		
		attributes = try (NoAttributes() as? Description.Attributes) ?? container.decode(Description.Attributes.self, forKey: .attributes)
		
		relationships = try (NoRelationships() as? Description.Relationships) ?? container.decode(Description.Relationships.self, forKey: .relationships)
	}
}
