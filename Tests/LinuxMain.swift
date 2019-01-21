import XCTest

import JSONAPITests
import JSONAPITestingTests
import JSONAPIOpenAPITests

var tests = [XCTestCaseEntry]()
tests += JSONAPITests.__allTests()
tests += JSONAPITestingTests.__allTests()
tests += JSONAPIOpenAPITests.__allTests()

XCTMain(tests)
