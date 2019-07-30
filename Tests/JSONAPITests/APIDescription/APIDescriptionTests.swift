//
//  APIDescriptionTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 12/2/18.
//

import XCTest
import JSONAPI

class APIDescriptionTests: XCTestCase {

    func test_init() {
        let _ = APIDescription<NoMetadata>(version: "hello",
                                                      meta: .none)
        let _ = APIDescription<TestMetadata>(version: "world",
                                                        meta: .init(hello: "there",
                                                                    number: 2))
        let _ = NoAPIDescription()

        XCTAssertEqual(NoAPIDescription(), NoAPIDescription.none)
    }

	func test_NoDescriptionString() {
		XCTAssertEqual(String(describing: NoAPIDescription()), "No JSON:API Object")
	}

	func test_empty() {
		let description = decoded(type: APIDescription<NoMetadata>.self, data: api_description_empty)

		XCTAssertEqual(description.version, "1.0")

        test_DecodeEncodeEquality(type: APIDescription<NoMetadata>.self,
                                  data: api_description_empty)
	}

	func test_WithVersion() {
		let description = decoded(type: APIDescription<NoMetadata>.self, data: api_description_with_version)

		XCTAssertEqual(description.version, "1.5")

        test_DecodeEncodeEquality(type: APIDescription<NoMetadata>.self,
                                  data: api_description_with_version)
	}

	func test_WithMeta() {
		let description = decoded(type: APIDescription<TestMetadata>.self, data: api_description_with_meta)

		XCTAssertEqual(description.version, "1.0")
		XCTAssertEqual(description.meta.hello, "world")
		XCTAssertEqual(description.meta.number, 10)

        test_DecodeEncodeEquality(type: APIDescription<TestMetadata>.self,
                                  data: api_description_with_meta)
	}

	func test_WithVersionAndMeta() {
		let description = decoded(type: APIDescription<TestMetadata>.self, data: api_description_with_version_and_meta)

		XCTAssertEqual(description.version, "2.0")
		XCTAssertEqual(description.meta.hello, "world")
		XCTAssertEqual(description.meta.number, 10)

        test_DecodeEncodeEquality(type: APIDescription<TestMetadata>.self,
                                  data: api_description_with_version_and_meta)
	}

	func test_failsMissingMeta() {
		XCTAssertThrowsError(try JSONDecoder().decode(APIDescription<TestMetadata>.self, from: api_description_with_version))
	}
}

// MARK: - Test types
extension APIDescriptionTests {
	struct TestMetadata: JSONAPI.Meta {
		let hello: String
		let number: Int
	}
}
