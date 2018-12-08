//
//  EncodingError.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 12/7/18.
//

public enum JSONAPIEncodingError: Swift.Error {
	case typeMismatch(expected: String, found: String)
	case illegalEncoding(String)
	case illegalDecoding(String)
	case missingOrMalformedMetadata
	case missingOrMalformedLinks
}
