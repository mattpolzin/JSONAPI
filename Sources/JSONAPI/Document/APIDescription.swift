//
//  APIDescription.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 12/1/18.
//

/// This is what the JSON API Spec calls the "JSON:API Object"
public protocol APIDescriptionType: Codable, Equatable {
    associatedtype Meta
}

/// This is what the JSON API Spec calls the "JSON:API Object"
public struct APIDescription<Meta: JSONAPI.Meta>: APIDescriptionType {
    public let version: String
    public let meta: Meta

    public init(version: String, meta: Meta) {
        self.version = version
        self.meta = meta
    }
}

/// Can be used as `APIDescriptionType` for Documents that do not
/// have any API Description (a.k.a. "JSON:API Object").
public struct NoAPIDescription: APIDescriptionType, CustomStringConvertible {
    public typealias Meta = NoMetadata

    public init() {}

    public static var none: NoAPIDescription { return .init() }

    public var description: String { return "No JSON:API Object" }
}

extension APIDescription {
    private enum CodingKeys: String, CodingKey {
        case version
        case meta
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // The spec says that if a version is not specified, it should be assumed to be at least 1.0
        version = (try? container.decode(String.self, forKey: .version)) ?? "1.0"

        if let metaVal = NoMetadata() as? Meta {
            meta = metaVal
        } else {
            meta = try container.decode(Meta.self, forKey: .meta)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(version, forKey: .version)

        if Meta.self != NoMetadata.self {
            try container.encode(meta, forKey: .meta)
        }
    }
}
