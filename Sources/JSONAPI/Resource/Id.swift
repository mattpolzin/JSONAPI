//
//  Id.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 7/24/18.
//

/// Any type that you would like to be encoded to and
/// decoded from JSON API ids should conform to this
/// protocol. Conformance for `String` is given.
public protocol RawIdType: Codable, Equatable {}

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

public protocol Identifier: Codable, Equatable {}

public struct Unidentified: Identifier {
	public init() {}
}

public protocol IdType: Identifier {
	associatedtype EntityType: JSONAPI.EntityDescription
	associatedtype RawType: RawIdType
	
	var rawValue: RawType { get }
}

public protocol CreatableIdType: IdType {
	init()
}

/// An Entity ID. These IDs can be encoded to or decoded from
/// JSON API IDs.
public struct Id<RawType: RawIdType, EntityType: JSONAPI.EntityDescription>: IdType {
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

extension Id: CreatableIdType where RawType: CreatableRawIdType {
	public init() {
		rawValue = .unique()
	}
}
