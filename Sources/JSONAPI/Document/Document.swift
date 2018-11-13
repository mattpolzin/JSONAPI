//
//  JSONAPIDocument.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/5/18.
//

import Foundation

/// A JSON API Document represents the entire body
/// of a JSON API request or the entire body of
/// a JSON API response.
/// Note that this type uses Camel case. If your
/// API uses snake case, you will want to use
/// a conversion such as the one offerred by the
/// Foundation JSONEncoder/Decoder: `KeyDecodingStrategy`
public struct JSONAPIDocument<Body: ResourceBody, Include: IncludeDecoder, Error: JSONAPIError & Decodable> {
	public let body: Data
//	public let meta: Meta?
//	public let jsonApi: APIDescription?
//	public let links: Links?
	
	public enum Data {
		case errors([Error])
		case data(Body, included: Includes<Include>)
		
		public var isError: Bool {
			guard case .errors = self else { return false }
			return true
		}
		
		public var data: (Body, included: Includes<Include>)? {
			guard case let .data(body, included: includes) = self else { return nil }
			return (body, included: includes)
		}
	}
}

extension JSONAPIDocument: Decodable {
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
		
		let maybeData = try container.decodeIfPresent(Body.self, forKey: .data)
		let maybeIncludes = try container.decodeIfPresent(Includes<Include>.self, forKey: .included)
		let errors = try container.decodeIfPresent([Error].self, forKey: .errors)
		
		assert(!(maybeData != nil && errors != nil), "JSON API Spec dictates data and errors will not both be present.")
		assert((maybeIncludes == nil || maybeData != nil), "JSON API Spec dictates that includes will not be present if data is not present.")
		
		// TODO come back to this and make robust
		
		if let errors = errors {
			body = .errors(errors)
			return
		}
		
		guard let data = maybeData else {
			body = .errors([.unknown]) // TODO: this should be more descriptive
			return
		}
		
		body = .data(data, included: maybeIncludes ?? Includes<Include>.none)
	}
}
