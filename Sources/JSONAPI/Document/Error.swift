//
//  Error.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

import Foundation

public protocol JSONAPIError: Swift.Error {
	static var unknown: Self { get }
}

public enum BasicJSONAPIError: JSONAPIError & Decodable {
	case unknownError
	
	public init(from decoder: Decoder) throws {
		self = .unknown
	}
	
	public static var unknown: BasicJSONAPIError {
		return .unknownError
	}
}
