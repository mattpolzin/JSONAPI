import XCTest

extension DocumentTests {
    static let __allTests = [
        ("test_errorDocumentNoMeta", test_errorDocumentNoMeta),
        ("test_errorDocumentNoMeta_encode", test_errorDocumentNoMeta_encode),
        ("test_manyDocumentNoIncludes", test_manyDocumentNoIncludes),
        ("test_manyDocumentNoIncludes_encode", test_manyDocumentNoIncludes_encode),
        ("test_manyDocumentSomeIncludes", test_manyDocumentSomeIncludes),
        ("test_manyDocumentSomeIncludes_encode", test_manyDocumentSomeIncludes_encode),
        ("test_metaDataDocument", test_metaDataDocument),
        ("test_metaDataDocument_encode", test_metaDataDocument_encode),
        ("test_metaDocumentMissingMeta", test_metaDocumentMissingMeta),
        ("test_singleDocument_PolyPrimaryResource", test_singleDocument_PolyPrimaryResource),
        ("test_singleDocument_PolyPrimaryResource_encode", test_singleDocument_PolyPrimaryResource_encode),
        ("test_singleDocumentNoIncludes", test_singleDocumentNoIncludes),
        ("test_singleDocumentNoIncludes_encode", test_singleDocumentNoIncludes_encode),
        ("test_singleDocumentNoIncludesMissingMetadata", test_singleDocumentNoIncludesMissingMetadata),
        ("test_singleDocumentNoIncludesWithMetadata", test_singleDocumentNoIncludesWithMetadata),
        ("test_singleDocumentNoIncludesWithMetadata_encode", test_singleDocumentNoIncludesWithMetadata_encode),
        ("test_singleDocumentNull", test_singleDocumentNull),
        ("test_singleDocumentNull_encode", test_singleDocumentNull_encode),
        ("test_singleDocumentSomeIncludes", test_singleDocumentSomeIncludes),
        ("test_singleDocumentSomeIncludes_encode", test_singleDocumentSomeIncludes_encode),
        ("test_singleDocumentSomeIncludesWithMetadata", test_singleDocumentSomeIncludesWithMetadata),
        ("test_singleDocumentSomeIncludesWithMetadata_encode", test_singleDocumentSomeIncludesWithMetadata_encode),
        ("test_unknownErrorDocumentMissingMeta", test_unknownErrorDocumentMissingMeta),
        ("test_unknownErrorDocumentMissingMeta_encode", test_unknownErrorDocumentMissingMeta_encode),
        ("test_unknownErrorDocumentNoMeta", test_unknownErrorDocumentNoMeta),
        ("test_unknownErrorDocumentNoMeta_encode", test_unknownErrorDocumentNoMeta_encode),
        ("test_unknownErrorDocumentWithMeta", test_unknownErrorDocumentWithMeta),
        ("test_unknownErrorDocumentWithMeta_encode", test_unknownErrorDocumentWithMeta_encode),
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
        ("test_IntOver10_encode", test_IntOver10_encode),
        ("test_IntOver10_failure", test_IntOver10_failure),
        ("test_IntOver10_success", test_IntOver10_success),
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
        ("test_zeroIncludes_init", test_zeroIncludes_init),
    ]
}

extension PolyTests {
    static let __allTests = [
        ("test_init_Poly0", test_init_Poly0),
        ("test_init_Poly1", test_init_Poly1),
        ("test_init_Poly2", test_init_Poly2),
        ("test_init_Poly3", test_init_Poly3),
        ("test_init_Poly4", test_init_Poly4),
        ("test_init_Poly5", test_init_Poly5),
        ("test_init_Poly6", test_init_Poly6),
        ("test_Poly0_decode_throws", test_Poly0_decode_throws),
        ("test_Poly0_encode_throws", test_Poly0_encode_throws),
        ("test_Poly1_decode_throws_typeNotFound", test_Poly1_decode_throws_typeNotFound),
        ("test_Poly1_lookup", test_Poly1_lookup),
        ("test_Poly2_decode_throws_typeNotFound", test_Poly2_decode_throws_typeNotFound),
        ("test_Poly2_lookup", test_Poly2_lookup),
        ("test_Poly3_decode_throws_typeNotFound", test_Poly3_decode_throws_typeNotFound),
        ("test_Poly3_lookup", test_Poly3_lookup),
        ("test_Poly4_decode_throws_typeNotFound", test_Poly4_decode_throws_typeNotFound),
        ("test_Poly4_lookup", test_Poly4_lookup),
        ("test_Poly5_decode_throws_typeNotFound", test_Poly5_decode_throws_typeNotFound),
        ("test_Poly5_lookup", test_Poly5_lookup),
        ("test_Poly6_decode_throws_typeNotFound", test_Poly6_decode_throws_typeNotFound),
        ("test_Poly6_lookup", test_Poly6_lookup),
    ]
}

extension RelationshipTests {
    static let __allTests = [
        ("test_initToManyWithEntities", test_initToManyWithEntities),
        ("test_initToManyWithRelationships", test_initToManyWithRelationships),
        ("test_ToManyRelationship", test_ToManyRelationship),
        ("test_ToManyRelationship_encode", test_ToManyRelationship_encode),
        ("test_ToManyTypeMismatch", test_ToManyTypeMismatch),
        ("test_ToOneRelationship", test_ToOneRelationship),
        ("test_ToOneRelationship_encode", test_ToOneRelationship_encode),
        ("test_ToOneTypeMismatch", test_ToOneTypeMismatch),
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
        testCase(PolyTests.__allTests),
        testCase(RelationshipTests.__allTests),
        testCase(ResourceBodyTests.__allTests),
    ]
}
#endif
