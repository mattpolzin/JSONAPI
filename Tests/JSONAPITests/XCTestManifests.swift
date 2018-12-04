import XCTest

extension APIDescriptionTests {
    static let __allTests = [
        ("test_empty", test_empty),
        ("test_failsMissingMeta", test_failsMissingMeta),
        ("test_WithMeta", test_WithMeta),
        ("test_WithVersion", test_WithVersion),
        ("test_WithVersionAndMeta", test_WithVersionAndMeta),
    ]
}

extension AttributeTests {
    static let __allTests = [
        ("test_AttributeIsTransformedAttribute", test_AttributeIsTransformedAttribute),
        ("test_AttributeNonThrowingConstructor", test_AttributeNonThrowingConstructor),
        ("test_TransformedAttributeNoThrow", test_TransformedAttributeNoThrow),
        ("test_TransformedAttributeReversNoThrow", test_TransformedAttributeReversNoThrow),
        ("test_TransformedAttributeThrows", test_TransformedAttributeThrows),
    ]
}

extension Attribute_FunctorTests {
    static let __allTests = [
        ("test_mapGuaranteed", test_mapGuaranteed),
        ("test_mapOptionalFailure", test_mapOptionalFailure),
        ("test_mapOptionalSuccess", test_mapOptionalSuccess),
    ]
}

extension Attribute_LiteralTests {
    static let __allTests = [
        ("test_ArrayLiteral", test_ArrayLiteral),
        ("test_BooleanLiteral", test_BooleanLiteral),
        ("test_DictionaryLiteral", test_DictionaryLiteral),
        ("test_FloatLiteral", test_FloatLiteral),
        ("test_IntegerLiteral", test_IntegerLiteral),
        ("test_NilLiteral", test_NilLiteral),
        ("test_StringLiteral", test_StringLiteral),
    ]
}

extension ComputedPropertiesTests {
    static let __allTests = [
        ("test_ComputedAttributeAccess", test_ComputedAttributeAccess),
        ("test_ComputedRelationshipAccess", test_ComputedRelationshipAccess),
        ("test_DecodeIgnoresComputed", test_DecodeIgnoresComputed),
        ("test_EncodeIgnoresComputed", test_EncodeIgnoresComputed),
    ]
}

extension DocumentTests {
    static let __allTests = [
        ("test_errorDocumentFailsWithNoAPIDescription", test_errorDocumentFailsWithNoAPIDescription),
        ("test_errorDocumentNoMeta", test_errorDocumentNoMeta),
        ("test_errorDocumentNoMeta_encode", test_errorDocumentNoMeta_encode),
        ("test_errorDocumentNoMetaWithAPIDescription", test_errorDocumentNoMetaWithAPIDescription),
        ("test_errorDocumentNoMetaWithAPIDescription_encode", test_errorDocumentNoMetaWithAPIDescription_encode),
        ("test_manyDocumentNoIncludes", test_manyDocumentNoIncludes),
        ("test_manyDocumentNoIncludes_encode", test_manyDocumentNoIncludes_encode),
        ("test_manyDocumentNoIncludesWithAPIDescription", test_manyDocumentNoIncludesWithAPIDescription),
        ("test_manyDocumentNoIncludesWithAPIDescription_encode", test_manyDocumentNoIncludesWithAPIDescription_encode),
        ("test_manyDocumentSomeIncludes", test_manyDocumentSomeIncludes),
        ("test_manyDocumentSomeIncludes_encode", test_manyDocumentSomeIncludes_encode),
        ("test_manyDocumentSomeIncludesWithAPIDescription", test_manyDocumentSomeIncludesWithAPIDescription),
        ("test_manyDocumentSomeIncludesWithAPIDescription_encode", test_manyDocumentSomeIncludesWithAPIDescription_encode),
        ("test_metaDataDocument", test_metaDataDocument),
        ("test_metaDataDocument_encode", test_metaDataDocument_encode),
        ("test_metaDataDocumentFailsIfMissingAPIDescription", test_metaDataDocumentFailsIfMissingAPIDescription),
        ("test_metaDataDocumentWithAPIDescription", test_metaDataDocumentWithAPIDescription),
        ("test_metaDataDocumentWithAPIDescription_encode", test_metaDataDocumentWithAPIDescription_encode),
        ("test_metaDataDocumentWithLinks", test_metaDataDocumentWithLinks),
        ("test_metaDataDocumentWithLinks_encode", test_metaDataDocumentWithLinks_encode),
        ("test_metaDataDocumentWithLinksWithAPIDescription", test_metaDataDocumentWithLinksWithAPIDescription),
        ("test_metaDataDocumentWithLinksWithAPIDescription_encode", test_metaDataDocumentWithLinksWithAPIDescription_encode),
        ("test_metaDocumentMissingMeta", test_metaDocumentMissingMeta),
        ("test_singleDocument_PolyPrimaryResource", test_singleDocument_PolyPrimaryResource),
        ("test_singleDocument_PolyPrimaryResource_encode", test_singleDocument_PolyPrimaryResource_encode),
        ("test_singleDocument_PolyPrimaryResourceWithAPIDescription", test_singleDocument_PolyPrimaryResourceWithAPIDescription),
        ("test_singleDocument_PolyPrimaryResourceWithAPIDescription_encode", test_singleDocument_PolyPrimaryResourceWithAPIDescription_encode),
        ("test_singleDocumentNoIncludes", test_singleDocumentNoIncludes),
        ("test_singleDocumentNoIncludes_encode", test_singleDocumentNoIncludes_encode),
        ("test_singleDocumentNoIncludesMissingAPIDescription", test_singleDocumentNoIncludesMissingAPIDescription),
        ("test_singleDocumentNoIncludesMissingMetadata", test_singleDocumentNoIncludesMissingMetadata),
        ("test_singleDocumentNoIncludesOptionalNotNull", test_singleDocumentNoIncludesOptionalNotNull),
        ("test_singleDocumentNoIncludesOptionalNotNull_encode", test_singleDocumentNoIncludesOptionalNotNull_encode),
        ("test_singleDocumentNoIncludesOptionalNotNullWithAPIDescription", test_singleDocumentNoIncludesOptionalNotNullWithAPIDescription),
        ("test_singleDocumentNoIncludesOptionalNotNullWithAPIDescription_encode", test_singleDocumentNoIncludesOptionalNotNullWithAPIDescription_encode),
        ("test_singleDocumentNoIncludesWithAPIDescription", test_singleDocumentNoIncludesWithAPIDescription),
        ("test_singleDocumentNoIncludesWithAPIDescription_encode", test_singleDocumentNoIncludesWithAPIDescription_encode),
        ("test_singleDocumentNoIncludesWithLinks", test_singleDocumentNoIncludesWithLinks),
        ("test_singleDocumentNoIncludesWithLinks_encode", test_singleDocumentNoIncludesWithLinks_encode),
        ("test_singleDocumentNoIncludesWithLinksWithAPIDescription", test_singleDocumentNoIncludesWithLinksWithAPIDescription),
        ("test_singleDocumentNoIncludesWithLinksWithAPIDescription_encode", test_singleDocumentNoIncludesWithLinksWithAPIDescription_encode),
        ("test_singleDocumentNoIncludesWithMetadata", test_singleDocumentNoIncludesWithMetadata),
        ("test_singleDocumentNoIncludesWithMetadata_encode", test_singleDocumentNoIncludesWithMetadata_encode),
        ("test_singleDocumentNoIncludesWithMetadataMissingLinks", test_singleDocumentNoIncludesWithMetadataMissingLinks),
        ("test_singleDocumentNoIncludesWithMetadataWithAPIDescription", test_singleDocumentNoIncludesWithMetadataWithAPIDescription),
        ("test_singleDocumentNoIncludesWithMetadataWithAPIDescription_encode", test_singleDocumentNoIncludesWithMetadataWithAPIDescription_encode),
        ("test_singleDocumentNoIncludesWithMetadataWithLinks", test_singleDocumentNoIncludesWithMetadataWithLinks),
        ("test_singleDocumentNoIncludesWithMetadataWithLinks_encode", test_singleDocumentNoIncludesWithMetadataWithLinks_encode),
        ("test_singleDocumentNoIncludesWithMetadataWithLinksWithAPIDescription", test_singleDocumentNoIncludesWithMetadataWithLinksWithAPIDescription),
        ("test_singleDocumentNoIncludesWithMetadataWithLinksWithAPIDescription_encode", test_singleDocumentNoIncludesWithMetadataWithLinksWithAPIDescription_encode),
        ("test_singleDocumentNoIncludesWithSomeIncludesMetadataWithLinks_encode", test_singleDocumentNoIncludesWithSomeIncludesMetadataWithLinks_encode),
        ("test_singleDocumentNoIncludesWithSomeIncludesMetadataWithLinksWithAPIDescription_encode", test_singleDocumentNoIncludesWithSomeIncludesMetadataWithLinksWithAPIDescription_encode),
        ("test_singleDocumentNoIncludesWithSomeIncludesWithMetadataWithLinks", test_singleDocumentNoIncludesWithSomeIncludesWithMetadataWithLinks),
        ("test_singleDocumentNoIncludesWithSomeIncludesWithMetadataWithLinksWithAPIDescription", test_singleDocumentNoIncludesWithSomeIncludesWithMetadataWithLinksWithAPIDescription),
        ("test_singleDocumentNonOptionalFailsOnNull", test_singleDocumentNonOptionalFailsOnNull),
        ("test_singleDocumentNull", test_singleDocumentNull),
        ("test_singleDocumentNull_encode", test_singleDocumentNull_encode),
        ("test_singleDocumentNullFailsWithNoAPIDescription", test_singleDocumentNullFailsWithNoAPIDescription),
        ("test_singleDocumentNullWithAPIDescription", test_singleDocumentNullWithAPIDescription),
        ("test_singleDocumentNullWithAPIDescription_encode", test_singleDocumentNullWithAPIDescription_encode),
        ("test_singleDocumentSomeIncludes", test_singleDocumentSomeIncludes),
        ("test_singleDocumentSomeIncludes_encode", test_singleDocumentSomeIncludes_encode),
        ("test_singleDocumentSomeIncludesWithAPIDescription", test_singleDocumentSomeIncludesWithAPIDescription),
        ("test_singleDocumentSomeIncludesWithAPIDescription_encode", test_singleDocumentSomeIncludesWithAPIDescription_encode),
        ("test_singleDocumentSomeIncludesWithMetadata", test_singleDocumentSomeIncludesWithMetadata),
        ("test_singleDocumentSomeIncludesWithMetadata_encode", test_singleDocumentSomeIncludesWithMetadata_encode),
        ("test_singleDocumentSomeIncludesWithMetadataWithAPIDescription", test_singleDocumentSomeIncludesWithMetadataWithAPIDescription),
        ("test_singleDocumentSomeIncludesWithMetadataWithAPIDescription_encode", test_singleDocumentSomeIncludesWithMetadataWithAPIDescription_encode),
        ("test_unknownErrorDocumentMissingLinks", test_unknownErrorDocumentMissingLinks),
        ("test_unknownErrorDocumentMissingLinks_encode", test_unknownErrorDocumentMissingLinks_encode),
        ("test_unknownErrorDocumentMissingLinksWithAPIDescription", test_unknownErrorDocumentMissingLinksWithAPIDescription),
        ("test_unknownErrorDocumentMissingLinksWithAPIDescription_encode", test_unknownErrorDocumentMissingLinksWithAPIDescription_encode),
        ("test_unknownErrorDocumentMissingMeta", test_unknownErrorDocumentMissingMeta),
        ("test_unknownErrorDocumentMissingMeta_encode", test_unknownErrorDocumentMissingMeta_encode),
        ("test_unknownErrorDocumentMissingMetaWithAPIDescription", test_unknownErrorDocumentMissingMetaWithAPIDescription),
        ("test_unknownErrorDocumentMissingMetaWithAPIDescription_encode", test_unknownErrorDocumentMissingMetaWithAPIDescription_encode),
        ("test_unknownErrorDocumentNoMeta", test_unknownErrorDocumentNoMeta),
        ("test_unknownErrorDocumentNoMeta_encode", test_unknownErrorDocumentNoMeta_encode),
        ("test_unknownErrorDocumentNoMetaWithAPIDescription", test_unknownErrorDocumentNoMetaWithAPIDescription),
        ("test_unknownErrorDocumentNoMetaWithAPIDescription_encode", test_unknownErrorDocumentNoMetaWithAPIDescription_encode),
        ("test_unknownErrorDocumentWithLinks", test_unknownErrorDocumentWithLinks),
        ("test_unknownErrorDocumentWithLinks_encode", test_unknownErrorDocumentWithLinks_encode),
        ("test_unknownErrorDocumentWithLinksWithAPIDescription", test_unknownErrorDocumentWithLinksWithAPIDescription),
        ("test_unknownErrorDocumentWithLinksWithAPIDescription_encode", test_unknownErrorDocumentWithLinksWithAPIDescription_encode),
        ("test_unknownErrorDocumentWithMeta", test_unknownErrorDocumentWithMeta),
        ("test_unknownErrorDocumentWithMeta_encode", test_unknownErrorDocumentWithMeta_encode),
        ("test_unknownErrorDocumentWithMetaWithAPIDescription", test_unknownErrorDocumentWithMetaWithAPIDescription),
        ("test_unknownErrorDocumentWithMetaWithAPIDescription_encode", test_unknownErrorDocumentWithMetaWithAPIDescription_encode),
        ("test_unknownErrorDocumentWithMetaWithLinks", test_unknownErrorDocumentWithMetaWithLinks),
        ("test_unknownErrorDocumentWithMetaWithLinks_encode", test_unknownErrorDocumentWithMetaWithLinks_encode),
        ("test_unknownErrorDocumentWithMetaWithLinksWithAPIDescription", test_unknownErrorDocumentWithMetaWithLinksWithAPIDescription),
        ("test_unknownErrorDocumentWithMetaWithLinksWithAPIDescription_encode", test_unknownErrorDocumentWithMetaWithLinksWithAPIDescription_encode),
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
        ("test_EntitySomeRelationshipsSomeAttributesWithLinks", test_EntitySomeRelationshipsSomeAttributesWithLinks),
        ("test_EntitySomeRelationshipsSomeAttributesWithLinks_encode", test_EntitySomeRelationshipsSomeAttributesWithLinks_encode),
        ("test_EntitySomeRelationshipsSomeAttributesWithMeta", test_EntitySomeRelationshipsSomeAttributesWithMeta),
        ("test_EntitySomeRelationshipsSomeAttributesWithMeta_encode", test_EntitySomeRelationshipsSomeAttributesWithMeta_encode),
        ("test_EntitySomeRelationshipsSomeAttributesWithMetaAndLinks", test_EntitySomeRelationshipsSomeAttributesWithMetaAndLinks),
        ("test_EntitySomeRelationshipsSomeAttributesWithMetaAndLinks_encode", test_EntitySomeRelationshipsSomeAttributesWithMetaAndLinks_encode),
        ("test_initialization", test_initialization),
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
        ("test_UnidentifiedEntityWithAttributesAndLinks", test_UnidentifiedEntityWithAttributesAndLinks),
        ("test_UnidentifiedEntityWithAttributesAndLinks_encode", test_UnidentifiedEntityWithAttributesAndLinks_encode),
        ("test_UnidentifiedEntityWithAttributesAndMeta", test_UnidentifiedEntityWithAttributesAndMeta),
        ("test_UnidentifiedEntityWithAttributesAndMeta_encode", test_UnidentifiedEntityWithAttributesAndMeta_encode),
        ("test_UnidentifiedEntityWithAttributesAndMetaAndLinks", test_UnidentifiedEntityWithAttributesAndMetaAndLinks),
        ("test_UnidentifiedEntityWithAttributesAndMetaAndLinks_encode", test_UnidentifiedEntityWithAttributesAndMetaAndLinks_encode),
    ]
}

extension Id_LiteralTests {
    static let __allTests = [
        ("test_IntegerLiteral", test_IntegerLiteral),
        ("test_StringLiteral", test_StringLiteral),
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

extension LinksTests {
    static let __allTests = [
        ("test_linkFailsIfMetaNotFound", test_linkFailsIfMetaNotFound),
        ("test_linkWithMetadata", test_linkWithMetadata),
        ("test_linkWithMetadata_encode", test_linkWithMetadata_encode),
        ("test_linkWithNoMeta", test_linkWithNoMeta),
        ("test_linkWithNoMeta_encode", test_linkWithNoMeta_encode),
        ("test_linkWithNoMetaWithoutOptionalLink", test_linkWithNoMetaWithoutOptionalLink),
        ("test_linkWithNoMetaWithoutOptionalLink_encode", test_linkWithNoMetaWithoutOptionalLink_encode),
        ("test_linkWithNullMetadata", test_linkWithNullMetadata),
        ("test_linkWithNullMetadata_encode", test_linkWithNullMetadata_encode),
    ]
}

extension PolyProxyTests {
    static let __allTests = [
        ("test_AsymmetricEncodeDecodeUserA", test_AsymmetricEncodeDecodeUserA),
        ("test_AsymmetricEncodeDecodeUserB", test_AsymmetricEncodeDecodeUserB),
        ("test_generalReasonableness", test_generalReasonableness),
        ("test_UserAAndBEncodeEquality", test_UserAAndBEncodeEquality),
        ("test_UserADecode", test_UserADecode),
        ("test_UserBDecode", test_UserBDecode),
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

extension Relationship_LiteralTests {
    static let __allTests = [
        ("test_ArrayLiteral", test_ArrayLiteral),
        ("test_NilLiteral", test_NilLiteral),
        ("test_StringLiteral", test_StringLiteral),
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
        testCase(APIDescriptionTests.__allTests),
        testCase(AttributeTests.__allTests),
        testCase(Attribute_FunctorTests.__allTests),
        testCase(Attribute_LiteralTests.__allTests),
        testCase(ComputedPropertiesTests.__allTests),
        testCase(DocumentTests.__allTests),
        testCase(EntityCheckTests.__allTests),
        testCase(EntityTests.__allTests),
        testCase(Id_LiteralTests.__allTests),
        testCase(IncludedTests.__allTests),
        testCase(LinksTests.__allTests),
        testCase(PolyProxyTests.__allTests),
        testCase(PolyTests.__allTests),
        testCase(RelationshipTests.__allTests),
        testCase(Relationship_LiteralTests.__allTests),
        testCase(ResourceBodyTests.__allTests),
    ]
}
#endif
