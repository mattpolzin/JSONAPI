import XCTest

extension Attribute_LiteralTests {
    static let __allTests = [
        ("test_ArrayLiteral", test_ArrayLiteral),
        ("test_BooleanLiteral", test_BooleanLiteral),
        ("test_DictionaryLiteral", test_DictionaryLiteral),
        ("test_FloatLiteral", test_FloatLiteral),
        ("test_IntegerLiteral", test_IntegerLiteral),
        ("test_NilLiteral", test_NilLiteral),
        ("test_NullableArrayLiteral", test_NullableArrayLiteral),
        ("test_NullableBooleanLiteral", test_NullableBooleanLiteral),
        ("test_NullableDictionaryLiteral", test_NullableDictionaryLiteral),
        ("test_NullableFloatLiteral", test_NullableFloatLiteral),
        ("test_NullableIntegerLiteral", test_NullableIntegerLiteral),
        ("test_NullableOptionalArrayLiteral", test_NullableOptionalArrayLiteral),
        ("test_NullableOptionalBooleanLiteral", test_NullableOptionalBooleanLiteral),
        ("test_NullableOptionalDictionaryLiteral", test_NullableOptionalDictionaryLiteral),
        ("test_NullableOptionalFloatLiteral", test_NullableOptionalFloatLiteral),
        ("test_NullableOptionalIntegerLiteral", test_NullableOptionalIntegerLiteral),
        ("test_NullableOptionalStringLiteral", test_NullableOptionalStringLiteral),
        ("test_NullableStringLiteral", test_NullableStringLiteral),
        ("test_OptionalArrayLiteral", test_OptionalArrayLiteral),
        ("test_OptionalBooleanLiteral", test_OptionalBooleanLiteral),
        ("test_OptionalDictionaryLiteral", test_OptionalDictionaryLiteral),
        ("test_OptionalFloatLiteral", test_OptionalFloatLiteral),
        ("test_OptionalIntegerLiteral", test_OptionalIntegerLiteral),
        ("test_OptionalNilLiteral", test_OptionalNilLiteral),
        ("test_OptionalStringLiteral", test_OptionalStringLiteral),
        ("test_StringLiteral", test_StringLiteral),
    ]
}

extension EntityCheckTests {
    static let __allTests = [
        ("test_failsWithBadAttribute", test_failsWithBadAttribute),
        ("test_failsWithBadRelationship", test_failsWithBadRelationship),
        ("test_failsWithEnumAttributes", test_failsWithEnumAttributes),
        ("test_failsWithEnumRelationships", test_failsWithEnumRelationships),
        ("test_failsWithOptionalArrayAttribute", test_failsWithOptionalArrayAttribute),
    ]
}

extension Id_LiteralTests {
    static let __allTests = [
        ("test_IntegerLiteral", test_IntegerLiteral),
        ("test_StringLiteral", test_StringLiteral),
    ]
}

extension Relationship_LiteralTests {
    static let __allTests = [
        ("test_ArrayLiteral", test_ArrayLiteral),
        ("test_NilLiteral", test_NilLiteral),
        ("test_StringLiteral", test_StringLiteral),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Attribute_LiteralTests.__allTests),
        testCase(EntityCheckTests.__allTests),
        testCase(Id_LiteralTests.__allTests),
        testCase(Relationship_LiteralTests.__allTests),
    ]
}
#endif
