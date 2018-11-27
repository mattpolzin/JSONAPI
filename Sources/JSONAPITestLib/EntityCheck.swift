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
	case badAttribute(named: String)
	case badRelationship(named: String)
	case badId
}

public struct EntityCheckErrors: Swift.Error {
	let problems: [EntityCheckError]
}

public protocol OptionalAttributeType {}

extension Optional: OptionalAttributeType where Wrapped: AttributeType {}

public extension Entity {
	public static func check(_ entity: Entity) throws {
		var problems = [EntityCheckError]()

		if Swift.type(of: entity.id).EntityDescription.self != Description.self {
			problems.append(.badId)
		}

		let attributesMirror = Mirror(reflecting: entity.attributes)

		if attributesMirror.displayStyle != .`struct` {
			problems.append(.attributesNotStruct)
		}

		for attribute in attributesMirror.children {
			if attribute.value as? AttributeType == nil,
				attribute.value as? OptionalAttributeType == nil {
				problems.append(.badAttribute(named: attribute.label ?? "unnamed"))
			}
		}

		let relationshipsMirror = Mirror(reflecting: entity.relationships)

		if relationshipsMirror.displayStyle != .`struct` {
			problems.append(.relationshipsNotStruct)
		}

		for relationship in relationshipsMirror.children {
			if relationship.value as? RelationshipType == nil {
				problems.append(.badRelationship(named: relationship.label ?? "unnamed"))
			}
		}

		guard problems.count == 0 else {
			throw EntityCheckErrors(problems: problems)
		}
	}
}
