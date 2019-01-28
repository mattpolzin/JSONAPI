//: [Previous](@previous)

import Foundation
import JSONAPI
import JSONAPIOpenAPI
import Poly

// print Entity Schema
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let personSchemaData = try? encoder.encode(Person.openAPINode(using: encoder))

print("Person Schema")
print("====")
print(personSchemaData.map { String(data: $0, encoding: .utf8)! } ?? "Schema Construction Failed")
print("====")

let dogDocumentSchemaData = try? encoder.encode(SingleDogDocument.openAPINodeWithExample(using: encoder))

print("Dog Document Schema")
print("====")
print(dogDocumentSchemaData.map { String(data: $0, encoding: .utf8)! } ?? "Schema Construction Failed")
print("====")

let batchPersonSchemaData = try? encoder.encode(BatchPeopleDocument.openAPINodeWithExample(using: encoder))

print("Batch Person Document Schema")
print("====")
print(batchPersonSchemaData.map { String(data: $0, encoding: .utf8)! } ?? "Schema Construction Failed")
print("====")

let tmp: [String: JSONNode] = [
	"BatchPerson": try! BatchPeopleDocument.openAPINodeWithExample(using: encoder)
]

let components = OpenAPIComponents(schemas: tmp, parameters: [:])

let batchPeopleRef = JSONReference.node(.init(type: \OpenAPIComponents.schemas, selector: "BatchPerson"))

let tmp2 = JSONNode.reference(batchPeopleRef)

print("====")
print("====")
//print(String(data: try! encoder.encode(components), encoding: .utf8)!)
print(String(data: try! encoder.encode(tmp2), encoding: .utf8)!)
