//
//  Id.swift
//  ElevatedCore
//
//  Created by Mathew Polzin on 7/24/18.
//

import Foundation

/// Any type that you would like to be encoded to and
/// decoded from JSON API ids should conform to this
/// protocol. Conformance for `String` and `UUID`
/// is given by this library.
public protocol RawIdType: Codable, Equatable {
	static func unique() -> Self
}

public protocol Identifier: Codable, Equatable {
	init()
}

public struct Unidentified: Identifier {
	public init() {}
}

public protocol IdType: Identifier {
	associatedtype EntityType: JSONAPI.EntityType
	associatedtype RawType: RawIdType
	
	var rawValue: RawType { get }
}

extension UUID: RawIdType {
	public static func unique() -> UUID {
		return UUID()
	}
}

extension String: RawIdType {
	public static func unique() -> String {
		return UUID().uuidString
	}
}

/// An Entity ID. These IDs can be encoded to or decoded from
/// JSON API IDs.
public struct Id<RawType: RawIdType, EntityType: JSONAPI.EntityType>: IdType {
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
	
	public init() {
		rawValue = .unique()
	}
}
