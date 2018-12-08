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

public struct Unidentified: MaybeRawId, CustomStringConvertible {
	public init() {}
	
	public var description: String { return "Unidentified" }
}

public protocol MaybeId: Codable {
	associatedtype EntityType: JSONAPI.EntityProxy
	associatedtype RawType: MaybeRawId
}

public protocol IdType: MaybeId, CustomStringConvertible, Hashable where RawType: RawIdType {
	var rawValue: RawType { get }
}

public extension IdType {
	var description: String { return "Id(\(String(describing: rawValue)))" }
}

public protocol CreatableIdType: IdType {
	init()
}

/// An Entity ID. These IDs can be encoded to or decoded from
/// JSON API IDs.
public struct Id<RawType: MaybeRawId, EntityType: JSONAPI.EntityProxy>: Codable, Equatable, MaybeId {

	public let rawValue: RawType
	
	public init(rawValue: RawType) {
		self.rawValue = rawValue
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		rawValue = try container.decode(RawType.self)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode(rawValue)
	}
}

extension Id: Hashable, CustomStringConvertible, IdType where RawType: RawIdType {}

extension Id: WrappedIdType where RawType: RawIdType {
	public typealias Identifier = Id
}

extension Id: CreatableIdType where RawType: CreatableRawIdType {
	public init() {
		rawValue = .unique()
	}
}

extension Id where RawType == Unidentified {
	public static var unidentified: Id { return .init(rawValue: Unidentified()) }
}
