//
//  ResourceObjectCheck.swift
//  JSONAPITesting
//
//  Created by Mathew Polzin on 11/27/18.
//

import JSONAPI

public enum ResourceObjectCheckError: Swift.Error {
    /// The attributes should live in a struct, not
    /// another type class.
    case attributesNotStruct

    /// The relationships should live in a struct, not
    /// another type class.
    case relationshipsNotStruct

    /// All stored properties on an Attributes struct should
    /// be one of the supplied Attribute types.
    case nonAttribute(named: String)

    /// All stored properties on a Relationships struct should
    /// be one of the supplied Relationship types.
    case nonRelationship(named: String)

    /// It is explicitly stated by the JSON spec
    /// a "none" value for arrays is an empty array, not `nil`.
    case nullArray(named: String)
}

public struct ResourceObjectCheckErrors: Swift.Error {
    let problems: [ResourceObjectCheckError]
}

private protocol OptionalAttributeType {}
extension Optional: OptionalAttributeType where Wrapped: AttributeType {}

private protocol OptionalArray {}
extension Optional: OptionalArray where Wrapped: ArrayType {}

private protocol AttributeTypeWithOptionalArray {}
extension TransformedAttribute: AttributeTypeWithOptionalArray where RawValue: OptionalArray {}
extension Attribute: AttributeTypeWithOptionalArray where RawValue: OptionalArray {}

private protocol OptionalRelationshipType {}
extension Optional: OptionalRelationshipType where Wrapped: RelationshipType {}

private protocol _RelationshipType {}
extension MetaRelationship: _RelationshipType {}
extension ToOneRelationship: _RelationshipType {}
extension ToManyRelationship: _RelationshipType {}

private protocol _AttributeType {}
extension TransformedAttribute: _AttributeType {}
extension Attribute: _AttributeType {}

public extension ResourceObject {
    static func check(_ entity: ResourceObject) throws {
        var problems = [ResourceObjectCheckError]()

        let attributesMirror = Mirror(reflecting: entity.attributes)

        if attributesMirror.displayStyle != .`struct` {
            problems.append(.attributesNotStruct)
        }

        for attribute in attributesMirror.children {
            if attribute.value as? _AttributeType == nil,
                attribute.value as? OptionalAttributeType == nil {
                problems.append(.nonAttribute(named: attribute.label ?? "unnamed"))
            }
            if attribute.value as? AttributeTypeWithOptionalArray != nil {
                problems.append(.nullArray(named: attribute.label ?? "unnamed"))
            }
        }

        let relationshipsMirror = Mirror(reflecting: entity.relationships)

        if relationshipsMirror.displayStyle != .`struct` {
            problems.append(.relationshipsNotStruct)
        }

        for relationship in relationshipsMirror.children {
            if relationship.value as? _RelationshipType == nil,
                relationship.value as? OptionalRelationshipType == nil {
                problems.append(.nonRelationship(named: relationship.label ?? "unnamed"))
            }
        }

        guard problems.count == 0 else {
            throw ResourceObjectCheckErrors(problems: problems)
        }
    }
}
