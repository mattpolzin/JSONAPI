//
//  EntityCheck.swift
//  JSONAPITestLib
//
//  Created by Mathew Polzin on 11/27/18.
//

import JSONAPI

public enum EntityCheckError: Swift.Error {
	case attributesNotStruct
	case relationshipsNotStruct
	case nonAttribute(named: String)
	case nonRelationship(named: String)
	case nullArray(named: String)
	case badId
}

public struct EntityCheckErrors: Swift.Error {
	let problems: [EntityCheckError]
}

private protocol OptionalAttributeType {}
extension Optional: OptionalAttributeType where Wrapped: AttributeType {}

private protocol OptionalArray {}
extension Optional: OptionalArray where Wrapped: ArrayType {}

private protocol AttributeTypeWithOptionalArray {}
extension TransformedAttribute: AttributeTypeWithOptionalArray where RawValue: OptionalArray {}

private protocol OptionalRelationshipType {}
extension Optional: OptionalRelationshipType where Wrapped: RelationshipType {}

public extension Entity {
	public static func check(_ entity: Entity) throws {
		var problems = [EntityCheckError]()

		if Swift.type(of: entity.id).EntityType.Description.self != Description.self {
			problems.append(.badId)
		}

		let attributesMirror = Mirror(reflecting: entity.attributes)

		if attributesMirror.displayStyle != .`struct` {
			problems.append(.attributesNotStruct)
		}

		for attribute in attributesMirror.children {
			if attribute.value as? AttributeType == nil,
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
			if relationship.value as? RelationshipType == nil {
				problems.append(.nonRelationship(named: relationship.label ?? "unnamed"))
			}
		}

		guard problems.count == 0 else {
			throw EntityCheckErrors(problems: problems)
		}
	}
}
