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
	/// Get a sample value of type Self. This can be the
	/// same value every time, or it can be an arbitrarily random
	/// value each time.
	static var sample: Self { get }

	/// Get an example of success, if that is meaningful and
	/// available. If not, will be nil.
	static var successSample: Self? { get }

	/// Get an example of failure, if that is meaningful and
	/// available. If not, will be nil.
	static var failureSample: Self? { get }
}

public extension Sampleable {
	public static var successSample: Self? { return nil }

	public static var failureSample: Self? { return nil }
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
					return try valType.rawOpenAPINode()

				case let valType as WrappedRawOpenAPIType.Type:
					return try valType.wrappedOpenAPINode()

				case let valType as DoubleWrappedRawOpenAPIType.Type:
					return try valType.wrappedOpenAPINode()

				default:
					return nil
				}
			}()

			// put it all together
			let newNode: JSONNode?
			if let allCases = maybeAllCases,
				let openAPINode = maybeOpenAPINode {
				newNode = try openAPINode.with(allowedValues: allCases)
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
