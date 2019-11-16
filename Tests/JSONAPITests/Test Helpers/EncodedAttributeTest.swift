//
//  EncodedAttributeTest.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 12/21/18.
//

import Foundation
import XCTest
@testable import JSONAPI
import JSONAPITesting

private struct TransformedWrapper<Value: Equatable & Codable, Transform: Transformer>: Codable where Value == Transform.From {
	let x: TransformedAttribute<Value, Transform>

	init(x: TransformedAttribute<Value, Transform>) {
		self.x = x
	}
}

private struct Wrapper<Value: Equatable & Codable>: Codable {
	let x: Attribute<Value>

	init(x: Attribute<Value>) {
		self.x = x
	}
}

/// This function attempts to just cast to the type, so it only works
/// for Attributes of primitive types (primitive to JSON).
func testEncodedPrimitive<Value: Equatable & Codable, Transform: Transformer>(attribute: TransformedAttribute<Value, Transform>) {
	let encodedAttributeData = encoded(value: TransformedWrapper<Value, Transform>(x: attribute))
	let wrapperObject = try! JSONSerialization.jsonObject(with: encodedAttributeData, options: []) as! [String: Any]
	let jsonObject = wrapperObject["x"]

    XCTAssert(jsonObject is Transform.From)

	XCTAssertEqual(attribute.rawValue, jsonObject as? Transform.From)
}

/// This function attempts to just cast to the type, so it only works
/// for Attributes of primitive types (primitive to JSON).
func testEncodedPrimitive<Value: Equatable & Codable>(attribute: Attribute<Value>) {
	let encodedAttributeData = encoded(value: Wrapper<Value>(x: attribute))
	let wrapperObject = try! JSONSerialization.jsonObject(with: encodedAttributeData, options: []) as! [String: Any]
	let jsonObject = wrapperObject["x"]

    XCTAssert(jsonObject is Value)

	XCTAssertEqual(attribute.value, jsonObject as? Value)
}
