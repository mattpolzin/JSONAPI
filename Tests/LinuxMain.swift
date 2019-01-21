import XCTest

import JSONAPITests
import JSONAPITestingTests
import JSONAPIOpenAPITests
import JSONAPIArbitraryTests

var tests = [XCTestCaseEntry]()
tests += JSONAPITests.__allTests()
tests += JSONAPITestingTests.__allTests()
tests += JSONAPIOpenAPITests.__allTests()
tests += JSONAPIArbitraryTests.__allTests()

XCTMain(tests)
