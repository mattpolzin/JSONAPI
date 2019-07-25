import XCTest

import JSONAPITestingTests
import JSONAPITests

var tests = [XCTestCaseEntry]()
tests += JSONAPITestingTests.__allTests()
tests += JSONAPITests.__allTests()

XCTMain(tests)
