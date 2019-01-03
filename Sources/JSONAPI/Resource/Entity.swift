//
//  Entity.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 7/24/18.
//

/// A JSON API structure within an Entity that contains
/// named properties of types `ToOneRelationship` and
/// `ToManyRelationship`.
public protocol Relationships: Codable & Equatable {}

/// A JSON API structure within an Entity that contains
/// properties of any types that are JSON encodable.
public protocol Attributes: Codable & Equatable {}

/// Can be used as `Relationships` Type for Entities that do not
/// have any Relationships.
public struct NoRelationships: Relationships {
	public static var none: NoRelationships { return .init() }
}

extension NoRelationships: CustomStringConvertible {
	public var description: String { return "No Relationships" }
}

/// Can be used as `Attributes` Type for Entities that do not
/// have any Attributes.
public struct NoAttributes: Attributes {
	public static var none: NoAttributes { return .init() }
}

extension NoAttributes: CustomStringConvertible {
	public var description: String { return "No Attributes" }
}

/// Something that is JSONTyped provides a String representation
/// of its type.
public protocol JSONTyped {
	static var jsonType: String { get }
}

/// An `EntityProxyDescription` is an `EntityDescription`
/// without Codable conformance.
public protocol EntityProxyDescription: JSONTyped {
	associatedtype Attributes: Equatable
	associatedtype Relationships: Equatable
}

/// An `EntityDescription` describes a JSON API
/// Resource Object. The Resource Object
/// itself is encoded and decoded as an
/// `Entity`, which gets specialized on an
/// `EntityDescription`.
public protocol EntityDescription: EntityProxyDescription where Attributes: JSONAPI.Attributes, Relationships: JSONAPI.Relationships {}

/// EntityProxy is a protocol that can be used to create
/// types that _act_ like Entities but cannot be encoded
/// or decoded as Entities.
public protocol EntityProxy: Equatable, JSONTyped {
	associatedtype Description: EntityProxyDescription
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
	public static var jsonType: String { return Description.jsonType }
}

/// EntityType is the protocol that Entity conforms to. This
/// protocol lets other types accept any Entity as a generic
/// specialization.
public protocol EntityType: EntityProxy, PrimaryResource where Description: EntityDescription {
	associatedtype Meta: JSONAPI.Meta
	associatedtype Links: JSONAPI.Links
}

public protocol IdentifiableEntityType: EntityType, Relatable where EntityRawIdType: JSONAPI.RawIdType {}

/// An `Entity` is a single model type that can be
/// encoded to or decoded from a JSON API
/// "Resource Object."
/// See https://jsonapi.org/format/#document-resource-objects
public struct Entity<Description: JSONAPI.EntityDescription, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links, EntityRawIdType: JSONAPI.MaybeRawId>: EntityType {

	public typealias Meta = MetaType
	public typealias Links = LinksType

	/// The `Entity`'s Id. This can be of type `Unidentified` if
	/// the entity is being created clientside and the
	/// server is being asked to create a unique Id. Otherwise,
	/// this should be of a type conforming to `IdType`.
	public let id: Entity.Id
	
	/// The JSON API compliant attributes of this `Entity`.
	public let attributes: Description.Attributes
	
	/// The JSON API compliant relationships of this `Entity`.
	public let relationships: Description.Relationships

	/// Any additional metadata packaged with the entity.
	public let meta: MetaType

	/// Links related to the entity.
	public let links: LinksType
	
	public init(id: Entity.Id, attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.id = id
		self.attributes = attributes
		self.relationships = relationships
		self.meta = meta
		self.links = links
	}
}

extension Entity: Identifiable, IdentifiableEntityType, Relatable where EntityRawIdType: JSONAPI.RawIdType {
	public typealias Identifier = Entity.Id
}

extension Entity: CustomStringConvertible {
	public var description: String {
		return "Entity<\(Entity.jsonType)>(id: \(String(describing: id)), attributes: \(String(describing: attributes)), relationships: \(String(describing: relationships)))"
	}
}

// MARK: Convenience initializers
extension Entity where EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.id = Entity.Id()
		self.attributes = attributes
		self.relationships = relationships
		self.meta = meta
		self.links = links
	}
}

extension Entity where EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.id = .unidentified
		self.attributes = attributes
		self.relationships = relationships
		self.meta = meta
		self.links = links
	}
}

/*
extension Entity where Description.Attributes == NoAttributes {
	public init(id: Entity.Id, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.init(id: id, attributes: NoAttributes(), relationships: relationships, meta: meta, links: links)
	}
}

extension Entity where Description.Attributes == NoAttributes, MetaType == NoMetadata {
	public init(id: Entity.Id, relationships: Description.Relationships, links: LinksType) {
		self.init(id: id, relationships: relationships, meta: .none, links: links)
	}
}

extension Entity where Description.Attributes == NoAttributes, LinksType == NoLinks {
	public init(id: Entity.Id, relationships: Description.Relationships, meta: MetaType) {
		self.init(id: id, relationships: relationships, meta: meta, links: .none)
	}
}

extension Entity where Description.Attributes == NoAttributes, MetaType == NoMetadata, LinksType == NoLinks {
	public init(id: Entity.Id, relationships: Description.Relationships) {
		self.init(id: id, relationships: relationships, links: .none)
	}
}

extension Entity where Description.Attributes == NoAttributes, EntityRawIdType: CreatableRawIdType {
	public init(relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: meta, links: links)
	}
}

extension Entity where Description.Attributes == NoAttributes, MetaType == NoMetadata, EntityRawIdType: CreatableRawIdType {
	public init(relationships: Description.Relationships, links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: .none, links: links)
	}
}

extension Entity where Description.Attributes == NoAttributes, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(relationships: Description.Relationships, meta: MetaType) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: meta, links: .none)
	}
}

extension Entity where Description.Attributes == NoAttributes, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(relationships: Description.Relationships) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: .none, links: .none)
	}
}

extension Entity where Description.Attributes == NoAttributes, EntityRawIdType == Unidentified {
	public init(relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: meta, links: links)
	}
}

extension Entity where Description.Relationships == NoRelationships {
	public init(id: Entity.Id, attributes: Description.Attributes, meta: MetaType, links: LinksType) {
		self.init(id: id, attributes: attributes, relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension Entity where Description.Relationships == NoRelationships, MetaType == NoMetadata {
	public init(id: Entity.Id, attributes: Description.Attributes, links: LinksType) {
		self.init(id: id, attributes: attributes, meta: .none, links: links)
	}
}

extension Entity where Description.Relationships == NoRelationships, LinksType == NoLinks {
	public init(id: Entity.Id, attributes: Description.Attributes, meta: MetaType) {
		self.init(id: id, attributes: attributes, meta: meta, links: .none)
	}
}

extension Entity where Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks {
	public init(id: Entity.Id, attributes: Description.Attributes) {
		self.init(id: id, attributes: attributes, meta: .none, links: .none)
	}
}

extension Entity where Description.Relationships == NoRelationships, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, meta: MetaType, links: LinksType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension Entity where Description.Relationships == NoRelationships, MetaType == NoMetadata, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, links: LinksType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: .none, links: links)
	}
}

extension Entity where Description.Relationships == NoRelationships, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, meta: MetaType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: meta, links: .none)
	}
}

extension Entity where Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: .none, links: .none)
	}
}

extension Entity where Description.Relationships == NoRelationships, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, meta: MetaType, links: LinksType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension Entity where Description.Relationships == NoRelationships, MetaType == NoMetadata, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, links: LinksType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: .none, links: links)
	}
}

extension Entity where Description.Relationships == NoRelationships, LinksType == NoLinks, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, meta: MetaType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: meta, links: .none)
	}
}

extension Entity where Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: .none, links: .none)
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships {
	public init(id: Entity.Id, meta: MetaType, links: LinksType) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, MetaType == NoMetadata {
	public init(id: Entity.Id, links: LinksType) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelationships(), meta: .none, links: links)
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, LinksType == NoLinks {
	public init(id: Entity.Id, meta: MetaType) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelationships(), meta: meta, links: .none)
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks {
	public init(id: Entity.Id) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelationships(), meta: .none, links: .none)
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, EntityRawIdType: CreatableRawIdType {
	public init(meta: MetaType, links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, MetaType == NoMetadata, EntityRawIdType: CreatableRawIdType {
	public init(links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: NoRelationships(), meta: .none, links: links)
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(meta: MetaType) {
		self.init(attributes: NoAttributes(), relationships: NoRelationships(), meta: meta, links: .none)
	}
}

extension Entity where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init() {
		self.init(attributes: NoAttributes(), relationships: NoRelationships(), meta: .none, links: .none)
	}
}

extension Entity where MetaType == NoMetadata {
	public init(id: Entity.Id, attributes: Description.Attributes, relationships: Description.Relationships, links: LinksType) {
		self.init(id: id, attributes: attributes, relationships: relationships, meta: .none, links: links)
	}
}

extension Entity where MetaType == NoMetadata, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, links: LinksType) {
		self.init(attributes: attributes, relationships: relationships, meta: .none, links: links)
	}
}

extension Entity where MetaType == NoMetadata, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, links: LinksType) {
		self.init(attributes: attributes, relationships: relationships, meta: .none, links: links)
	}
}

extension Entity where LinksType == NoLinks {
	public init(id: Entity.Id, attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType) {
		self.init(id: id, attributes: attributes, relationships: relationships, meta: meta, links: .none)
	}
}

extension Entity where LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType) {
		self.init(attributes: attributes, relationships: relationships, meta: meta, links: .none)
	}
}

extension Entity where LinksType == NoLinks, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType) {
		self.init(attributes: attributes, relationships: relationships, meta: meta, links: .none)
	}
}

extension Entity where MetaType == NoMetadata, LinksType == NoLinks {
	public init(id: Entity.Id, attributes: Description.Attributes, relationships: Description.Relationships) {
		self.init(id: id, attributes: attributes, relationships: relationships, meta: .none, links: .none)
	}
}

extension Entity where MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, relationships: Description.Relationships) {
		self.init(attributes: attributes, relationships: relationships, meta: .none, links: .none)
	}
}

extension Entity where MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, relationships: Description.Relationships) {
		self.init(attributes: attributes, relationships: relationships, meta: .none, links: .none)
	}
}
*/

// MARK: Pointer for Relationships use.
public extension Entity where EntityRawIdType: JSONAPI.RawIdType {

	/// An Entity.Pointer is a `ToOneRelationship` with no metadata or links.
	/// This is just a convenient way to reference an Entity so that
	/// other Entities' Relationships can be built up from it.
	public typealias Pointer = ToOneRelationship<Entity, NoMetadata, NoLinks>

	/// Entity.Pointers is a `ToManyRelationship` with no metadata or links.
	/// This is just a convenient way to reference a bunch of Entities so
	/// that other Entities' Relationships can be built up from them.
	public typealias Pointers = ToManyRelationship<Entity, NoMetadata, NoLinks>

	/// Get a pointer to this entity that can be used as a
	/// relationship to another entity.
	public var pointer: Pointer {
		return Pointer(entity: self)
	}

	public func pointer<MType: JSONAPI.Meta, LType: JSONAPI.Links>(withMeta meta: MType, links: LType) -> ToOneRelationship<Entity, MType, LType> {
		return ToOneRelationship(entity: self, meta: meta, links: links)
	}
}

// MARK: Identifying Unidentified Entities
public extension Entity where EntityRawIdType == Unidentified {
	/// Create a new Entity from this one with a newly created
	/// unique Id of the given type.
	public func identified<RawIdType: CreatableRawIdType>(byType: RawIdType.Type) -> Entity<Description, MetaType, LinksType, RawIdType> {
		return .init(attributes: attributes, relationships: relationships, meta: meta, links: links)
	}

	/// Create a new Entity from this one with the given Id.
	public func identified<RawIdType: JSONAPI.RawIdType>(by id: RawIdType) -> Entity<Description, MetaType, LinksType, RawIdType> {
		return .init(id: Entity<Description, MetaType, LinksType, RawIdType>.Identifier(rawValue: id), attributes: attributes, relationships: relationships, meta: meta, links: links)
	}
}

public extension Entity where EntityRawIdType: CreatableRawIdType {
	/// Create a copy of this Entity with a new unique Id.
	public func withNewIdentifier() -> Entity {
		return Entity(attributes: attributes, relationships: relationships, meta: meta, links: links)
	}
}

// MARK: Attribute Access
public extension EntityProxy {
	/// Access the attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T: AttributeType>(_ path: KeyPath<Description.Attributes, T>) -> T.ValueType {
		return attributes[keyPath: path].value
	}

	/// Access the attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T: AttributeType>(_ path: KeyPath<Description.Attributes, T?>) -> T.ValueType? {
		return attributes[keyPath: path]?.value
	}

	/// Access the attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T: AttributeType, U>(_ path: KeyPath<Description.Attributes, T?>) -> U? where T.ValueType == U? {
		// Implementation Note: Handles Transform that returns optional
		// type.
		return attributes[keyPath: path].flatMap { $0.value }
	}

	/// Access the computed attribute at the given keypath. This just
	/// allows you to write `entity[\.propertyName]` instead
	/// of `entity.relationships.propertyName`.
	subscript<T>(_ path: KeyPath<Description.Attributes, T>) -> T {
		// Implementation Note: Handles attributes that are not
		// AttributeType. These should only exist as computed properties.
		return attributes[keyPath: path]
	}
}

// MARK: Relationship Access
public extension EntityProxy {
	/// Access to an Id of a `ToOneRelationship`.
	/// This allows you to write `entity ~> \.other` instead
	/// of `entity.relationships.other.id`.
	public static func ~><OtherEntity: Identifiable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity, MType, LType>>) -> OtherEntity.Identifier {
		return entity.relationships[keyPath: path].id
	}

	/// Access to an Id of an optional `ToOneRelationship`.
	/// This allows you to write `entity ~> \.other` instead
	/// of `entity.relationships.other?.id`.
	public static func ~><OtherEntity: OptionalRelatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity, MType, LType>?>) -> OtherEntity.Identifier {
		// Implementation Note: This signature applies to `ToOneRelationship<E?, _, _>?`
		// whereas the one below applies to `ToOneRelationship<E, _, _>?`
		return entity.relationships[keyPath: path]?.id
	}

	/// Access to an Id of an optional `ToOneRelationship`.
	/// This allows you to write `entity ~> \.other` instead
	/// of `entity.relationships.other?.id`.
	public static func ~><OtherEntity: Relatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity, MType, LType>?>) -> OtherEntity.Identifier? {
		// Implementation Note: This signature applies to `ToOneRelationship<E, _, _>?`
		// whereas the one above applies to `ToOneRelationship<E?, _, _>?`
		return entity.relationships[keyPath: path]?.id
	}

	/// Access to all Ids of a `ToManyRelationship`.
	/// This allows you to write `entity ~> \.others` instead
	/// of `entity.relationships.others.ids`.
	public static func ~><OtherEntity: Relatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToManyRelationship<OtherEntity, MType, LType>>) -> [OtherEntity.Identifier] {
		return entity.relationships[keyPath: path].ids
	}

	/// Access to all Ids of an optional `ToManyRelationship`.
	/// This allows you to write `entity ~> \.others` instead
	/// of `entity.relationships.others?.ids`.
	public static func ~><OtherEntity: Relatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToManyRelationship<OtherEntity, MType, LType>?>) -> [OtherEntity.Identifier]? {
		return entity.relationships[keyPath: path]?.ids
	}
}

infix operator ~>

// MARK: - Codable
private enum ResourceObjectCodingKeys: String, CodingKey {
	case type = "type"
	case id = "id"
	case attributes = "attributes"
	case relationships = "relationships"
	case meta = "meta"
	case links = "links"
}

public extension Entity {
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ResourceObjectCodingKeys.self)
		
		try container.encode(Entity.jsonType, forKey: .type)
		
		if EntityRawIdType.self != Unidentified.self {
			try container.encode(id, forKey: .id)
		}
		
		if Description.Attributes.self != NoAttributes.self {
			try container.encode(attributes, forKey: .attributes)
		}
		
		if Description.Relationships.self != NoRelationships.self {
			try container.encode(relationships, forKey: .relationships)
		}

		if MetaType.self != NoMetadata.self {
			try container.encode(meta, forKey: .meta)
		}

		if LinksType.self != NoLinks.self {
			try container.encode(links, forKey: .links)
		}
	}

	public init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: ResourceObjectCodingKeys.self)
		
		let type = try container.decode(String.self, forKey: .type)
		
		guard Entity.jsonType == type else {
			throw JSONAPIEncodingError.typeMismatch(expected: Description.jsonType, found: type)
		}

		let maybeUnidentified = Unidentified() as? EntityRawIdType
		id = try maybeUnidentified.map { Entity.Id(rawValue: $0) } ?? container.decode(Entity.Id.self, forKey: .id)

		attributes = try (NoAttributes() as? Description.Attributes) ??
			container.decode(Description.Attributes.self, forKey: .attributes)

		relationships = try (NoRelationships() as? Description.Relationships) ?? container.decode(Description.Relationships.self, forKey: .relationships)

		meta = try (NoMetadata() as? MetaType) ?? container.decode(MetaType.self, forKey: .meta)

		links = try (NoLinks() as? LinksType) ?? container.decode(LinksType.self, forKey: .links)
	}
}
