//
//  LinksTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/24/18.
//

import XCTest
import JSONAPI

class LinksTests: XCTestCase {
	func test_linkWithNoMeta() {
		let links = decoded(type: LinksTests.Links.self, data: link_without_meta)

		XCTAssertEqual(links.link.url, "https://website.com/path/file")
		XCTAssertEqual(links.optionalLink?.url, "https://theweb.com/not")
		XCTAssertEqual(links.link.meta, NoMetadata())
	}

	func test_linkWithNoMeta_encode() {
		test_DecodeEncodeEquality(type: LinksTests.Links.self, data: link_without_meta)
	}

	func test_linkWithNoMetaWithoutOptionalLink() {
		let links = decoded(type: LinksTests.Links.self, data: link_without_meta_without_optional_link)

		XCTAssertEqual(links.link.url, "https://website.com/path/file")
		XCTAssertNil(links.optionalLink)
		XCTAssertEqual(links.link.meta, NoMetadata())
	}

	func test_linkWithNoMetaWithoutOptionalLink_encode() {
		test_DecodeEncodeEquality(type: LinksTests.Links.self, data: link_without_meta_without_optional_link)
	}

	func test_linkWithNullMetadata() {
		let link = decoded(type: Link<LinksTests.URL, Metadata?>.self, data: link_with_null_meta)

		XCTAssertEqual(link.url, "https://website.com/path/file")
		XCTAssertNil(link.meta)
	}

	func test_linkWithNullMetadata_encode() {
		test_DecodeEncodeEquality(type: Link<LinksTests.URL, Metadata?>.self, data: link_with_null_meta)
	}

	func test_linkWithMetadata() {
		let link = decoded(type: Link<LinksTests.URL, Metadata?>.self, data: link_with_metadata)

		XCTAssertEqual(link.url, "https://website.com/path/file")
		XCTAssertEqual(link.meta, Metadata(hello: "world"))

		let link2 = decoded(type: Link<LinksTests.URL, Metadata>.self, data: link_with_metadata)

		XCTAssertEqual(link2.url, "https://website.com/path/file")
		XCTAssertEqual(link2.meta, Metadata(hello: "world"))
	}

	func test_linkWithMetadata_encode() {
		test_DecodeEncodeEquality(type: Link<LinksTests.URL, Metadata?>.self, data: link_with_metadata)

		test_DecodeEncodeEquality(type: Link<LinksTests.URL, Metadata>.self, data: link_with_metadata)
	}

	func test_linkFailsIfMetaNotFound() {
		XCTAssertThrowsError(try JSONDecoder().decode(Link<LinksTests.URL, Metadata>.self, from: link_with_null_meta))
	}
}

// MARK: - Test types
extension LinksTests {
	typealias URL = String

	struct Links: JSONAPI.Links {
		let link: Link<LinksTests.URL, NoMetadata>
		let optionalLink: Link<LinksTests.URL, NoMetadata>?
	}

	struct Metadata: JSONAPI.Meta {
		let hello: String
	}
}
