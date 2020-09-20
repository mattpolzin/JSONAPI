//
//  Relationship.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 8/31/18.
//

public protocol RelationshipType {
    associatedtype LinksType
    associatedtype MetaType

    var links: LinksType { get }
    var meta: MetaType { get }
}

/// A relationship with no `data` entry (it still must contain at least meta or links).
/// A server might choose to expose certain relationships as just a link that can be
/// used to retrieve the related resource(s) in some cases.
///
/// If the server is going to deliver one or more resource's `id`/`type` in a `data`
/// entry, you want to use either the `ToOneRelationship` or the
/// `ToManyRelationship` instead.
public struct MetaRelationship<MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>: RelationshipType, Equatable {

    public let meta: MetaType
    public let links: LinksType

    public init(meta: MetaType, links: LinksType) {
        self.meta = meta
        self.links = links
    }
}

/// A `ResourceObject` relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
///
/// See https://jsonapi.org/format/#document-resource-object-linkage
///
/// A convenient typealias might make your code much more legible: `One<ResourceObjectDescription>`
///
/// The `IdMetaType` (if not `NoIdMetadata`) will be parsed out of the Resource Identifier Object.
/// (see https://jsonapi.org/format/#document-resource-identifier-objects)
///
/// The `MetaType` (if not `NoMetadata`) will be parsed out of the Relationship Object.
/// (see https://jsonapi.org/format/#document-resource-object-relationships)
public struct ToOneRelationship<Identifiable: JSONAPI.JSONAPIIdentifiable, IdMetaType: JSONAPI.Meta, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>: RelationshipType, Equatable {

    public let id: Identifiable.ID

    public let idMeta: IdMetaType

    public let meta: MetaType
    public let links: LinksType

    public init(id: (Identifiable.ID, IdMetaType), meta: MetaType, links: LinksType) {
        self.id = id.0
        self.idMeta = id.1
        self.meta = meta
        self.links = links
    }
}

extension ToOneRelationship where IdMetaType == NoIdMetadata {
    public init(id: Identifiable.ID, meta: MetaType, links: LinksType) {
        self.id = id
        self.idMeta = .none
        self.meta = meta
        self.links = links
    }
}

extension ToOneRelationship where MetaType == NoMetadata, LinksType == NoLinks {
    public init(id: (Identifiable.ID, IdMetaType)) {
        self.init(id: id, meta: .none, links: .none)
    }
}

extension ToOneRelationship where IdMetaType == NoIdMetadata, MetaType == NoMetadata, LinksType == NoLinks {
    public init(id: Identifiable.ID) {
        self.init(id: id, meta: .none, links: .none)
    }
}

extension ToOneRelationship {
    public init<T: ResourceObjectType>(resourceObject: T, meta: MetaType, links: LinksType) where T.Id == Identifiable.ID, IdMetaType == NoIdMetadata {
        self.init(id: resourceObject.id, meta: meta, links: links)
    }
}

extension ToOneRelationship where MetaType == NoMetadata, LinksType == NoLinks, IdMetaType == NoIdMetadata {
    public init<T: ResourceObjectType>(resourceObject: T) where T.Id == Identifiable.ID {
        self.init(id: resourceObject.id, meta: .none, links: .none)
    }
}

extension ToOneRelationship where Identifiable: OptionalRelatable, IdMetaType == NoIdMetadata {
    public init<T: ResourceObjectType>(resourceObject: T?, meta: MetaType, links: LinksType) where T.Id == Identifiable.Wrapped.ID {
        self.init(id: resourceObject?.id, meta: meta, links: links)
    }
}

extension ToOneRelationship where Identifiable: OptionalRelatable, MetaType == NoMetadata, LinksType == NoLinks, IdMetaType == NoIdMetadata {
    public init<T: ResourceObjectType>(resourceObject: T?) where T.Id == Identifiable.Wrapped.ID {
        self.init(id: resourceObject?.id, meta: .none, links: .none)
    }
}

/// An ResourceObject relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
///
/// See https://jsonapi.org/format/#document-resource-object-linkage
///
/// A convenient typealias might make your code much more legible: `Many<ResourceObjectDescription>`
///
/// The `IdMetaType` (if not `NoIdMetadata`) will be parsed out of the Resource Identifier Object.
/// (see https://jsonapi.org/format/#document-resource-identifier-objects)
///
/// The `MetaType` (if not `NoMetadata`) will be parsed out of the Relationship Object.
/// (see https://jsonapi.org/format/#document-resource-object-relationships)
public struct ToManyRelationship<Relatable: JSONAPI.Relatable, IdMetaType: JSONAPI.Meta, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>: RelationshipType, Equatable {

    public struct ID: Equatable {
        public let id: Relatable.ID
        public let meta: IdMetaType

        public init(id: Relatable.ID, meta: IdMetaType) {
            self.id = id
            self.meta = meta
        }

        internal init(_ idPair: (Relatable.ID, IdMetaType)) {
            self.init(id: idPair.0, meta: idPair.1)
        }
    }

    public let idsWithMeta: [ID]

    public var ids: [Relatable.ID] {
        idsWithMeta.map(\.id)
    }

    public let meta: MetaType
    public let links: LinksType

    public init(idsWithMetadata ids: [(Relatable.ID, IdMetaType)], meta: MetaType, links: LinksType) {
        self.idsWithMeta = ids.map { ID.init($0) }
        self.meta = meta
        self.links = links
    }

    public init<T: JSONAPIIdentifiable>(pointers: [ToOneRelationship<T, NoIdMetadata, NoMetadata, NoLinks>], meta: MetaType, links: LinksType) where T.ID == Relatable.ID, IdMetaType == NoIdMetadata {
        idsWithMeta = pointers.map { .init(id: $0.id, meta: .none) }
        self.meta = meta
        self.links = links
    }

    public init<T: ResourceObjectType>(resourceObjects: [T], meta: MetaType, links: LinksType) where T.Id == Relatable.ID, IdMetaType == NoIdMetadata {
        self.init(ids: resourceObjects.map(\.id), meta: meta, links: links)
    }

    private init(meta: MetaType, links: LinksType) {
        self.init(idsWithMetadata: [], meta: meta, links: links)
    }

    public static func none(withMeta meta: MetaType, links: LinksType) -> ToManyRelationship {
        return ToManyRelationship(meta: meta, links: links)
    }
}

extension ToManyRelationship where IdMetaType == NoIdMetadata {
    public init(ids: [Relatable.ID], meta: MetaType, links: LinksType) {
        self.idsWithMeta = ids.map { .init(id: $0, meta: .none) }
        self.meta = meta
        self.links = links
    }
}

extension ToManyRelationship where MetaType == NoMetadata, LinksType == NoLinks {

    public init(idsWithMetadata ids: [(Relatable.ID, IdMetaType)]) {
        self.init(idsWithMetadata: ids, meta: .none, links: .none)
    }

    public init<T: JSONAPIIdentifiable>(pointers: [ToOneRelationship<T, NoIdMetadata, NoMetadata, NoLinks>]) where T.ID == Relatable.ID, IdMetaType == NoIdMetadata {
        self.init(pointers: pointers, meta: .none, links: .none)
    }

    public static var none: ToManyRelationship {
        return .none(withMeta: .none, links: .none)
    }

    public init<T: ResourceObjectType>(resourceObjects: [T]) where T.Id == Relatable.ID, IdMetaType == NoIdMetadata {
        self.init(resourceObjects: resourceObjects, meta: .none, links: .none)
    }
}

extension ToManyRelationship where IdMetaType == NoIdMetadata, MetaType == NoMetadata, LinksType == NoLinks {
    public init(ids: [Relatable.ID]) {
        self.init(ids: ids, meta: .none, links: .none)
    }
}

public protocol JSONAPIIdentifiable: JSONTyped {
    associatedtype ID: Equatable
}

/// The Relatable protocol describes anything that
/// has an IdType Identifier
public protocol Relatable: JSONAPIIdentifiable where ID: JSONAPI.IdType {
}

/// OptionalRelatable just describes an Optional
/// with a Reltable Wrapped type.
public protocol OptionalRelatable: JSONAPIIdentifiable where ID == Wrapped.ID? {
    associatedtype Wrapped: JSONAPI.Relatable
}

extension Optional: JSONAPIIdentifiable, OptionalRelatable, JSONTyped where Wrapped: JSONAPI.Relatable {
    public typealias ID = Wrapped.ID?

    public static var jsonType: String { return Wrapped.jsonType }
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
    case metadata = "meta"
}

extension MetaRelationship: Codable {
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
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ResourceLinkageCodingKeys.self)

        if MetaType.self != NoMetadata.self {
            try container.encode(meta, forKey: .meta)
        }

        if LinksType.self != NoLinks.self {
            try container.encode(links, forKey: .links)
        }
    }
}

fileprivate protocol _Optional {}
extension Optional: _Optional {}

extension ToOneRelationship: Codable where Identifiable.ID: OptionalId {
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
        if try container.decodeNil(forKey: .data) {
            guard let val = anyNil as? Identifiable.ID else {
                throw DecodingError.valueNotFound(
                    Self.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected non-null relationship data."
                    )
                )
            }
            // if we know we aren't getting any Resource Identifer Object at all
            // (which we do inside this block) then we better either be expecting
            // no Id Metadata or optional Id Metadata or else we will report an
            // error.
            if let noIdMeta = NoIdMetadata() as? IdMetaType {
                idMeta = noIdMeta
            } else if let nilMeta = anyNil as? IdMetaType {
                idMeta = nilMeta
            } else {
                throw DecodingError.valueNotFound(
                    Self.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected non-null relationship data with metadata inside."
                    )
                )
            }
            id = val
            return
        }

        let identifier: KeyedDecodingContainer<ResourceIdentifierCodingKeys>
        do {
            identifier = try container.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self, forKey: .data)
        } catch let error as DecodingError {
            guard case let .typeMismatch(type, context) = error,
                type is _DictionaryType.Type else {
                throw error
            }
            throw JSONAPICodingError.quantityMismatch(
                expected: .one,
                path: context.codingPath
            )
        }

        let type = try identifier.decode(String.self, forKey: .entityType)

        guard type == Identifiable.jsonType else {
            throw JSONAPICodingError.typeMismatch(
                expected: Identifiable.jsonType,
                found: type,
                path: decoder.codingPath
            )
        }

        let idMeta: IdMetaType
        let maybeNoIdMeta: IdMetaType? = NoIdMetadata() as? IdMetaType
        if let noIdMeta = maybeNoIdMeta {
            idMeta = noIdMeta
        } else {
            idMeta = try identifier.decode(IdMetaType.self, forKey: .metadata)
        }
        self.idMeta = idMeta

        id = Identifiable.ID(rawValue: try identifier.decode(Identifiable.ID.RawType.self, forKey: .id))
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ResourceLinkageCodingKeys.self)

        if MetaType.self != NoMetadata.self {
            try container.encode(meta, forKey: .meta)
        }

        if LinksType.self != NoLinks.self {
            try container.encode(links, forKey: .links)
        }

        // If id is nil, instead of {id: , type: } we will just
        // encode `null`
        let anyNil: Any? = nil
        let nilId = anyNil as? Identifiable.ID
        guard id != nilId else {
            try container.encodeNil(forKey: .data)
            return
        }

        var identifier = container.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self, forKey: .data)

        try identifier.encode(id.rawValue, forKey: .id)
        if IdMetaType.self != NoMetadata.self {
            try identifier.encode(idMeta, forKey: .metadata)
        }
        try identifier.encode(Identifiable.jsonType, forKey: .entityType)
    }
}

extension ToManyRelationship: Codable {
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

        var identifiers: UnkeyedDecodingContainer
        do {
            identifiers = try container.nestedUnkeyedContainer(forKey: .data)
        } catch let error as DecodingError {
            guard case let .typeMismatch(type, context) = error,
                type is _ArrayType.Type else {
                    throw error
            }
            throw JSONAPICodingError.quantityMismatch(expected: .many,
                                                      path: context.codingPath)
        }

        var newIds = [ID]()
        while !identifiers.isAtEnd {
            let identifier = try identifiers.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self)

            let type = try identifier.decode(String.self, forKey: .entityType)

            guard type == Relatable.jsonType else {
                throw JSONAPICodingError.typeMismatch(expected: Relatable.jsonType, found: type, path: decoder.codingPath)
            }

            let id = try identifier.decode(Relatable.ID.RawType.self, forKey: .id)

            let idMeta: IdMetaType
            let maybeNoIdMeta: IdMetaType? = NoIdMetadata() as? IdMetaType
            if let noIdMeta = maybeNoIdMeta {
                idMeta = noIdMeta
            } else {
                idMeta = try identifier.decode(IdMetaType.self, forKey: .metadata)
            }

            newIds.append(.init(id: Relatable.ID(rawValue: id), meta: idMeta) )
        }
        idsWithMeta = newIds
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

        for id in idsWithMeta {
            var identifier = identifiers.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self)

            try identifier.encode(id.id.rawValue, forKey: .id)
            if IdMetaType.self != NoMetadata.self {
                try identifier.encode(id.meta, forKey: .metadata)
            }
            try identifier.encode(Relatable.jsonType, forKey: .entityType)
        }
    }
}

// MARK: CustomStringDescribable
extension MetaRelationship: CustomStringConvertible {
    public var description: String { "MetaRelationship" }
}

extension ToOneRelationship: CustomStringConvertible {
    public var description: String { "Relationship(\(String(describing: id)))" }
}

extension ToManyRelationship: CustomStringConvertible {
    public var description: String { "Relationship([\(ids.map(String.init(describing:)).joined(separator: ", "))])" }
}

private protocol _DictionaryType {}
extension Dictionary: _DictionaryType {}

private protocol _ArrayType {}
extension Array: _ArrayType {}
