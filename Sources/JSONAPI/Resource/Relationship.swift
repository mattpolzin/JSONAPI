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

/// An ResourceObject relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `One<ResourceObjectDescription>`
public struct ToOneRelationship<Identifiable: JSONAPI.Identifiable, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>: RelationshipType, Equatable {

    public let id: Identifiable.Identifier

    public let meta: MetaType
    public let links: LinksType

    public init(id: Identifiable.Identifier, meta: MetaType, links: LinksType) {
        self.id = id
        self.meta = meta
        self.links = links
    }
}

extension ToOneRelationship where MetaType == NoMetadata, LinksType == NoLinks {
    public init(id: Identifiable.Identifier) {
        self.init(id: id, meta: .none, links: .none)
    }
}

extension ToOneRelationship {
    public init<T: ResourceObjectType>(resourceObject: T, meta: MetaType, links: LinksType) where T.Id == Identifiable.Identifier {
        self.init(id: resourceObject.id, meta: meta, links: links)
    }
}

extension ToOneRelationship where MetaType == NoMetadata, LinksType == NoLinks {
    public init<T: ResourceObjectType>(resourceObject: T) where T.Id == Identifiable.Identifier {
        self.init(id: resourceObject.id, meta: .none, links: .none)
    }
}

extension ToOneRelationship where Identifiable: OptionalRelatable {
    public init<T: ResourceObjectType>(resourceObject: T?, meta: MetaType, links: LinksType) where T.Id == Identifiable.Wrapped.Identifier {
        self.init(id: resourceObject?.id, meta: meta, links: links)
    }
}

extension ToOneRelationship where Identifiable: OptionalRelatable, MetaType == NoMetadata, LinksType == NoLinks {
    public init<T: ResourceObjectType>(resourceObject: T?) where T.Id == Identifiable.Wrapped.Identifier {
        self.init(id: resourceObject?.id, meta: .none, links: .none)
    }
}

/// An ResourceObject relationship that can be encoded to or decoded from
/// a JSON API "Resource Linkage."
/// See https://jsonapi.org/format/#document-resource-object-linkage
/// A convenient typealias might make your code much more legible: `Many<ResourceObjectDescription>`
public struct ToManyRelationship<Relatable: JSONAPI.Relatable, MetaType: JSONAPI.Meta, LinksType: JSONAPI.Links>: RelationshipType, Equatable {

    public let ids: [Relatable.Identifier]

    public let meta: MetaType
    public let links: LinksType

    public init(ids: [Relatable.Identifier], meta: MetaType, links: LinksType) {
        self.ids = ids
        self.meta = meta
        self.links = links
    }

    public init<T: JSONAPI.Identifiable>(pointers: [ToOneRelationship<T, NoMetadata, NoLinks>], meta: MetaType, links: LinksType) where T.Identifier == Relatable.Identifier {
        ids = pointers.map { $0.id }
        self.meta = meta
        self.links = links
    }

    public init<T: ResourceObjectType>(resourceObjects: [T], meta: MetaType, links: LinksType) where T.Id == Relatable.Identifier {
        self.init(ids: resourceObjects.map { $0.id }, meta: meta, links: links)
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

    public init<T: JSONAPI.Identifiable>(pointers: [ToOneRelationship<T, NoMetadata, NoLinks>]) where T.Identifier == Relatable.Identifier {
        self.init(pointers: pointers, meta: .none, links: .none)
    }

    public static var none: ToManyRelationship {
        return .none(withMeta: .none, links: .none)
    }

    public init<T: ResourceObjectType>(resourceObjects: [T]) where T.Id == Relatable.Identifier {
        self.init(resourceObjects: resourceObjects, meta: .none, links: .none)
    }
}

public protocol Identifiable: JSONTyped {
    associatedtype Identifier: Equatable
}

/// The Relatable protocol describes anything that
/// has an IdType Identifier
public protocol Relatable: Identifiable where Identifier: JSONAPI.IdType {
}

/// OptionalRelatable just describes an Optional
/// with a Reltable Wrapped type.
public protocol OptionalRelatable: Identifiable where Identifier == Wrapped.Identifier? {
    associatedtype Wrapped: JSONAPI.Relatable
}

extension Optional: Identifiable, OptionalRelatable, JSONTyped where Wrapped: JSONAPI.Relatable {
    public typealias Identifier = Wrapped.Identifier?

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
}

extension ToOneRelationship: Codable where Identifiable.Identifier: OptionalId {
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
            guard let val = anyNil as? Identifiable.Identifier else {
                throw DecodingError.valueNotFound(
                    Self.self,
                    DecodingError.Context(
                        codingPath: decoder.codingPath,
                        debugDescription: "Expected non-null relationship data."
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
            throw JSONAPICodingError.quantityMismatch(expected: .one,
                                                  path: context.codingPath)
        }

        let type = try identifier.decode(String.self, forKey: .entityType)

        guard type == Identifiable.jsonType else {
            throw JSONAPICodingError.typeMismatch(expected: Identifiable.jsonType, found: type, path: decoder.codingPath)
        }

        id = Identifiable.Identifier(rawValue: try identifier.decode(Identifiable.Identifier.RawType.self, forKey: .id))
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
        let nilId = anyNil as? Identifiable.Identifier
        guard id != nilId else {
            try container.encodeNil(forKey: .data)
            return
        }

        var identifier = container.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self, forKey: .data)

        try identifier.encode(id.rawValue, forKey: .id)
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

        var newIds = [Relatable.Identifier]()
        while !identifiers.isAtEnd {
            let identifier = try identifiers.nestedContainer(keyedBy: ResourceIdentifierCodingKeys.self)

            let type = try identifier.decode(String.self, forKey: .entityType)

            guard type == Relatable.jsonType else {
                throw JSONAPICodingError.typeMismatch(expected: Relatable.jsonType, found: type, path: decoder.codingPath)
            }

            newIds.append(Relatable.Identifier(rawValue: try identifier.decode(Relatable.Identifier.RawType.self, forKey: .id)))
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

            try identifier.encode(id.rawValue, forKey: .id)
            try identifier.encode(Relatable.jsonType, forKey: .entityType)
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

private protocol _DictionaryType {}
extension Dictionary: _DictionaryType {}

private protocol _ArrayType {}
extension Array: _ArrayType {}
