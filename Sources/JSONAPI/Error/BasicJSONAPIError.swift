//
//  BasicJSONAPIError.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 9/29/19.
//

/// Most of the JSON:API Spec defined Error fields.
public struct BasicJSONAPIErrorPayload<IdType: Codable & Equatable>: Codable, Equatable, ErrorDictType, CustomStringConvertible {
    /// a unique identifier for this particular occurrence of the problem
    public let id: IdType?

    //    public let links: Links? // we skip this for now to avoid adding complexity to using this basic type.

    /// the HTTP status code applicable to this problem
    public let status: String?
    /// an application-specific error code
    public let code: String?
    /// a short, human-readable summary of the problem that SHOULD NOT change from occurrence to occurrence of the problem, except for purposes of localization
    public let title: String?
    /// a human-readable explanation specific to this occurrence of the problem. Like `title`, this field’s value can be localized
    public let detail: String?
    /// an object containing references to the source of the error
    public let source: Source?

    //    public let meta: Meta? // we skip this for now to avoid adding complexity to using this basic type

    public init(id: IdType? = nil,
                status: String? = nil,
                code: String? = nil,
                title: String? = nil,
                detail: String? = nil,
                source: Source? = nil) {
        self.id = id
        self.status = status
        self.code = code
        self.title = title
        self.detail = detail
        self.source = source
    }

    public struct Source: Codable, Equatable {
        /// a JSON Pointer [RFC6901] to the associated entity in the request document [e.g. "/data" for a primary data object, or "/data/attributes/title" for a specific attribute].
        public let pointer: String?
        /// which URI query parameter caused the error
        public let parameter: String?

        public init(pointer: String? = nil,
                    parameter: String? = nil) {
            self.pointer = pointer
            self.parameter = parameter
        }
    }

    public var definedFields: [String: String] {
        let keysAndValues = [
            id.map { ("id", String(describing: $0)) },
            status.map { ("status", $0) },
            code.map { ("code", $0) },
            title.map { ("title", $0) },
            detail.map { ("detail", $0) },
            source.flatMap { $0.pointer.map { ("pointer", $0) } },
            source.flatMap { $0.parameter.map { ("parameter", $0) } }
        ].compactMap { $0 }
        return Dictionary(uniqueKeysWithValues: keysAndValues)
    }

    public var description: String {
        return definedFields.map { "\($0.key): \($0.value)" }.sorted().joined(separator: ", ")
    }
}

/// `BasicJSONAPIError` optionally decodes many possible fields
/// specified by the JSON:API 1.0 Spec. It gives no type-guarantees of what
/// will be non-nil, but could provide good diagnostic information when
/// you do not know what error structure to expect.
///
/// ```
/// Fields:
/// - id
/// - status
/// - code
/// - title
/// - detail
/// - source
///   - pointer
///   - parameter
/// ```
///
/// The JSON:API Spec does not dictate the type of this particular Id field,
/// so you must specify whether to expect, for example, an `Int` or a `String`
/// in the id field.
///
/// Something like `AnyCodable` from *Flight-School* could be
/// a good option if you do not know what to expect. You could also use
/// `Either<Int, String>` (provided by the `Poly` package that is
/// already a dependency of `JSONAPI`).
///
///  - Important: The `definedFields` property will include fields
///     with non-nil values in a flattened way. There will be no `source` key
///     but there will be `pointer` and `parameter` keys (if those values
///     are non-nil).
public typealias BasicJSONAPIError<IdType: Codable & Equatable> = GenericJSONAPIError<BasicJSONAPIErrorPayload<IdType>>
