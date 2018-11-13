//
//  JSONAPI_Error.swift
//  ElevatedCore
//
//  Created by Mathew Polzin on 11/10/18.
//

import Foundation

public protocol JSONAPIError: Swift.Error {
	static var unknown: Self { get }
}

// TODO: remove temp error stuff below
public enum TmpError: JSONAPIError & Decodable {
	case unknownError
	
	public init(from decoder: Decoder) throws {
		self = .unknown
	}
	
	public static var unknown: TmpError {
		return .unknownError
	}
}
