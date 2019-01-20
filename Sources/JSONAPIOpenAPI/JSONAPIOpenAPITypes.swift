//
//  JSONAPIOpenAPITypes.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/13/19.
//

import JSONAPI
import AnyCodable

private protocol _Optional {}
extension Optional: _Optional {}

extension Attribute: OpenAPINodeType where RawValue: OpenAPINodeType {
	static public func openAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.openAPINode().required {
			return try RawValue.openAPINode().requiredNode().nullableNode()
		}
		return try RawValue.openAPINode()
	}
}

extension Attribute: RawOpenAPINodeType where RawValue: RawRepresentable, RawValue.RawValue: OpenAPINodeType {
	static public func openAPINode() throws -> JSONNode {

		if try !RawValue.RawValue.openAPINode().required {
			return try RawValue.RawValue.openAPINode().requiredNode().nullableNode()
		}
		return try RawValue.RawValue.openAPINode()
	}
}

extension Attribute: AnyJSONCaseIterable where RawValue: CaseIterable, RawValue: Codable {
	public static var allCases: [AnyCodable] {
		return (try? allCases(from: Array(RawValue.allCases))) ?? []
	}
}

extension Attribute: AnyWrappedJSONCaseIterable where RawValue: AnyJSONCaseIterable {
	public static var allCases: [AnyCodable] {
		return RawValue.allCases
	}
}

extension TransformedAttribute: OpenAPINodeType where RawValue: OpenAPINodeType {
	static public func openAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.openAPINode().required {
			return try RawValue.openAPINode().requiredNode().nullableNode()
		}
		return try RawValue.openAPINode()
	}
}

extension RelationshipType {
	static func relationshipNode(nullable: Bool) -> JSONNode {
		let propertiesDict: [String: JSONNode] = [
			"id": .string(.init(format: .generic,
								required: true),
						  .init()),
			"type": .string(.init(format: .generic,
								  required: true),
							.init())
		]

		return .object(.init(format: .generic,
							 required: true,
							 nullable: nullable),
					   .init(properties: propertiesDict))
	}
}

extension ToOneRelationship: OpenAPINodeType {
	// TODO: const for json `type`
	// TODO: metadata & links
	static public func openAPINode() throws -> JSONNode {
		let nullable = Identifiable.self is _Optional.Type
		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: [
						"data": ToOneRelationship.relationshipNode(nullable: nullable)
						]))
	}
}

extension ToManyRelationship: OpenAPINodeType {
	// TODO: const for json `type`
	// TODO: metadata & links
	static public func openAPINode() throws -> JSONNode {
		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: [
						"data": .array(.init(format: .generic,
											 required: true),
									   .init(items: ToManyRelationship.relationshipNode(nullable: false)))
						]))
	}
}

extension Entity: OpenAPINodeType where Description.Attributes: Sampleable, Description.Relationships: Sampleable {
	public static func openAPINode() throws -> JSONNode {
		let attributesNode: JSONNode? = Description.Attributes.self == NoAttributes.self
			? nil
			: try Description.Attributes.genericObjectOpenAPINode()

		let attributesProperty = attributesNode.map { ("attributes", $0) }

		let relationshipsNode: JSONNode? = Description.Relationships.self == NoRelationships.self
			? nil
			: try Description.Relationships.genericObjectOpenAPINode()

		let relationshipsProperty = relationshipsNode.map { ("relationships", $0) }

		let propertiesDict = Dictionary([
			attributesProperty,
			relationshipsProperty
			].compactMap { $0 }) { _, value in value	}

		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: propertiesDict))
	}
}
