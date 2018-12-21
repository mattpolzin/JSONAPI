//
//  EncodedAttributeTest.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 12/21/18.
//

import Foundation
import XCTest
@testable import JSONAPI
import JSONAPITestLib

private struct Wrapper<Value: Equatable & Codable, Transform: Transformer>: Codable where Value == Transform.From {
	let x: TransformedAttribute<Value, Transform>

	init(x: TransformedAttribute<Value, Transform>) {
		self.x = x
	}
}

/// This function attempts to just cast to the type, so it only works
/// for Attributes of primitive types.
func testEncodedPrimitive<Value: Equatable & Codable, Transform: Transformer>(attribute: TransformedAttribute<Value, Transform>) {
	let encodedAttributeData = encoded(value: Wrapper<Value, Transform>(x: attribute))
	let wrapperObject = try! JSONSerialization.jsonObject(with: encodedAttributeData, options: []) as! [String: Any]
	let jsonObject = wrapperObject["x"]

	guard let jsonAttribute = jsonObject as? Transform.From else {
		XCTFail("Attribute did not encode to the correct type")
		return
	}

	XCTAssertEqual(attribute.rawValue, jsonAttribute)
}
