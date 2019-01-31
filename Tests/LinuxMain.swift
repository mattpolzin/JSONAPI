import XCTest

import JSONAPITests
import JSONAPITestingTests

var tests = [XCTestCaseEntry]()
tests += JSONAPITests.__allTests()
tests += JSONAPITestingTests.__allTests()

XCTMain(tests)
