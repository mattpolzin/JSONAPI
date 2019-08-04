//
//  TransformerTests.swift
//  
//
//  Created by Mathew Polzin on 8/2/19.
//

import XCTest
import JSONAPI
import JSONAPITesting

class TransformerTests: XCTestCase {
    func testIdentityTransform() {
        let inString = "hello world"

        XCTAssertNoThrow(try IdentityTransformer.transform(inString))
        XCTAssertEqual(inString, try? IdentityTransformer.transform(inString))

        XCTAssertNoThrow(try IdentityTransformer.reverse(inString))
        XCTAssertEqual(inString, try? IdentityTransformer.reverse(inString))
    }

    func testValidator() {
        let string1 = "hello"
        let string2 = "hello world"

        XCTAssertThrowsError(try MoreThanFiveCharValidator.validate(string1))
        XCTAssertThrowsError(try MoreThanFiveCharValidator.transform(string1))
        XCTAssertThrowsError(try MoreThanFiveCharValidator.reverse(string1))

        XCTAssertNoThrow(try MoreThanFiveCharValidator.validate(string2))
        XCTAssertNoThrow(try MoreThanFiveCharValidator.transform(string2))
        XCTAssertNoThrow(try MoreThanFiveCharValidator.reverse(string2))

        XCTAssertEqual(string2, try MoreThanFiveCharValidator.transform(string2))
        XCTAssertEqual(string2, try MoreThanFiveCharValidator.reverse(string2))
    }
}

enum MoreThanFiveCharValidator: Validator {
    public static func transform(_ value: String) throws -> String {
        guard value.count > 5 else {
            throw Error.fewerThanFiveChars
        }
        return value
    }

    enum Error: Swift.Error {
        case fewerThanFiveChars
    }
}
