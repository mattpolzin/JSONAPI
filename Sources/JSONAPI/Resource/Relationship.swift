//
//  Relationship.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 8/31/18.
//

public protocol RelationshipType: Codable {
	associatedtype LinksType
	associatedtype MetaType

	var links: LinksType { get }
	var meta: MetaType { get }
}

/// An Entity relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `One<EntityDescription>`
public struct ToOneRelationship<OptionalRelatable: JSONAPI.OptionalRelatable, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>: RelationshipType, Equatable {

	public let id: OptionalRelatable.WrappedId

	public let meta: MetaType
	public let links: LinksType

	public init(id: OptionalRelatable.WrappedId, meta: MetaType, links: LinksType) {
		self.id = id
		self.meta = meta
		self.links = links
	}
}

extension ToOneRelationship where MetaType == NoMetadata, LinksType == NoLinks {
	public init(id: OptionalRelatable.WrappedId) {
		self.init(id: id, meta: .none, links: .none)
	}
}

extension ToOneRelationship {
	public init<E: EntityType>(entity: E, meta: MetaType, links: LinksType) where E.Id == OptionalRelatable.WrappedId {
		self.init(id: entity.id, meta: meta, links: links)
	}
}

extension ToOneRelationship where MetaType == NoMetadata, LinksType == NoLinks {
	public init<E: EntityType>(entity: E) where E.Id == OptionalRelatable.WrappedId {
		self.init(id: entity.id, meta: .none, links: .none)
	}
}

extension ToOneRelationship where OptionalRelatable.WrappedId == OptionalRelatable.Wrapped.Identifier? {
	public init<E: EntityType>(entity: E?, meta: MetaType, links: LinksType) where E.Id == OptionalRelatable.Wrapped.Identifier {
		self.init(id: entity?.id, meta: meta, links: links)
	}
}

extension ToOneRelationship where OptionalRelatable.WrappedId == OptionalRelatable.Wrapped.Identifier?, MetaType == NoMetadata, LinksType == NoLinks {
	public init<E: EntityType>(entity: E?) where E.Id == OptionalRelatable.Wrapped.Identifier {
		self.init(id: entity?.id, meta: .none, links: .none)
	}
}

/// An Entity relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `Many<EntityDescription>`
public struct ToManyRelationship<Relatable: JSONAPI.Relatable, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>: RelationshipType, Equatable {

	public let ids: [Relatable.Identifier]

	public let meta: MetaType
	public let links: LinksType

	public init(ids: [Relatable.Identifier], meta: MetaType, links: LinksType) {
		self.ids = ids
		self.meta = meta
		self.links = links
	}

	public init<T: JSONAPI.OptionalRelatable>(pointers: [ToOneRelationship<T, NoMetadata, NoLinks>], meta: MetaType, links: LinksType) where T.WrappedId == Relatable.Identifier {
		ids = pointers.map { $0.id }
		self.meta = meta
		self.links = links
	}

	public init<E: EntityType>(entities: [E], meta: MetaType, links: LinksType) where E.Id == Relatable.Identifier {
		self.init(ids: entities.map { $0.id }, meta: meta, links: links)
	}

	private init(meta: MetaType, links: LinksType) {
		self.init(ids: [], meta: meta, links: links)
	}

	public static func none(withMeta meta: MetaType, links: LinksType) -> ToManyRelationship {
		return ToManyRelationship(meta: meta, links: links)
	}
}

extension ToManyRelationship where MetaType == NoMetadata, LinksType == NoLinks {

	public init(ids: [Relatable.Identifier]) {
		self.init(ids: ids, meta: .none, links: .none)
	}

	public init<T: JSONAPI.OptionalRelatable>(pointers: [ToOneRelationship<T, NoMetadata, NoLinks>]) where T.WrappedId == Relatable.Identifier {
		self.init(pointers: pointers, meta: .none, links: .none)
	}

	public static var none: ToManyRelationship {
		return .none(withMeta: .none, links: .none)
	}

	public init<E: EntityType>(entities: [E]) where E.Id == Relatable.Identifier {
		self.init(entities: entities, meta: .none, links: .none)
	}
}

/// The Relatable protocol describes anything that
/// has an IdType Identifier
public protocol Relatable: JSONTyped {
	associatedtype Identifier: JSONAPI.IdType
}

/// OptionalRelatable just describes an Optional
/// with a Reltable Wrapped type.
public protocol OptionalRelatable: JSONTyped {
	associatedtype Wrapped: JSONAPI.Relatable
	associatedtype WrappedId: WrappedIdType where WrappedId.Identifier == Wrapped.Identifier
}

public protocol WrappedIdType: Codable, Equatable {
	associatedtype Identifier: JSONAPI.IdType
}

extension Optional: WrappedIdType where Wrapped: IdType {
	public typealias Identifier = Wrapped
}

extension Optional: OptionalRelatable, JSONTyped where Wrapped: JSONAPI.Relatable {
	public typealias WrappedId = Wrapped.Identifier?

	public static var type: String { return Wrapped.type }
}

// MARK: Codable
private enum ResourceLinkageCodingKeys: String, CodingKey {
	case data = "data"
	case meta = "meta"
	case links = "links"
}
private enum ResourceIdentifierCodingKeys: String, CodingKey {
	case id = "id"
	case entityType = "type"
}

extension ToOneRelationship {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ResourceLinkageCodingKeys.self)

		if let noMeta = NoMetadata() as? MetaType {
			meta = noMeta
		} else {
			meta = try container.decode(MetaType.self, forKey: .meta)
		}

		if let noLinks = NoLinks() as? LinksType {
			links = noLinks
		} else {
			links = try container.decode(LinksType.self, forKey: .links)
		}

		// A little trickery follows. If the id is nil, the
		// container.decode(Identifier.self) will fail even if Identifier
		// is Optional. However, we can check if decoding nil
		// succeeds and then attempt to coerce nil to a Identifier
		// type at which point we can store nil in `id`.
		let anyNil: Any? = nil
		if try container.decodeNil(forKey: .data),
			let val = anyNil as? OptionalRelatable.WrappedId {
			id = val
			return
		}

		let identifier = try container.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self, forKey: .data)
		
		let type = try identifier.decode(String.self, forKey: .entityType)
		
		guard type == OptionalRelatable.type else {
			throw JSONAPIEncodingError.typeMismatch(expected: OptionalRelatable.type, found: type)
		}
		
		id = try identifier.decode(OptionalRelatable.WrappedId.self, forKey: .id)
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ResourceLinkageCodingKeys.self)

		if (id as Any?) == nil {
			try container.encodeNil(forKey: .data)
		}

		if MetaType.self != NoMetadata.self {
			try container.encode(meta, forKey: .meta)
		}

		if LinksType.self != NoLinks.self {
			try container.encode(links, forKey: .links)
		}

		var identifier = container.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self, forKey: .data)
		
		try identifier.encode(id, forKey: .id)
		try identifier.encode(OptionalRelatable.type, forKey: .entityType)
	}
}

extension ToManyRelationship {
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: ResourceLinkageCodingKeys.self)

		if let noMeta = NoMetadata() as? MetaType {
			meta = noMeta
		} else {
			meta = try container.decode(MetaType.self, forKey: .meta)
		}

		if let noLinks = NoLinks() as? LinksType {
			links = noLinks
		} else {
			links = try container.decode(LinksType.self, forKey: .links)
		}

		var identifiers = try container.nestedUnkeyedContainer(forKey: .data)
		
		var newIds = [Relatable.Identifier]()
		while !identifiers.isAtEnd {
			let identifier = try identifiers.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self)
			
			let type = try identifier.decode(String.self, forKey: .entityType)
			
			guard type == Relatable.type else {
				throw JSONAPIEncodingError.typeMismatch(expected: Relatable.type, found: type)
			}
			
			newIds.append(try identifier.decode(Relatable.Identifier.self, forKey: .id))
		}
		ids = newIds
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: ResourceLinkageCodingKeys.self)

		if MetaType.self != NoMetadata.self {
			try container.encode(meta, forKey: .meta)
		}

		if LinksType.self != NoLinks.self {
			try container.encode(links, forKey: .links)
		}

		var identifiers = container.nestedUnkeyedContainer(forKey: .data)
		
		for id in ids {
			var identifier = identifiers.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self)
			
			try identifier.encode(id, forKey: .id)
			try identifier.encode(Relatable.type, forKey: .entityType)
		}
	}
}

// MARK: CustomStringDescribable
extension ToOneRelationship: CustomStringConvertible {
	public var description: String { return "Relationship(\(String(describing: id)))" }
}

extension ToManyRelationship: CustomStringConvertible {
	public var description: String { return "Relationship([\(ids.map(String.init(describing:)).joined(separator: ", "))])" }
}
