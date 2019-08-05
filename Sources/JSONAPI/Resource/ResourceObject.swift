//
//  ResourceObject.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 7/24/18.
//


/// A JSON API structure within an ResourceObject that contains
/// named properties of types `ToOneRelationship` and
/// `ToManyRelationship`.
public protocol Relationships: Codable & Equatable {}

/// A JSON API structure within an ResourceObject that contains
/// properties of any types that are JSON encodable.
public protocol Attributes: Codable & Equatable {}

/// Attributes containing publicly accessible and `Equatable`
/// CodingKeys are required to support Sparse Fieldsets.
public protocol SparsableAttributes: Attributes {
    associatedtype CodingKeys: CodingKey & Equatable
}

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

/// A `ResourceObjectProxyDescription` is an `ResourceObjectDescription`
/// without Codable conformance.
public protocol ResourceObjectProxyDescription: JSONTyped {
	associatedtype Attributes: Equatable
	associatedtype Relationships: Equatable
}

/// A `ResourceObjectDescription` describes a JSON API
/// Resource Object. The Resource Object
/// itself is encoded and decoded as an
/// `ResourceObject`, which gets specialized on an
/// `ResourceObjectDescription`.
public protocol ResourceObjectDescription: ResourceObjectProxyDescription where Attributes: JSONAPI.Attributes, Relationships: JSONAPI.Relationships {}

/// ResourceObjectProxy is a protocol that can be used to create
/// types that _act_ like Entities but cannot be encoded
/// or decoded as Entities.
public protocol ResourceObjectProxy: Equatable, JSONTyped {
	associatedtype Description: ResourceObjectProxyDescription
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

extension ResourceObjectProxy {
	/// The JSON API compliant "type" of this `Entity`.
	public static var jsonType: String { return Description.jsonType }
}

/// ResourceObjectType is the protocol that ResourceObject conforms to. This
/// protocol lets other types accept any ResourceObject as a generic
/// specialization.
public protocol ResourceObjectType: ResourceObjectProxy, PrimaryResource where Description: ResourceObjectDescription {
	associatedtype Meta: JSONAPI.Meta
	associatedtype Links: JSONAPI.Links
}

public protocol IdentifiableResourceObjectType: ResourceObjectType, Relatable where EntityRawIdType: JSONAPI.RawIdType {}

/// An `ResourceObject` is a single model type that can be
/// encoded to or decoded from a JSON API
/// "Resource Object."
/// See https://jsonapi.org/format/#document-resource-objects
public struct ResourceObject<Description: JSONAPI.ResourceObjectDescription, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links, EntityRawIdType: JSONAPI.MaybeRawId>: ResourceObjectType {

	public typealias Meta = MetaType
	public typealias Links = LinksType

	/// The `ResourceObject`'s Id. This can be of type `Unidentified` if
	/// the entity is being created clientside and the
	/// server is being asked to create a unique Id. Otherwise,
	/// this should be of a type conforming to `IdType`.
	public let id: ResourceObject.Id
	
	/// The JSON API compliant attributes of this `ResourceObject`.
	public let attributes: Description.Attributes
	
	/// The JSON API compliant relationships of this `ResourceObject`.
	public let relationships: Description.Relationships

	/// Any additional metadata packaged with the entity.
	public let meta: MetaType

	/// Links related to the entity.
	public let links: LinksType
	
	public init(id: ResourceObject.Id, attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.id = id
		self.attributes = attributes
		self.relationships = relationships
		self.meta = meta
		self.links = links
	}
}

extension ResourceObject: Identifiable, IdentifiableResourceObjectType, Relatable where EntityRawIdType: JSONAPI.RawIdType {
	public typealias Identifier = ResourceObject.Id
}

extension ResourceObject: CustomStringConvertible {
	public var description: String {
		return "ResourceObject<\(ResourceObject.jsonType)>(id: \(String(describing: id)), attributes: \(String(describing: attributes)), relationships: \(String(describing: relationships)))"
	}
}

// MARK: Convenience initializers
extension ResourceObject where EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.id = ResourceObject.Id()
		self.attributes = attributes
		self.relationships = relationships
		self.meta = meta
		self.links = links
	}
}

extension ResourceObject where EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.id = .unidentified
		self.attributes = attributes
		self.relationships = relationships
		self.meta = meta
		self.links = links
	}
}

/*
extension ResourceObject where Description.Attributes == NoAttributes {
	public init(id: ResourceObject.Id, relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.init(id: id, attributes: NoAttributes(), relationships: relationships, meta: meta, links: links)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, MetaType == NoMetadata {
	public init(id: ResourceObject.Id, relationships: Description.Relationships, links: LinksType) {
		self.init(id: id, relationships: relationships, meta: .none, links: links)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, LinksType == NoLinks {
	public init(id: ResourceObject.Id, relationships: Description.Relationships, meta: MetaType) {
		self.init(id: id, relationships: relationships, meta: meta, links: .none)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, MetaType == NoMetadata, LinksType == NoLinks {
	public init(id: ResourceObject.Id, relationships: Description.Relationships) {
		self.init(id: id, relationships: relationships, links: .none)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, EntityRawIdType: CreatableRawIdType {
	public init(relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: meta, links: links)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, MetaType == NoMetadata, EntityRawIdType: CreatableRawIdType {
	public init(relationships: Description.Relationships, links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: .none, links: links)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(relationships: Description.Relationships, meta: MetaType) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: meta, links: .none)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(relationships: Description.Relationships) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: .none, links: .none)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, EntityRawIdType == Unidentified {
	public init(relationships: Description.Relationships, meta: MetaType, links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: relationships, meta: meta, links: links)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships {
	public init(id: ResourceObject.Id, attributes: Description.Attributes, meta: MetaType, links: LinksType) {
		self.init(id: id, attributes: attributes, relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, MetaType == NoMetadata {
	public init(id: ResourceObject.Id, attributes: Description.Attributes, links: LinksType) {
		self.init(id: id, attributes: attributes, meta: .none, links: links)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, LinksType == NoLinks {
	public init(id: ResourceObject.Id, attributes: Description.Attributes, meta: MetaType) {
		self.init(id: id, attributes: attributes, meta: meta, links: .none)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks {
	public init(id: ResourceObject.Id, attributes: Description.Attributes) {
		self.init(id: id, attributes: attributes, meta: .none, links: .none)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, meta: MetaType, links: LinksType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, MetaType == NoMetadata, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, links: LinksType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: .none, links: links)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, meta: MetaType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: meta, links: .none)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: .none, links: .none)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, meta: MetaType, links: LinksType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, MetaType == NoMetadata, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, links: LinksType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: .none, links: links)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, LinksType == NoLinks, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, meta: MetaType) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: meta, links: .none)
	}
}

extension ResourceObject where Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes) {
		self.init(attributes: attributes, relationships: NoRelationships(), meta: .none, links: .none)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships {
	public init(id: ResourceObject.Id, meta: MetaType, links: LinksType) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, MetaType == NoMetadata {
	public init(id: ResourceObject.Id, links: LinksType) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelationships(), meta: .none, links: links)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, LinksType == NoLinks {
	public init(id: ResourceObject.Id, meta: MetaType) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelationships(), meta: meta, links: .none)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks {
	public init(id: ResourceObject.Id) {
		self.init(id: id, attributes: NoAttributes(), relationships: NoRelationships(), meta: .none, links: .none)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, EntityRawIdType: CreatableRawIdType {
	public init(meta: MetaType, links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: NoRelationships(), meta: meta, links: links)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, MetaType == NoMetadata, EntityRawIdType: CreatableRawIdType {
	public init(links: LinksType) {
		self.init(attributes: NoAttributes(), relationships: NoRelationships(), meta: .none, links: links)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(meta: MetaType) {
		self.init(attributes: NoAttributes(), relationships: NoRelationships(), meta: meta, links: .none)
	}
}

extension ResourceObject where Description.Attributes == NoAttributes, Description.Relationships == NoRelationships, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init() {
		self.init(attributes: NoAttributes(), relationships: NoRelationships(), meta: .none, links: .none)
	}
}

extension ResourceObject where MetaType == NoMetadata {
	public init(id: ResourceObject.Id, attributes: Description.Attributes, relationships: Description.Relationships, links: LinksType) {
		self.init(id: id, attributes: attributes, relationships: relationships, meta: .none, links: links)
	}
}

extension ResourceObject where MetaType == NoMetadata, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, links: LinksType) {
		self.init(attributes: attributes, relationships: relationships, meta: .none, links: links)
	}
}

extension ResourceObject where MetaType == NoMetadata, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, links: LinksType) {
		self.init(attributes: attributes, relationships: relationships, meta: .none, links: links)
	}
}

extension ResourceObject where LinksType == NoLinks {
	public init(id: ResourceObject.Id, attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType) {
		self.init(id: id, attributes: attributes, relationships: relationships, meta: meta, links: .none)
	}
}

extension ResourceObject where LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType) {
		self.init(attributes: attributes, relationships: relationships, meta: meta, links: .none)
	}
}

extension ResourceObject where LinksType == NoLinks, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, relationships: Description.Relationships, meta: MetaType) {
		self.init(attributes: attributes, relationships: relationships, meta: meta, links: .none)
	}
}

extension ResourceObject where MetaType == NoMetadata, LinksType == NoLinks {
	public init(id: ResourceObject.Id, attributes: Description.Attributes, relationships: Description.Relationships) {
		self.init(id: id, attributes: attributes, relationships: relationships, meta: .none, links: .none)
	}
}

extension ResourceObject where MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType: CreatableRawIdType {
	public init(attributes: Description.Attributes, relationships: Description.Relationships) {
		self.init(attributes: attributes, relationships: relationships, meta: .none, links: .none)
	}
}

extension ResourceObject where MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType == Unidentified {
	public init(attributes: Description.Attributes, relationships: Description.Relationships) {
		self.init(attributes: attributes, relationships: relationships, meta: .none, links: .none)
	}
}
*/

// MARK: Pointer for Relationships use.
public extension ResourceObject where EntityRawIdType: JSONAPI.RawIdType {

	/// An ResourceObject.Pointer is a `ToOneRelationship` with no metadata or links.
	/// This is just a convenient way to reference an ResourceObject so that
	/// other Entities' Relationships can be built up from it.
	typealias Pointer = ToOneRelationship<ResourceObject, NoMetadata, NoLinks>

	/// ResourceObject.Pointers is a `ToManyRelationship` with no metadata or links.
	/// This is just a convenient way to reference a bunch of Entities so
	/// that other Entities' Relationships can be built up from them.
	typealias Pointers = ToManyRelationship<ResourceObject, NoMetadata, NoLinks>

	/// Get a pointer to this resource object that can be used as a
	/// relationship to another resource object.
	var pointer: Pointer {
		return Pointer(resourceObject: self)
	}

	func pointer<MType: JSONAPI.Meta, LType: JSONAPI.Links>(withMeta meta: MType, links: LType) -> ToOneRelationship<ResourceObject, MType, LType> {
		return ToOneRelationship(resourceObject: self, meta: meta, links: links)
	}
}

// MARK: Identifying Unidentified Entities
public extension ResourceObject where EntityRawIdType == Unidentified {
	/// Create a new ResourceObject from this one with a newly created
	/// unique Id of the given type.
	func identified<RawIdType: CreatableRawIdType>(byType: RawIdType.Type) -> ResourceObject<Description, MetaType, LinksType, RawIdType> {
		return .init(attributes: attributes, relationships: relationships, meta: meta, links: links)
	}

	/// Create a new ResourceObject from this one with the given Id.
	func identified<RawIdType: JSONAPI.RawIdType>(by id: RawIdType) -> ResourceObject<Description, MetaType, LinksType, RawIdType> {
		return .init(id: ResourceObject<Description, MetaType, LinksType, RawIdType>.Identifier(rawValue: id), attributes: attributes, relationships: relationships, meta: meta, links: links)
	}
}

public extension ResourceObject where EntityRawIdType: CreatableRawIdType {
	/// Create a copy of this ResourceObject with a new unique Id.
	func withNewIdentifier() -> ResourceObject {
		return ResourceObject(attributes: attributes, relationships: relationships, meta: meta, links: links)
	}
}

// MARK: Attribute Access
public extension ResourceObjectProxy {
	/// Access the attribute at the given keypath. This just
	/// allows you to write `resourceObject[\.propertyName]` instead
	/// of `resourceObject.attributes.propertyName`.
	subscript<T: AttributeType>(_ path: KeyPath<Description.Attributes, T>) -> T.ValueType {
		return attributes[keyPath: path].value
	}

	/// Access the attribute at the given keypath. This just
	/// allows you to write `resourceObject[\.propertyName]` instead
	/// of `resourceObject.attributes.propertyName`.
	subscript<T: AttributeType>(_ path: KeyPath<Description.Attributes, T?>) -> T.ValueType? {
		return attributes[keyPath: path]?.value
	}

	/// Access the attribute at the given keypath. This just
	/// allows you to write `resourceObject[\.propertyName]` instead
	/// of `resourceObject.attributes.propertyName`.
	subscript<T: AttributeType, U>(_ path: KeyPath<Description.Attributes, T?>) -> U? where T.ValueType == U? {
		// Implementation Note: Handles Transform that returns optional
		// type.
		return attributes[keyPath: path].flatMap { $0.value }
	}

	/// Access the storage of the attribute at the given keypath. This just
    /// allows you to write `resourceObject[direct: \.propertyName]` instead
	/// of `resourceObject.attributes.propertyName`.
    /// Most of the subscripts dig into an `AttributeType`. This subscript
    /// returns the `AttributeType` (or another type, if you are accessing
    /// an attribute that is not stored in an `AttributeType`).
	subscript<T>(direct path: KeyPath<Description.Attributes, T>) -> T {
		// Implementation Note: Handles attributes that are not
		// AttributeType. These should only exist as computed properties.
		return attributes[keyPath: path]
	}
}

// MARK: Meta-Attribute Access
public extension ResourceObjectProxy {
	/// Access an attribute requiring a transformation on the RawValue _and_
	/// a secondary transformation on this entity (self).
	subscript<T>(_ path: KeyPath<Description.Attributes, (Self) -> T>) -> T {
		return attributes[keyPath: path](self)
	}
}

// MARK: Relationship Access
public extension ResourceObjectProxy {
	/// Access to an Id of a `ToOneRelationship`.
	/// This allows you to write `resourceObject ~> \.other` instead
	/// of `resourceObject.relationships.other.id`.
	static func ~><OtherEntity: Identifiable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity, MType, LType>>) -> OtherEntity.Identifier {
		return entity.relationships[keyPath: path].id
	}

	/// Access to an Id of an optional `ToOneRelationship`.
	/// This allows you to write `resourceObject ~> \.other` instead
	/// of `resourceObject.relationships.other?.id`.
	static func ~><OtherEntity: OptionalRelatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity, MType, LType>?>) -> OtherEntity.Identifier {
		// Implementation Note: This signature applies to `ToOneRelationship<E?, _, _>?`
		// whereas the one below applies to `ToOneRelationship<E, _, _>?`
		return entity.relationships[keyPath: path]?.id
	}

	/// Access to an Id of an optional `ToOneRelationship`.
	/// This allows you to write `resourceObject ~> \.other` instead
	/// of `resourceObject.relationships.other?.id`.
	static func ~><OtherEntity: Relatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToOneRelationship<OtherEntity, MType, LType>?>) -> OtherEntity.Identifier? {
		// Implementation Note: This signature applies to `ToOneRelationship<E, _, _>?`
		// whereas the one above applies to `ToOneRelationship<E?, _, _>?`
		return entity.relationships[keyPath: path]?.id
	}

	/// Access to all Ids of a `ToManyRelationship`.
	/// This allows you to write `resourceObject ~> \.others` instead
	/// of `resourceObject.relationships.others.ids`.
	static func ~><OtherEntity: Relatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToManyRelationship<OtherEntity, MType, LType>>) -> [OtherEntity.Identifier] {
		return entity.relationships[keyPath: path].ids
	}

	/// Access to all Ids of an optional `ToManyRelationship`.
	/// This allows you to write `resourceObject ~> \.others` instead
	/// of `resourceObject.relationships.others?.ids`.
	static func ~><OtherEntity: Relatable, MType: JSONAPI.Meta, LType: JSONAPI.Links>(entity: Self, path: KeyPath<Description.Relationships, ToManyRelationship<OtherEntity, MType, LType>?>) -> [OtherEntity.Identifier]? {
		return entity.relationships[keyPath: path]?.ids
	}
}

// MARK: Meta-Relationship Access
public extension ResourceObjectProxy {
	/// Access to an Id of a `ToOneRelationship`.
	/// This allows you to write `resourceObject ~> \.other` instead
	/// of `resourceObject.relationships.other.id`.
	static func ~><Identifier: IdType>(entity: Self, path: KeyPath<Description.Relationships, (Self) -> Identifier>) -> Identifier {
		return entity.relationships[keyPath: path](entity)
	}

	/// Access to all Ids of a `ToManyRelationship`.
	/// This allows you to write `resourceObject ~> \.others` instead
	/// of `resourceObject.relationships.others.ids`.
	static func ~><Identifier: IdType>(entity: Self, path: KeyPath<Description.Relationships, (Self) -> [Identifier]>) -> [Identifier] {
		return entity.relationships[keyPath: path](entity)
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

public extension ResourceObject {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ResourceObjectCodingKeys.self)

        try container.encode(ResourceObject.jsonType, forKey: .type)

        if EntityRawIdType.self != Unidentified.self {
            try container.encode(id, forKey: .id)
        }

        if Description.Attributes.self != NoAttributes.self {
            let nestedEncoder = container.superEncoder(forKey: .attributes)
            try attributes.encode(to: nestedEncoder)
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

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ResourceObjectCodingKeys.self)

        let type = try container.decode(String.self, forKey: .type)

        guard ResourceObject.jsonType == type else {
            throw JSONAPIEncodingError.typeMismatch(expected: Description.jsonType, found: type)
        }

        let maybeUnidentified = Unidentified() as? EntityRawIdType
        id = try maybeUnidentified.map { ResourceObject.Id(rawValue: $0) } ?? container.decode(ResourceObject.Id.self, forKey: .id)

        attributes = try (NoAttributes() as? Description.Attributes) ??
            container.decode(Description.Attributes.self, forKey: .attributes)

        relationships = try (NoRelationships() as? Description.Relationships)
            ?? container.decodeIfPresent(Description.Relationships.self, forKey: .relationships)
            ?? Description.Relationships(from: EmptyObjectDecoder())

        meta = try (NoMetadata() as? MetaType) ?? container.decode(MetaType.self, forKey: .meta)

        links = try (NoLinks() as? LinksType) ?? container.decode(LinksType.self, forKey: .links)
    }
}
