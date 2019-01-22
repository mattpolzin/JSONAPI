//: [Previous](@previous)

import Foundation
import JSONAPI
import JSONAPIOpenAPI

// print Entity Schema
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

let personSchemaData = try? encoder.encode(Person.openAPINode())

print("Person Schema")
print("====")
print(personSchemaData.map { String(data: $0, encoding: .utf8)! } ?? "Schema Construction Failed")
print("====")

let dogDocumentSchemaData = try? encoder.encode(SingleDogDocument.openAPINodeWithExample())

print("Dog Document Schema")
print("====")
print(dogDocumentSchemaData.map { String(data: $0, encoding: .utf8)! } ?? "Schema Construction Failed")
print("====")
