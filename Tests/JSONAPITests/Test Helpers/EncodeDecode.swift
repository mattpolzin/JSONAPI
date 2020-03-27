//
//  EncodeDecode.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/16/18.
//

import Foundation
import XCTest

let testDecoder = JSONDecoder()
let testEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    if #available(OSX 10.13, iOS 11.0, *) {
        encoder.outputFormatting = .sortedKeys
    }
    #if os(Linux)
    encoder.outputFormatting = .sortedKeys
    #endif
    return encoder
}()

func decoded<T: Decodable>(type: T.Type, data: Data) -> T {
	return try! testDecoder.decode(T.self, from: data)
}

func encoded<T: Encodable>(value: T) -> Data {
	return try! testEncoder.encode(value)
}

/// A helper function that tests that decode() == decode().encode().decode().
/// If decoding is well tested and the above is true then encoding is well
/// tested.
func test_DecodeEncodeEquality<T: Codable & Equatable>(type: T.Type, data: Data) {
	let entity = try? JSONDecoder().decode(T.self, from: data)

	XCTAssertNotNil(entity)

	guard let e = entity else { return }

	let encodedEntity = try? JSONEncoder().encode(e)

	XCTAssertNotNil(encodedEntity)

	guard let ee = encodedEntity else { return }

	// check that decoding ee results in e
	XCTAssertEqual(try? JSONDecoder().decode(T.self, from: ee), e)
}
