//
//  Error.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

public protocol JSONAPIError: Swift.Error, Equatable, Codable {
	static var unknown: Self { get }
}

public enum BasicJSONAPIError: JSONAPIError {
	case unknownError
	
	public init(from decoder: Decoder) throws {
		self = .unknown
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()
		try container.encode("unknown")
	}
	
	public static var unknown: BasicJSONAPIError {
		return .unknownError
	}
}
