import XCTest

extension PlaceholderTests {
    static let __allTests = [
        ("test_Placeholder", test_Placeholder),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(PlaceholderTests.__allTests),
    ]
}
#endif
