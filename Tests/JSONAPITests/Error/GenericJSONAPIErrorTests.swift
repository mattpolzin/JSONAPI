//
//  GenericJSONAPIErrorTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 9/29/19.
//

import Foundation
import JSONAPI
import XCTest

final class GenericJSONAPIErrorTests: XCTestCase {
    func test_initAndEquality() {
        let unknown1 = TestGenericJSONAPIError.unknown
        let unknown2 = TestGenericJSONAPIError.unknownError
        XCTAssertEqual(unknown1, unknown2)

        let known1 = TestGenericJSONAPIError.error(.init(hello: "there", world: 3))
        let known2 = TestGenericJSONAPIError.error(.init(hello: "there", world: nil))
        XCTAssertNotEqual(unknown1, known1)
        XCTAssertNotEqual(unknown1, known2)
        XCTAssertNotEqual(known1, known2)
    }

    func test_decodeKnown() {
        let datas = [
"""
{
    "hello": "world"
}
""",
"""
{
    "hello": "there",
    "world": 2
}
""",
"""
{
    "hello": "three",
    "world": null
}
"""
        ].map { $0.data(using: .utf8)! }

        let errors = datas
            .map { decoded(type: TestGenericJSONAPIError.self, data: $0) }

        XCTAssertEqual(errors[0], .error(TestPayload(hello: "world", world: nil)))

        XCTAssertEqual(errors[1], .error(TestPayload(hello: "there", world: 2)))

        XCTAssertEqual(errors[2], .error(TestPayload(hello: "three", world: nil)))
    }

    func test_decodeUnknown() {
        let data =
"""
{
    "world": 2
}
""".data(using: .utf8)!

        let error = decoded(type: TestGenericJSONAPIError.self, data: data)

        XCTAssertEqual(error, .unknown)
        XCTAssertEqual(String(describing: error), "unknown error")
    }

    func test_encode() {
        let datas = [
"""
{
    "hello": "world"
}
""",
"""
{
    "hello": "there",
    "world": 2
}
""",
"""
{
    "hello": "three",
    "world": null
}
"""
        ].map { $0.data(using: .utf8)! }

        datas.forEach { data in
            test_DecodeEncodeEquality(type: TestGenericJSONAPIError.self, data: data)
        }
    }

    func test_encodeUnknown() {
        let error = TestGenericJSONAPIError.unknownError

        let encodedError = encoded(value: ["errors": [error]])

        XCTAssertEqual(String(data: encodedError, encoding: .utf8)!, #"{"errors":["unknown"]}"#)
    }

    func test_payloadAccess() {
        let error1 = TestGenericJSONAPIError.error(.init(hello: "world", world: 3))
        let error2 = TestGenericJSONAPIError.error(.init(hello: "there", world: nil))
        let error3 = TestGenericJSONAPIError.unknown

        XCTAssertEqual(error1.payload?.hello, "world")
        XCTAssertEqual(error1.payload?.world, 3)
        XCTAssertEqual(error2.payload?.hello, "there")
        XCTAssertNil(error2.payload?.world)
        XCTAssertNil(error3.payload?.hello)
        XCTAssertNil(error3.payload?.world)
    }

    func test_definedFields() {
        let error1 = TestGenericJSONAPIError.error(.init(hello: "world", world: 3))
        let error2 = TestGenericJSONAPIError.error(.init(hello: "there", world: nil))
        let error3 = TestGenericJSONAPIError.unknown

        XCTAssertEqual(error1.definedFields.count, 2)
        XCTAssertEqual(error2.definedFields.count, 1)
        XCTAssertEqual(error3.definedFields.count, 0)

        XCTAssertEqual(error1.definedFields["hello"], "world")
        XCTAssertEqual(error1.definedFields["world"], "3")
        XCTAssertEqual(error2.definedFields["hello"], "there")
        XCTAssertNil(error2.definedFields["world"])
        XCTAssertNil(error3.definedFields["hello"])
        XCTAssertNil(error3.definedFields["world"])
    }
}

private struct TestPayload: Codable, Equatable, ErrorDictType {
    let hello: String
    let world: Int?

    public var definedFields: [String : String] {
        let keysAndValues = [
            ("hello", hello),
            world.map { ("world", String($0)) }
        ].compactMap { $0 }
        return Dictionary(uniqueKeysWithValues: keysAndValues)
    }
}

private typealias TestGenericJSONAPIError = GenericJSONAPIError<TestPayload>
