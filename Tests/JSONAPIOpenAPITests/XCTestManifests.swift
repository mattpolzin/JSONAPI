import XCTest

extension JSONAPIAttributeOpenAPITests {
    static let __allTests = [
        ("test_Arrayttribute", test_Arrayttribute),
        ("test_BooleanAttribute", test_BooleanAttribute),
        ("test_EnumAttribute", test_EnumAttribute),
        ("test_FloatNumberAttribute", test_FloatNumberAttribute),
        ("test_IntegerAttribute", test_IntegerAttribute),
        ("test_NullableArrayAttribute", test_NullableArrayAttribute),
        ("test_NullableBooleanAttribute", test_NullableBooleanAttribute),
        ("test_NullableEnumAttribute", test_NullableEnumAttribute),
        ("test_NullableIntegerAttribute", test_NullableIntegerAttribute),
        ("test_NullableNumberAttribute", test_NullableNumberAttribute),
        ("test_NullableStringAttribute", test_NullableStringAttribute),
        ("test_NumberAttribute", test_NumberAttribute),
        ("test_OptionalArrayAttribute", test_OptionalArrayAttribute),
        ("test_OptionalBooleanAttribute", test_OptionalBooleanAttribute),
        ("test_OptionalEnumAttribute", test_OptionalEnumAttribute),
        ("test_OptionalIntegerAttribute", test_OptionalIntegerAttribute),
        ("test_OptionalNullableArrayAttribute", test_OptionalNullableArrayAttribute),
        ("test_OptionalNullableBooleanAttribute", test_OptionalNullableBooleanAttribute),
        ("test_OptionalNullableEnumAttribute", test_OptionalNullableEnumAttribute),
        ("test_OptionalNullableIntegerAttribute", test_OptionalNullableIntegerAttribute),
        ("test_OptionalNullableNumberAttribute", test_OptionalNullableNumberAttribute),
        ("test_OptionalNullableStringAttribute", test_OptionalNullableStringAttribute),
        ("test_OptionalNumberAttribute", test_OptionalNumberAttribute),
        ("test_OptionalStringAttribute", test_OptionalStringAttribute),
        ("test_StringAttribute", test_StringAttribute),
    ]
}

extension JSONAPIEntityOpenAPITests {
    static let __allTests = [
        ("test_AttributesAndRelationshipsEntity", test_AttributesAndRelationshipsEntity),
        ("test_AttributesEntity", test_AttributesEntity),
        ("test_EmptyEntity", test_EmptyEntity),
        ("test_RelationshipsEntity", test_RelationshipsEntity),
    ]
}

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
        testCase(JSONAPIAttributeOpenAPITests.__allTests),
        testCase(JSONAPIEntityOpenAPITests.__allTests),
        testCase(JSONAPIRelationshipsOpenAPITests.__allTests),
    ]
}
#endif
