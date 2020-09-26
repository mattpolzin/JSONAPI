//
//  Meta.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/21/18.
//

/// Conform a type to this protocol to indicate it can be encoded to or decoded from
/// the meta data attached to a component of a JSON:API document. Different meta data
/// can be stored all over the place: On the root document, on a resource object, on
/// link objects, etc.
///
/// JSON:API Metadata is totally open ended. It can take whatever JSON-compliant structure
/// the server and client agree upon.
public protocol Meta: Codable, Equatable {
}

// We make Optional a Meta if it wraps a Meta so that
// Metadata can be specified as nullable.
extension Optional: Meta where Wrapped: Meta {}

/// Use this type when you want to specify not to encode or decode any metadata
/// for a type.
public struct NoMetadata: Meta, CustomStringConvertible {
    public static var none: NoMetadata { return NoMetadata() }

    public init() { }

    public var description: String { return "No Metadata" }
}

/// The type of metadata found in a Resource Identifier Object.
///
/// It is sometimes more legible to differentiate between types of metadata
/// even when the underlying type is the same. This typealias is only here
/// to make code more easily understandable.
public typealias NoIdMetadata = NoMetadata
