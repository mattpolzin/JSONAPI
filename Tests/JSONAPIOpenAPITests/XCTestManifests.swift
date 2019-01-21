import XCTest

extension JSONAPIRelationshipsOpenAPITests {
    static let __allTests = [
        ("test_NullableToOne", test_NullableToOne),
        ("test_OptionalNullableToOne", test_OptionalNullableToOne),
        ("test_OptionalToMany", test_OptionalToMany),
        ("test_OptionalToOne", test_OptionalToOne),
        ("test_ToMany", test_ToMany),
        ("test_ToOne", test_ToOne),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(JSONAPIRelationshipsOpenAPITests.__allTests),
    ]
}
#endif
