//
//  Sampleable.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/15/19.
//

import JSONAPI
import AnyCodable

/// A Sampleable type can provide a sample value.
/// This is useful for reflection.
public protocol Sampleable {
	static var sample: Self { get }
}

extension Sampleable {
	public static func genericObjectOpenAPINode() throws -> JSONNode {
		let mirror = Mirror(reflecting: Self.sample)
		let properties: [(String, JSONNode)] = try mirror.children.compactMap { child in

			// see if we can enumerate the possible values
			let maybeAllCases: [AnyCodable]? = {
				switch type(of: child.value) {
				case let valType as AnyJSONCaseIterable.Type:
					return valType.allCases
				case let valType as AnyWrappedJSONCaseIterable.Type:
					return valType.allCases
				default:
					return nil
				}
			}()

			// try to snag an OpenAPI Node
			let maybeOpenAPINode: JSONNode? = try {
				switch type(of: child.value) {
				case let valType as OpenAPINodeType.Type:
					return try valType.openAPINode()

				case let valType as RawOpenAPINodeType.Type:
					return try valType.openAPINode()

				default:
					return nil
				}
			}()

			// put it all together
			let newNode: JSONNode?
			if let allCases = maybeAllCases,
				let openAPINode = maybeOpenAPINode {
				newNode = try openAPINode.with(allowedValues: allCases) // try {
//					if let cases = allCases as? [JSONTypeFormat.BooleanFormat.SwiftType] {
//						return try openAPINode.with(allowedValues: cases)
//
//					}  else if let cases = allCases as? [JSONTypeFormat.ArrayFormat.SwiftType] {
//						return try openAPINode.with(allowedValues: cases)
//
//					} else if let cases = allCases as? [JSONTypeFormat.ObjectFormat.SwiftType] {
//						return try openAPINode.with(allowedValues: cases)
//
//					} else if let cases = allCases as?  [JSONTypeFormat.NumberFormat.SwiftType] {
//						return try openAPINode.with(allowedValues: cases)
//
//					} else if let cases = allCases as?  [JSONTypeFormat.IntegerFormat.SwiftType] {
//						return try openAPINode.with(allowedValues: cases)
//
//					} else if let cases = allCases as?  [JSONTypeFormat.StringFormat.SwiftType] {
//						return try openAPINode.with(allowedValues: cases)
//
//					} else if allCases.compactMap({ $0 as? RawStringRepresentable }).count == allCases.count {
//						return try openAPINode.with(allowedValues: allCases.compactMap { ($0 as? RawStringRepresentable)?.rawValue })
//
//					} else {
//						throw SampleableError.allowedValuesNotOfExpectedType(forNode: openAPINode, allowedValues: allCases)
//					}
//				}()
			} else {
				newNode = maybeOpenAPINode
			}

			return zip(child.label, newNode) { ($0, $1) }
		}

		// There should not be any duplication of keys since these are
		// property names, but rather than risk runtime exception, we just
		// fail to the newer value arbitrarily
		let propertiesDict = Dictionary(properties) { _, value2 in value2 }

		return .object(.init(format: .generic,
							 required: true),
					   .init(properties: propertiesDict))
	}
}

extension NoAttributes: Sampleable {
	public static var sample: NoAttributes {
		return .none
	}
}

extension NoRelationships: Sampleable {
	public static var sample: NoRelationships {
		return .none
	}
}

extension NoMetadata: Sampleable {
	public static var sample: NoMetadata {
		return .none
	}
}

extension NoLinks: Sampleable {
	public static var sample: NoLinks {
		return .none
	}
}

public enum SampleableError: Swift.Error {
	case allowedValuesNotOfExpectedType(forNode: JSONNode, allowedValues: [Any])
}
