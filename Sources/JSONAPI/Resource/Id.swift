//
//  Id.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 7/24/18.
//

/// All types that are RawIdType and additionally
/// Unidentified conform to this protocol. You
/// should not add conformance to this protocol
/// directly.
public protocol MaybeRawId: Codable, Equatable {}

/// Any type that you would like to be encoded to and
/// decoded from JSON API ids should conform to this
/// protocol. Conformance for `String` is given.
public protocol RawIdType: MaybeRawId, Hashable {}

/// If you would like to be able to create new
/// Entities with Ids backed by a RawIdType then
/// your Id type should conform to
/// `CreatableRawIdType`.
/// Conformances for `String` and `UUID`
/// are given in the README for this library.
public protocol CreatableRawIdType: RawIdType {
    static func unique() -> Self
}

extension String: RawIdType {}

/// A type that can be used as the `MaybeRawId` for a `ResourceObject` that does not
/// have an Id (most likely because it was created by a client and the server will be responsible
/// for assigning it an Id).
public struct Unidentified: MaybeRawId, CustomStringConvertible {
    public init() {}

    public var description: String { return "Unidentified" }
}

public protocol OptionalId: Codable {
    associatedtype IdentifiableType: JSONAPI.JSONTyped
    associatedtype RawType: MaybeRawId

    var rawValue: RawType { get }
    init(rawValue: RawType)
}

public protocol IdType: OptionalId, CustomStringConvertible, Hashable where RawType: RawIdType {}

extension Optional: MaybeRawId where Wrapped: Codable & Equatable {}
extension Optional: OptionalId where Wrapped: IdType {
    public typealias IdentifiableType = Wrapped.IdentifiableType
    public typealias RawType = Wrapped.RawType?

    public var rawValue: Wrapped.RawType? {
        guard case .some(let value) = self else {
            return nil
        }
        return value.rawValue
    }

    public init(rawValue: Wrapped.RawType?) {
        self = rawValue.map { Wrapped(rawValue: $0) }
    }
}

public extension IdType {
    var description: String { return "Id(\(String(describing: rawValue)))" }
}

public protocol CreatableIdType: IdType {
    init()
}

/// An ResourceObject ID. These IDs can be encoded to or decoded from
/// JSON API IDs.
public struct Id<RawType: MaybeRawId, IdentifiableType: JSONAPI.JSONTyped>: Equatable, OptionalId {

    public let rawValue: RawType

    public init(rawValue: RawType) {
        self.rawValue = rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawType.self)
        self.init(rawValue: rawValue)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

extension Id: Hashable, CustomStringConvertible, IdType where RawType: RawIdType {
    public static func id(from rawValue: RawType) -> Id<RawType, IdentifiableType> {
        return Id(rawValue: rawValue)
    }
}

extension Id: CreatableIdType where RawType: CreatableRawIdType {
    public init() {
        rawValue = .unique()
    }
}

extension Id where RawType == Unidentified {
    public static var unidentified: Id { return .init(rawValue: Unidentified()) }
}
