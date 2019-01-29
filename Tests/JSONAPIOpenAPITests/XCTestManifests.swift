import XCTest

extension JSONAPIAttributeOpenAPITests {
    static let __allTests = [
        ("test_8601DateStringAttribute", test_8601DateStringAttribute),
        ("test_8601DateStringAttribute_Sampleable", test_8601DateStringAttribute_Sampleable),
        ("test_Arrayttribute", test_Arrayttribute),
        ("test_BooleanAttribute", test_BooleanAttribute),
        ("test_DateDeferredAttribute", test_DateDeferredAttribute),
        ("test_DateDeferredAttribute_Sampleable", test_DateDeferredAttribute_Sampleable),
        ("test_DateNumberAttribute", test_DateNumberAttribute),
        ("test_DateNumberAttribute_Sampleable", test_DateNumberAttribute_Sampleable),
        ("test_DateStringAttribute", test_DateStringAttribute),
        ("test_DateStringAttribute_Sampleable", test_DateStringAttribute_Sampleable),
        ("test_DateTimeStringAttribute", test_DateTimeStringAttribute),
        ("test_DateTimeStringAttribute_Sampleable", test_DateTimeStringAttribute_Sampleable),
        ("test_EnumAttribute", test_EnumAttribute),
        ("test_FloatNumberAttribute", test_FloatNumberAttribute),
        ("test_IntegerAttribute", test_IntegerAttribute),
        ("test_NullableArrayAttribute", test_NullableArrayAttribute),
        ("test_NullableBooleanAttribute", test_NullableBooleanAttribute),
        ("test_NullableDateAttribute", test_NullableDateAttribute),
        ("test_NullableEnumAttribute", test_NullableEnumAttribute),
        ("test_NullableIntegerAttribute", test_NullableIntegerAttribute),
        ("test_NullableNumberAttribute", test_NullableNumberAttribute),
        ("test_NullableStringAttribute", test_NullableStringAttribute),
        ("test_NumberAttribute", test_NumberAttribute),
        ("test_OptionalArrayAttribute", test_OptionalArrayAttribute),
        ("test_OptionalBooleanAttribute", test_OptionalBooleanAttribute),
        ("test_OptionalDateAttribute", test_OptionalDateAttribute),
        ("test_OptionalEnumAttribute", test_OptionalEnumAttribute),
        ("test_OptionalIntegerAttribute", test_OptionalIntegerAttribute),
        ("test_OptionalNullableArrayAttribute", test_OptionalNullableArrayAttribute),
        ("test_OptionalNullableBooleanAttribute", test_OptionalNullableBooleanAttribute),
        ("test_OptionalNullableDateAttribute", test_OptionalNullableDateAttribute),
        ("test_OptionalNullableEnumAttribute", test_OptionalNullableEnumAttribute),
        ("test_OptionalNullableIntegerAttribute", test_OptionalNullableIntegerAttribute),
        ("test_OptionalNullableNumberAttribute", test_OptionalNullableNumberAttribute),
        ("test_OptionalNullableStringAttribute", test_OptionalNullableStringAttribute),
        ("test_OptionalNumberAttribute", test_OptionalNumberAttribute),
        ("test_OptionalStringAttribute", test_OptionalStringAttribute),
        ("test_StringAttribute", test_StringAttribute),
    ]
}

extension JSONAPIDocumentOpenAPITests {
    static let __allTests = [
        ("test_DocumentWithOneIncludeType", test_DocumentWithOneIncludeType),
        ("test_DocumentWithTwoIncludeTypes", test_DocumentWithTwoIncludeTypes),
        ("test_ManyResourceDocument", test_ManyResourceDocument),
        ("test_SingleResourceDocument", test_SingleResourceDocument),
    ]
}

extension JSONAPIEntityOpenAPITests {
    static let __allTests = [
        ("test_AttributesAndRelationshipsEntity", test_AttributesAndRelationshipsEntity),
        ("test_AttributesEntity", test_AttributesEntity),
        ("test_EmptyEntity", test_EmptyEntity),
        ("test_RelationshipsEntity", test_RelationshipsEntity),
        ("test_UnidentifiedEmptyEntity", test_UnidentifiedEmptyEntity),
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

extension JSONAPITransformedAttributeOpenAPITests {
    static let __allTests = [
        ("test_8601DateStringAttribute", test_8601DateStringAttribute),
        ("test_8601DateStringAttribute_Sampleable", test_8601DateStringAttribute_Sampleable),
        ("test_Arrayttribute", test_Arrayttribute),
        ("test_BooleanAttribute", test_BooleanAttribute),
        ("test_DateDeferredAttribute", test_DateDeferredAttribute),
        ("test_DateDeferredAttribute_Sampleable", test_DateDeferredAttribute_Sampleable),
        ("test_DateNumberAttribute", test_DateNumberAttribute),
        ("test_DateNumberAttribute_Sampleable", test_DateNumberAttribute_Sampleable),
        ("test_DateStringAttribute", test_DateStringAttribute),
        ("test_DateStringAttribute_Sampleable", test_DateStringAttribute_Sampleable),
        ("test_DateTimeStringAttribute", test_DateTimeStringAttribute),
        ("test_DateTimeStringAttribute_Sampleable", test_DateTimeStringAttribute_Sampleable),
        ("test_EnumAttribute", test_EnumAttribute),
        ("test_FloatNumberAttribute", test_FloatNumberAttribute),
        ("test_IntegerAttribute", test_IntegerAttribute),
        ("test_NullableArrayAttribute", test_NullableArrayAttribute),
        ("test_NullableBooleanAttribute", test_NullableBooleanAttribute),
        ("test_NullableDateAttribute", test_NullableDateAttribute),
        ("test_NullableEnumAttribute", test_NullableEnumAttribute),
        ("test_NullableIntegerAttribute", test_NullableIntegerAttribute),
        ("test_NullableNumberAttribute", test_NullableNumberAttribute),
        ("test_NullableStringAttribute", test_NullableStringAttribute),
        ("test_NumberAttribute", test_NumberAttribute),
        ("test_OptionalArrayAttribute", test_OptionalArrayAttribute),
        ("test_OptionalBooleanAttribute", test_OptionalBooleanAttribute),
        ("test_OptionalDateAttribute", test_OptionalDateAttribute),
        ("test_OptionalEnumAttribute", test_OptionalEnumAttribute),
        ("test_OptionalIntegerAttribute", test_OptionalIntegerAttribute),
        ("test_OptionalNullableArrayAttribute", test_OptionalNullableArrayAttribute),
        ("test_OptionalNullableBooleanAttribute", test_OptionalNullableBooleanAttribute),
        ("test_OptionalNullableDateAttribute", test_OptionalNullableDateAttribute),
        ("test_OptionalNullableEnumAttribute", test_OptionalNullableEnumAttribute),
        ("test_OptionalNullableIntegerAttribute", test_OptionalNullableIntegerAttribute),
        ("test_OptionalNullableNumberAttribute", test_OptionalNullableNumberAttribute),
        ("test_OptionalNullableStringAttribute", test_OptionalNullableStringAttribute),
        ("test_OptionalNumberAttribute", test_OptionalNumberAttribute),
        ("test_OptionalStringAttribute", test_OptionalStringAttribute),
        ("test_StringAttribute", test_StringAttribute),
    ]
}

extension OpenAPITests {
    static let __allTests = [
        ("test_placeholder", test_placeholder),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(JSONAPIAttributeOpenAPITests.__allTests),
        testCase(JSONAPIDocumentOpenAPITests.__allTests),
        testCase(JSONAPIEntityOpenAPITests.__allTests),
        testCase(JSONAPIRelationshipsOpenAPITests.__allTests),
        testCase(JSONAPITransformedAttributeOpenAPITests.__allTests),
        testCase(OpenAPITests.__allTests),
    ]
}
#endif
