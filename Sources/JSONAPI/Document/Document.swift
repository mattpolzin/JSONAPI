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
public struct JSONAPIDocument<ResourceBody: JSONAPI.ResourceBody, MetaType: JSONAPI.Meta, IncludeType: JSONAPI.Include, Error: JSONAPIError>: Equatable {
	public typealias Include = IncludeType

	public let body: Body
//	public let jsonApi: APIDescription?
//	public let links: Links?
	
	public enum Body: Equatable {
		case errors([Error], meta: MetaType?)
		case data(primary: ResourceBody, included: Includes<Include>, meta: MetaType)
		case meta(MetaType)
		
		public var isError: Bool {
			guard case .errors = self else { return false }
			return true
		}
		
		public var data: (primary: ResourceBody, included: Includes<Include>, meta: MetaType)? {
			guard case let .data(primary: body, included: includes, meta: meta) = self else { return nil }
			return (primary: body, included: includes, meta: meta)
		}

		public var meta: MetaType? {
			guard case let .meta(metadata) = self else { return nil }
			return metadata
		}
	}

	public init(errors: [Error], meta: MetaType? = nil) {
		body = .errors(errors, meta: meta)
	}

	public init(body: ResourceBody, includes: Includes<Include>, meta: MetaType) {
		self.body = .data(primary: body, included: includes, meta: meta)
	}
}

extension JSONAPIDocument where IncludeType == NoIncludes {
	public init(body: ResourceBody, meta: MetaType) {
		self.body = .data(primary: body, included: .none, meta: meta)
	}
}

extension JSONAPIDocument where MetaType == NoMetadata {
	public init(body: ResourceBody, includes: Includes<Include>) {
		self.body = .data(primary: body, included: includes, meta: .none)
	}
}

extension JSONAPIDocument where IncludeType == NoIncludes, MetaType == NoMetadata {
	public init(body: ResourceBody) {
		self.body = .data(primary: body, included: .none, meta: .none)
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

		let meta: MetaType?
		if let noMeta = NoMetadata() as? MetaType {
			meta = noMeta
		} else {
			do {
				meta = try container.decode(MetaType.self, forKey: .meta)
			} catch {
				meta = nil
			}
		}

		// If there are errors, there cannot be a body. Return errors and any metadata found.
		if let errors = errors {
			body = .errors(errors, meta: meta)
			return
		}

		let maybeData: ResourceBody?
		if ResourceBody.self == NoResourceBody.self {
			maybeData = nil
		} else {
			maybeData = try container.decode(ResourceBody.self, forKey: .data)
		}

		// If there were not errors but there is also no data, try to find metadata.
		// No metadata is against JSON API Spec, but otherwise we can form a
		// metadat-only document.
		guard let data = maybeData else {
			guard let metaVal = meta else {
				throw JSONAPIEncodingError.missingOrMalformedMetadata
			}
			body = .meta(metaVal)
			return
		}

		let maybeIncludes = try container.decodeIfPresent(Includes<Include>.self, forKey: .included)
		
		// TODO come back to this and make robust

		guard let metaVal = meta else {
			throw JSONAPIEncodingError.missingOrMalformedMetadata
		}
		
		body = .data(primary: data, included: maybeIncludes ?? Includes<Include>.none, meta: metaVal)
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: RootCodingKeys.self)

		switch body {
		case .errors(let errors, let meta):
			var errContainer = container.nestedUnkeyedContainer(forKey: .errors)

			for error in errors {
				try errContainer.encode(error)
			}

			if MetaType.self != NoMetadata.self,
				let metaVal = meta {
				try container.encode(metaVal, forKey: .meta)
			}

		case .data(primary: let resourceBody, included: let includes, let meta):
			try container.encode(resourceBody, forKey: .data)

			if Include.self != NoIncludes.self {
				try container.encode(includes, forKey: .included)
			}

			if MetaType.self != NoMetadata.self {
				try container.encode(meta, forKey: .meta)
			}

		case .meta(let metadata):
			try container .encode(metadata, forKey: .meta)
		}
	}
}

// MARK: - CustomStringConvertible

extension JSONAPIDocument: CustomStringConvertible {
	public var description: String {
		return "JSONAPIDocument(body: \(String(describing: body))"
	}
}
