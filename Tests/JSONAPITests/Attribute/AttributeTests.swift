//
//  AttributeTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/27/18.
//

import XCTest
import JSONAPI

class AttributeTests: XCTestCase {

	func test_AttributeIsTransformedAttribute() {
		XCTAssertEqual(try TransformedAttribute<String, IdentityTransformer<String>>(rawValue: "hello"), try Attribute<String>(rawValue: "hello"))
	}

	func test_AttributeNonThrowingConstructor() {
		XCTAssertEqual(try Attribute<String>(rawValue: "hello"), Attribute<String>(value: "hello"))
	}

}
