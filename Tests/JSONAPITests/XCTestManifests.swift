import XCTest

extension DocumentTests {
    static let __allTests = [
        ("test_manyDocumentNoIncludes", test_manyDocumentNoIncludes),
        ("test_manyDocumentNoIncludes_encode", test_manyDocumentNoIncludes_encode),
        ("test_manyDocumentSomeIncludes", test_manyDocumentSomeIncludes),
        ("test_manyDocumentSomeIncludes_encode", test_manyDocumentSomeIncludes_encode),
        ("test_singleDocumentNoIncludes", test_singleDocumentNoIncludes),
        ("test_singleDocumentNoIncludes_encode", test_singleDocumentNoIncludes_encode),
        ("test_singleDocumentNull", test_singleDocumentNull),
        ("test_singleDocumentNull_encode", test_singleDocumentNull_encode),
        ("test_singleDocumentSomeIncludes", test_singleDocumentSomeIncludes),
        ("test_singleDocumentSomeIncludes_encode", test_singleDocumentSomeIncludes_encode),
    ]
}

extension EntityTests {
    static let __allTests = [
        ("test_entityAllAttribute", test_entityAllAttribute),
        ("test_entityAllAttribute_encode", test_entityAllAttribute_encode),
        ("test_entityBrokenNullableOmittedAttribute", test_entityBrokenNullableOmittedAttribute),
        ("test_EntityNoRelationshipsNoAttributes", test_EntityNoRelationshipsNoAttributes),
        ("test_EntityNoRelationshipsNoAttributes_encode", test_EntityNoRelationshipsNoAttributes_encode),
        ("test_EntityNoRelationshipsSomeAttributes", test_EntityNoRelationshipsSomeAttributes),
        ("test_EntityNoRelationshipsSomeAttributes_encode", test_EntityNoRelationshipsSomeAttributes_encode),
        ("test_entityOneNullAndOneOmittedAttribute", test_entityOneNullAndOneOmittedAttribute),
        ("test_entityOneNullAndOneOmittedAttribute_encode", test_entityOneNullAndOneOmittedAttribute_encode),
        ("test_entityOneNullAttribute", test_entityOneNullAttribute),
        ("test_entityOneNullAttribute_encode", test_entityOneNullAttribute_encode),
        ("test_entityOneOmittedAttribute", test_entityOneOmittedAttribute),
        ("test_entityOneOmittedAttribute_encode", test_entityOneOmittedAttribute_encode),
        ("test_EntitySomeRelationshipsNoAttributes", test_EntitySomeRelationshipsNoAttributes),
        ("test_EntitySomeRelationshipsNoAttributes_encode", test_EntitySomeRelationshipsNoAttributes_encode),
        ("test_EntitySomeRelationshipsSomeAttributes", test_EntitySomeRelationshipsSomeAttributes),
        ("test_EntitySomeRelationshipsSomeAttributes_encode", test_EntitySomeRelationshipsSomeAttributes_encode),
        ("test_IntToString", test_IntToString),
        ("test_IntToString_encode", test_IntToString_encode),
        ("test_NonNullOptionalNullableAttribute", test_NonNullOptionalNullableAttribute),
        ("test_NonNullOptionalNullableAttribute_encode", test_NonNullOptionalNullableAttribute_encode),
        ("test_nullableRelationshipIsNull", test_nullableRelationshipIsNull),
        ("test_nullableRelationshipIsNull_encode", test_nullableRelationshipIsNull_encode),
        ("test_nullableRelationshipNotNull", test_nullableRelationshipNotNull),
        ("test_nullableRelationshipNotNull_encode", test_nullableRelationshipNotNull_encode),
        ("test_NullOptionalNullableAttribute", test_NullOptionalNullableAttribute),
        ("test_NullOptionalNullableAttribute_encode", test_NullOptionalNullableAttribute_encode),
        ("test_relationship_access", test_relationship_access),
        ("test_relationship_operator_access", test_relationship_operator_access),
        ("test_relationshipIds", test_relationshipIds),
        ("test_RleationshipsOfSameType", test_RleationshipsOfSameType),
        ("test_RleationshipsOfSameType_encode", test_RleationshipsOfSameType_encode),
        ("test_toMany_relationship_operator_access", test_toMany_relationship_operator_access),
        ("test_UnidentifiedEntity", test_UnidentifiedEntity),
        ("test_UnidentifiedEntity_encode", test_UnidentifiedEntity_encode),
        ("test_UnidentifiedEntityWithAttributes", test_UnidentifiedEntityWithAttributes),
        ("test_UnidentifiedEntityWithAttributes_encode", test_UnidentifiedEntityWithAttributes_encode),
    ]
}

extension IncludedTests {
    static let __allTests = [
        ("test_FiveDifferentIncludes", test_FiveDifferentIncludes),
        ("test_FiveDifferentIncludes_encode", test_FiveDifferentIncludes_encode),
        ("test_FourDifferentIncludes", test_FourDifferentIncludes),
        ("test_FourDifferentIncludes_encode", test_FourDifferentIncludes_encode),
        ("test_OneInclude", test_OneInclude),
        ("test_OneInclude_encode", test_OneInclude_encode),
        ("test_SixDifferentIncludes", test_SixDifferentIncludes),
        ("test_SixDifferentIncludes_encode", test_SixDifferentIncludes_encode),
        ("test_ThreeDifferentIncludes", test_ThreeDifferentIncludes),
        ("test_ThreeDifferentIncludes_encode", test_ThreeDifferentIncludes_encode),
        ("test_TwoDifferentIncludes", test_TwoDifferentIncludes),
        ("test_TwoDifferentIncludes_encode", test_TwoDifferentIncludes_encode),
        ("test_TwoSameIncludes", test_TwoSameIncludes),
        ("test_TwoSameIncludes_encode", test_TwoSameIncludes_encode),
        ("test_zeroIncludes", test_zeroIncludes),
        ("test_zeroIncludes_encode", test_zeroIncludes_encode),
    ]
}

extension RelationshipTests {
    static let __allTests = [
        ("test_initToManyWithEntities", test_initToManyWithEntities),
        ("test_initToManyWithRelationships", test_initToManyWithRelationships),
        ("test_ToManyRelationship", test_ToManyRelationship),
        ("test_ToManyRelationship_encode", test_ToManyRelationship_encode),
        ("test_ToOneRelationship", test_ToOneRelationship),
        ("test_ToOneRelationship_encode", test_ToOneRelationship_encode),
    ]
}

extension ResourceBodyTests {
    static let __allTests = [
        ("test_manyResourceBody", test_manyResourceBody),
        ("test_manyResourceBody_encode", test_manyResourceBody_encode),
        ("test_manyResourceBodyEmpty", test_manyResourceBodyEmpty),
        ("test_manyResourceBodyEmpty_encode", test_manyResourceBodyEmpty_encode),
        ("test_singleResourceBody", test_singleResourceBody),
        ("test_singleResourceBody_encode", test_singleResourceBody_encode),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(DocumentTests.__allTests),
        testCase(EntityTests.__allTests),
        testCase(IncludedTests.__allTests),
        testCase(RelationshipTests.__allTests),
        testCase(ResourceBodyTests.__allTests),
    ]
}
#endif
