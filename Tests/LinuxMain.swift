import XCTest

import JSONAPITests
import JSONAPITestLibTests

var tests = [XCTestCaseEntry]()
tests += JSONAPITests.__allTests()
tests += JSONAPITestLibTests.__allTests()

XCTMain(tests)
