//
//  JSONAPIDocument.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/5/18.
//

/// A JSON API Document represents the entire body
/// of a JSON API request or the entire body of
/// a JSON API response.
/// Note that this type uses Camel case. If your
/// API uses snake case, you will want to use
/// a conversion such as the one offerred by the
/// Foundation JSONEncoder/Decoder: `KeyDecodingStrategy`
public struct JSONAPIDocument<ResourceBody: JSONAPI.ResourceBody, IncludeType: JSONAPI.Include, Error: JSONAPIError>: Equatable {
	public typealias Include = IncludeType

	public let body: Body
//	public let meta: Meta?
//	public let jsonApi: APIDescription?
//	public let links: Links?
	
	public enum Body: Equatable {
		case errors([Error])
		case data(primary: ResourceBody, included: Includes<Include>)
		
		public var isError: Bool {
			guard case .errors = self else { return false }
			return true
		}
		
		public var data: (primary: ResourceBody, included: Includes<Include>)? {
			guard case let .data(primary: body, included: includes) = self else { return nil }
			return (primary: body, included: includes)
		}
	}

	public init(errors: [Error]) {
		body = .errors(errors)
	}

	public init(body: ResourceBody, includes: Includes<Include>) {
		self.body = .data(primary: body, included: includes)
	}
}

extension JSONAPIDocument where IncludeType == NoIncludes {
	public init(body: ResourceBody) {
		self.body = .data(primary: body, included: .none)
	}
}

extension JSONAPIDocument: Codable {
	private enum RootCodingKeys: String, CodingKey {
		case data
		case errors
		case included
		case meta
		case links
		case jsonapi
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: RootCodingKeys.self)

		let errors = try container.decodeIfPresent([Error].self, forKey: .errors)

		if let errors = errors {
			body = .errors(errors)
			return
		}

		let data = try container.decode(ResourceBody.self, forKey: .data)
		let maybeIncludes = try container.decodeIfPresent(Includes<Include>.self, forKey: .included)
		
		// TODO come back to this and make robust
		
		body = .data(primary: data, included: maybeIncludes ?? Includes<Include>.none)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: RootCodingKeys.self)

		switch body {
		case .errors(let errors):
			var errContainer = container.nestedUnkeyedContainer(forKey: .errors)

			for error in errors {
				try errContainer.encode(error)
			}

		case .data(primary: let resourceBody, included: let includes):
			try container.encode(resourceBody, forKey: .data)

			if Include.self != NoIncludes.self {
				try container.encode(includes, forKey: .included)
			}
		}
	}
}

// MARK: - CustomStringConvertible

extension JSONAPIDocument: CustomStringConvertible {
	public var description: String {
		return "JSONAPIDocument(body: \(String(describing: body))"
	}
}
