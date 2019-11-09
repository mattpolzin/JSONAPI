//
//  EncodingError.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 12/7/18.
//

public enum JSONAPIEncodingError: Swift.Error {
    case typeMismatch(expected: String, found: String, path: [CodingKey])
    case illegalEncoding(String, path: [CodingKey])
    case illegalDecoding(String, path: [CodingKey])
    case missingOrMalformedMetadata(path: [CodingKey])
    case missingOrMalformedLinks(path: [CodingKey])
}
