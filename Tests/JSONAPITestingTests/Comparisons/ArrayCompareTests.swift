//
//  ArrayCompareTests.swift
//  JSONAPITestingTests
//
//  Created by Mathew Polzin on 11/14/19.
//

import XCTest
@testable import JSONAPITesting

final class ArrayCompareTests: XCTestCase {
    func test_same() {
        let arr1 = ["a", "b", "c"]
        let arr2 = ["a", "b", "c"]

        let comparison = arr1.compare(to: arr2) { str1, str2 in
            str1 == str2 ? .same : .differentValues(str1, str2)
        }

        XCTAssertEqual(
            comparison,
            [.same, .same, .same]
        )

        XCTAssertEqual(comparison.map(\.description), ["same", "same", "same"])

        XCTAssertEqual(comparison.map(BasicComparison.init(reducing:)), [.same, .same, .same])

        XCTAssertEqual(comparison.map(BasicComparison.init(reducing:)).map(\.description), ["same", "same", "same"])
    }

    func test_differentLengths() {
        let arr1 = ["a", "b", "c"]
        let arr2 = ["a", "b"]

        let comparison1 = arr1.compare(to: arr2) { str1, str2 in
            str1 == str2 ? .same : .differentValues(str1, str2)
        }

        XCTAssertEqual(
            comparison1,
            [.same, .same, .missing]
        )

        XCTAssertEqual(comparison1.map(\.description), ["same", "same", "missing"])

        XCTAssertEqual(comparison1.map(BasicComparison.init(reducing:)), [.same, .same, .different("array length 1", "array length 2")])

        let comparison2 = arr2.compare(to: arr1) { str1, str2 in
            str1 == str2 ? .same : .differentValues(str1, str2)
        }

        XCTAssertEqual(
            comparison2,
            [.same, .same, .missing]
        )

        XCTAssertEqual(comparison2.map(\.description), ["same", "same", "missing"])

        XCTAssertEqual(comparison2.map(BasicComparison.init(reducing:)), [.same, .same, .different("array length 1", "array length 2")])
    }

    func test_differentValues() {
        let arr1 = ["c", "b", "a"]
        let arr2 = ["a", "b", "c"]

        let comparison = arr1.compare(to: arr2) { str1, str2 in
            str1 == str2 ? .same : .differentValues(str1, str2)
        }

        XCTAssertEqual(
            comparison,
            [.differentValues("c", "a"), .same, .differentValues("a", "c")]
        )

        XCTAssertEqual(comparison.map(\.description), ["c ≠ a", "same", "a ≠ c"])
    }

    func test_reducePrebuilt() {
        let prebuilt = ArrayElementComparison.prebuilt("hello world")

        XCTAssertEqual(BasicComparison(reducing: prebuilt), .prebuilt("hello world"))

        XCTAssertEqual(BasicComparison(reducing: prebuilt).description, "hello world")
    }
}
