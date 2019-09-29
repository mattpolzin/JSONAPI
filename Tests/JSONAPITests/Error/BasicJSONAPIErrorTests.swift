//
//  BasicJSONAPIErrorTests.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 9/29/19.
//

import Foundation
@testable import JSONAPI
import XCTest

final class BasicJSONAPIErrorTests: XCTestCase {
    func test_initAndEquality() {
        let unknown1 = BasicJSONAPIError<String>.unknown
        let unknown2 = BasicJSONAPIError<String>.unknownError
        XCTAssertEqual(unknown1, unknown2)
        let unknown3 = BasicJSONAPIError<Int>.unknownError
        XCTAssertEqual(unknown3, .unknown)

        let _ = BasicJSONAPIError<Int>.error(.init(id: nil,
                                                   status: nil,
                                                   code: nil,
                                                   title: nil,
                                                   detail: nil,
                                                   source: nil))
        let _ = BasicJSONAPIError<String>.error(.init(id: nil,
                                                      status: nil,
                                                      code: nil,
                                                      title: nil,
                                                      detail: nil,
                                                      source: nil))

        let intError = BasicJSONAPIError<Int>.error(.init(id: 2,
                                                          status: nil,
                                                          code: nil,
                                                          title: nil,
                                                          detail: nil,
                                                          source: nil))
        XCTAssertEqual(intError.payload?.id, 2)
        XCTAssertNotEqual(intError, unknown3)

        let stringError = BasicJSONAPIError<String>.error(.init(id: "hello",
                                                                status: nil,
                                                                code: nil,
                                                                title: nil,
                                                                detail: nil,
                                                                source: nil))
        XCTAssertEqual(stringError.payload?.id, "hello")
        XCTAssertNotEqual(stringError, unknown1)

        let wellPopulatedError = BasicJSONAPIError<Int>.error(.init(id: 10,
                                                                    status: "404",
                                                                    code: "12",
                                                                    title: "Missing",
                                                                    detail: "Resource was not found",
                                                                    source: .init(pointer: "/data/attributes/id", parameter: "id")))
        XCTAssertEqual(wellPopulatedError.payload?.id, 10)
        XCTAssertEqual(wellPopulatedError.payload?.status, "404")
        XCTAssertEqual(wellPopulatedError.payload?.code, "12")
        XCTAssertEqual(wellPopulatedError.payload?.title, "Missing")
        XCTAssertEqual(wellPopulatedError.payload?.detail, "Resource was not found")
        XCTAssertEqual(wellPopulatedError.payload?.source?.pointer, "/data/attributes/id")
        XCTAssertEqual(wellPopulatedError.payload?.source?.parameter, "id")

        XCTAssertNotEqual(wellPopulatedError, intError)
    }

    func test_definedFields() {
        let unpopulatedError = BasicJSONAPIError<Int>.error(.init(id: nil,
                                                                  status: nil,
                                                                  code: nil,
                                                                  title: nil,
                                                                  detail: nil,
                                                                  source: nil))
        XCTAssertEqual(unpopulatedError.definedFields.count, 0)

        let wellPopulatedError = BasicJSONAPIError<Int>.error(.init(id: 10,
                                                                    status: "404",
                                                                    code: "12",
                                                                    title: "Missing",
                                                                    detail: "Resource was not found",
                                                                    source: .init(pointer: "/data/attributes/id", parameter: "id")))
        XCTAssertEqual(wellPopulatedError.definedFields.count, 7)
        XCTAssertEqual(wellPopulatedError.definedFields["id"], "10")
        XCTAssertEqual(wellPopulatedError.definedFields["status"], "404")
        XCTAssertEqual(wellPopulatedError.definedFields["code"], "12")
        XCTAssertEqual(wellPopulatedError.definedFields["title"], "Missing")
        XCTAssertEqual(wellPopulatedError.definedFields["detail"], "Resource was not found")
        XCTAssertEqual(wellPopulatedError.definedFields["pointer"], "/data/attributes/id")
        XCTAssertEqual(wellPopulatedError.definedFields["parameter"], "id")
    }
}
