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
	static public func rawOpenAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.RawValue.openAPINode().required {
			return try RawValue.RawValue.openAPINode().requiredNode().nullableNode()
		}
		return try RawValue.RawValue.openAPINode()
	}
}

extension Attribute: WrappedRawOpenAPIType where RawValue: RawOpenAPINodeType {
	public static func wrappedOpenAPINode() throws -> JSONNode {
		// If the RawValue is not required, we actually consider it
		// nullable. To be not required is for the Attribute itself
		// to be optional.
		if try !RawValue.rawOpenAPINode().required {
			return try RawValue.rawOpenAPINode().requiredNode().nullableNode()
		}
		return try RawValue.rawOpenAPINode()
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
	static func relationshipNode(nullable: Bool, jsonType: String) -> JSONNode {
		let propertiesDict: [String: JSONNode] = [
			"id": .string(.init(format: .generic,
								required: true),
						  .init()),
			"type": .string(.init(format: .generic,
								  required: true,
								  allowedValues: [.init(jsonType)]),
							.init())
		]

		return .object(.init(format: .generic,
							 required: true,
							 nullable: nullable),
					   .init(properties: propertiesDict))
	}
}

extension ToOneRelationship: OpenAPINodeType {
	// NOTE: const for json `type` not supported by OpenAPI 3.0
	//		Will use "enum" with one possible value for now.

	// TODO: metadata & links
	static public func openAPINode() throws -> JSONNode {
		let nullable = Identifiable.self is _Optional.Type
		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: [
						"data": ToOneRelationship.relationshipNode(nullable: nullable, jsonType: Identifiable.jsonType)
						]))
	}
}

extension ToManyRelationship: OpenAPINodeType {
	// NOTE: const for json `type` not supported by OpenAPI 3.0
	//		Will use "enum" with one possible value for now.

	// TODO: metadata & links
	static public func openAPINode() throws -> JSONNode {
		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: [
						"data": .array(.init(format: .generic,
											 required: true),
									   .init(items: ToManyRelationship.relationshipNode(nullable: false, jsonType: Relatable.jsonType)))
						]))
	}
}

extension Entity: OpenAPINodeType where Description.Attributes: Sampleable, Description.Relationships: Sampleable {
	public static func openAPINode() throws -> JSONNode {
		// NOTE: const for json `type` not supported by OpenAPI 3.0
		//		Will use "enum" with one possible value for now.

		// TODO: metadata, links

		let idNode = JSONNode.string(.init(format: .generic,
										   required: true),
									 .init())
		let idProperty = ("id", idNode)

		let typeNode = JSONNode.string(.init(format: .generic,
											 required: true,
											 allowedValues: [.init(Entity.jsonType)]),
									   .init())
		let typeProperty = ("type", typeNode)

		let attributesNode: JSONNode? = Description.Attributes.self == NoAttributes.self
			? nil
			: try Description.Attributes.genericObjectOpenAPINode()

		let attributesProperty = attributesNode.map { ("attributes", $0) }

		let relationshipsNode: JSONNode? = Description.Relationships.self == NoRelationships.self
			? nil
			: try Description.Relationships.genericObjectOpenAPINode()

		let relationshipsProperty = relationshipsNode.map { ("relationships", $0) }

		let propertiesDict = Dictionary([
			idProperty,
			typeProperty,
			attributesProperty,
			relationshipsProperty
			].compactMap { $0 }) { _, value in value }

		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: propertiesDict))
	}
}

extension SingleResourceBody: OpenAPINodeType where Entity: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return try Entity.openAPINode()
	}
}

extension ManyResourceBody: OpenAPINodeType where Entity: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		return .array(.init(format: .generic,
							required: true),
					  .init(items: try Entity.openAPINode()))
	}
}

extension Document: OpenAPINodeType where PrimaryResourceBody: OpenAPINodeType, IncludeType: OpenAPINodeType {
	public static func openAPINode() throws -> JSONNode {
		// TODO: metadata, links, api description, errors
		// TODO: represent data and errors as the two distinct possible outcomes

		let primaryDataNode: JSONNode? = try PrimaryResourceBody.openAPINode()

		let primaryDataProperty = primaryDataNode.map { ("data", $0) }

		let includeNode: JSONNode?
		do {
			includeNode = try Includes<Include>.openAPINode()
		} catch let err as OpenAPITypeError {
			guard err == .invalidNode else {
				throw err
			}
			includeNode = nil
		}

		let includeProperty = includeNode.map { ("included", $0) }

		let propertiesDict = Dictionary([
			primaryDataProperty,
			includeProperty
			].compactMap { $0 }) { _, value in value }

		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: propertiesDict))
	}
}
