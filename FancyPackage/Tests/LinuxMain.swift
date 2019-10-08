import XCTest

import FancyPackageTests

var tests = [XCTestCaseEntry]()
tests += FancyPackageTests.allTests()
XCTMain(tests)
