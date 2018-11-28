//
//  Id.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 7/24/18.
//

/// Any type that you would like to be encoded to and
/// decoded from JSON API ids should conform to this
/// protocol. Conformance for `String` is given.
public protocol RawIdType: Codable, Hashable {}

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

public protocol Identifier: Codable, Equatable {
	associatedtype EntityDescription: JSONAPI.EntityDescription
}

public struct Unidentified<EntityDescription: JSONAPI.EntityDescription>: Identifier, CustomStringConvertible {
	public init() {}
	
	public var description: String { return "Id(Unidentified)" }
}

public protocol IdType: Identifier, Hashable, CustomStringConvertible {
	associatedtype RawType: RawIdType
	
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
public struct Id<RawType: RawIdType, EntityDescription: JSONAPI.EntityDescription>: IdType {

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
