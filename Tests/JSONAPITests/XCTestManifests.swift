import XCTest

extension DocumentTests {
    static let __allTests = [
        ("test_manyDocumentNoIncludes", test_manyDocumentNoIncludes),
        ("test_manyDocumentSomeIncludes", test_manyDocumentSomeIncludes),
        ("test_singleDocumentNoIncludes", test_singleDocumentNoIncludes),
        ("test_singleDocumentSomeIncludes", test_singleDocumentSomeIncludes),
    ]
}

extension EntityTests {
    static let __allTests = [
        ("test_EntityNoRelationshipsNoAttributes", test_EntityNoRelationshipsNoAttributes),
        ("test_EntityNoRelationshipsSomeAttributes", test_EntityNoRelationshipsSomeAttributes),
        ("test_EntitySomeRelationshipsNoAttributes", test_EntitySomeRelationshipsNoAttributes),
        ("test_EntitySomeRelationshipsSomeAttributes", test_EntitySomeRelationshipsSomeAttributes),
        ("test_relationship_access", test_relationship_access),
        ("test_relationship_operator_access", test_relationship_operator_access),
        ("test_relationshipIds", test_relationshipIds),
        ("test_toMany_relationship_operator_access", test_toMany_relationship_operator_access),
    ]
}

extension IncludedTests {
    static let __allTests = [
        ("test_FiveDifferentIncludes", test_FiveDifferentIncludes),
        ("test_FourDifferentIncludes", test_FourDifferentIncludes),
        ("test_OneInclude", test_OneInclude),
        ("test_SixDifferentIncludes", test_SixDifferentIncludes),
        ("test_ThreeDifferentIncludes", test_ThreeDifferentIncludes),
        ("test_TwoDifferentIncludes", test_TwoDifferentIncludes),
        ("test_TwoSameIncludes", test_TwoSameIncludes),
    ]
}

extension RelationshipTests {
    static let __allTests = [
        ("test_initToManyWithEntities", test_initToManyWithEntities),
        ("test_initToManyWithRelationships", test_initToManyWithRelationships),
        ("test_ToManyRelationship", test_ToManyRelationship),
        ("test_ToOneRelationship", test_ToOneRelationship),
    ]
}

extension ResourceBodyTests {
    static let __allTests = [
        ("test_manyResourceBody", test_manyResourceBody),
        ("test_singleResourceBody", test_singleResourceBody),
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
