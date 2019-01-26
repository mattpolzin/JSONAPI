//
//  OpenAPITests.swift
//  JSONAPIOpenAPITests
//
//  Created by Mathew Polzin on 1/25/19.
//

import XCTest
import JSONAPI
import JSONAPIOpenAPI

class OpenAPITests: XCTestCase {

	func test_placeholder() {

		let schemaInfo = OpenAPISchema.Info(title: "Cool API", version: "0.1.0")

		let personResponse = OpenAPIResponse(description: "Successfully created a Person",
											 content: [
												.json: .init(schema: .init(JSONReference.node(.init(type: \.schemas, selector: "person"))))
			])

		let schemaPaths: [OpenAPISchema.PathComponents: OpenAPIPathItem] = [
			.init(["api","people"]):
			.operations(
				.init(parameters: [],
					  post: OpenAPIPathItem.PathProperties.Operation(
						summary: "",
						operationId: "createPerson",
						parameters: [],
						responses: [
							.status(code: 200): .init(personResponse)
						]
					)
				)
			)
		]

		let schemaComponents = OpenAPIComponents(schemas: ["person": .reference(.file("person.json"))],
												 parameters: [:])

		let openAPISchema = OpenAPISchema(info: schemaInfo,
										  paths: schemaPaths,
										  components: schemaComponents)

		let encoder = JSONEncoder()
		encoder.outputFormatting = .prettyPrinted

		print(String(data: try! encoder.encode(openAPISchema), encoding: .utf8)!)
	}

}
