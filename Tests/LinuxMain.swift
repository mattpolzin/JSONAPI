import XCTest

import JSONAPITests

var tests = [XCTestCaseEntry]()
tests += JSONAPITests.allTests()
XCTMain(tests)