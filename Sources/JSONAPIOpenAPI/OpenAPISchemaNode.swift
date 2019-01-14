//
//  OpenAPISchemaNode.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/13/19.
//

extension OpenAPI {
	/// A single node in the schema. This is the
	struct SchemaNode {

		/// Indicates where the object is required
		/// or optional.
		let required: Bool

		/// This can be an empty Dictionary if there
		/// are no properties on this node.
		let properties: [String: SchemaNode]



		let title: String?
	}

	enum SchemaNodeType {
		case `enum`
	}
}
