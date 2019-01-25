//
//  JSONAPIOpenAPITypes.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/13/19.
//

import JSONAPI
import Foundation
import AnyCodable

private protocol _Optional {}
extension Optional: _Optional {}

private protocol Wrapper {
	associatedtype Wrapped
}
extension Optional: Wrapper {}

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
	public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
		return (try? allCases(from: Array(RawValue.allCases), using: encoder)) ?? []
	}
}

extension Attribute: AnyWrappedJSONCaseIterable where RawValue: AnyJSONCaseIterable {
	public static func allCases(using encoder: JSONEncoder) -> [AnyCodable] {
		return RawValue.allCases(using: encoder)
	}
}

extension Attribute: GenericOpenAPINodeType where RawValue: GenericOpenAPINodeType {
	public static func genericOpenAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try RawValue.genericOpenAPINode(using: encoder)
	}
}

extension Attribute: DateOpenAPINodeType where RawValue: DateOpenAPINodeType {
	public static func dateOpenAPINodeGuess(using encoder: JSONEncoder) -> JSONNode? {
		return RawValue.dateOpenAPINodeGuess(using: encoder)
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

// TODO: conform TransformedAttribute to all of the above protocols that Attribute conforms to.

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

extension Entity: OpenAPIEncodedNodeType, OpenAPINodeType where Description.Attributes: Sampleable, Description.Relationships: Sampleable {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
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
			: try Description.Attributes.genericOpenAPINode(using: encoder)

		let attributesProperty = attributesNode.map { ("attributes", $0) }

		let relationshipsNode: JSONNode? = Description.Relationships.self == NoRelationships.self
			? nil
			: try Description.Relationships.genericOpenAPINode(using: encoder)

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

extension SingleResourceBody: OpenAPIEncodedNodeType, OpenAPINodeType where Entity: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return try Entity.openAPINode(using: encoder)
	}
}

extension ManyResourceBody: OpenAPIEncodedNodeType, OpenAPINodeType where Entity: OpenAPIEncodedNodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		return .array(.init(format: .generic,
							required: true),
					  .init(items: try Entity.openAPINode(using: encoder)))
	}
}

extension Document: OpenAPIEncodedNodeType, OpenAPINodeType where PrimaryResourceBody: OpenAPIEncodedNodeType, IncludeType: OpenAPINodeType {
	public static func openAPINode(using encoder: JSONEncoder) throws -> JSONNode {
		// TODO: metadata, links, api description, errors
		// TODO: represent data and errors as the two distinct possible outcomes

		let primaryDataNode: JSONNode? = try PrimaryResourceBody.openAPINode(using: encoder)

		let primaryDataProperty = primaryDataNode.map { ("data", $0) }

		let includeNode: JSONNode?
		do {
			includeNode = try Includes<Include>.openAPINode()
		} catch let err as OpenAPITypeError {
			guard case .invalidNode = err else {
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
