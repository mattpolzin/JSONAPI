//
//  PrimaryResourceBody.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

/// This protocol allows for a `SingleResourceBody` to contain a `null`
/// data object where `ManyResourceBody` cannot (because an empty
/// array should be used for no results).
public protocol OptionalEncodablePrimaryResource: Equatable, Encodable {}

/// An `EncodablePrimaryResource` is a `CodablePrimaryResource` that only supports encoding.
public protocol EncodablePrimaryResource: OptionalEncodablePrimaryResource {}

/// This protocol allows for `SingleResourceBody` to contain a `null`
/// data object where `ManyResourceBody` cannot (because an empty
/// array should be used for no results).
public protocol OptionalCodablePrimaryResource: OptionalEncodablePrimaryResource, Decodable {}

/// A `CodablePrimaryResource` is a type that can be used in the body of a JSON API
/// document as the primary resource.
public protocol CodablePrimaryResource: EncodablePrimaryResource, OptionalCodablePrimaryResource {}

extension Optional: OptionalEncodablePrimaryResource where Wrapped: EncodablePrimaryResource {}

extension Optional: OptionalCodablePrimaryResource where Wrapped: CodablePrimaryResource {}

/// An `EncodableResourceBody` is a `ResourceBody` that only supports being
/// encoded. It is actually weaker than `ResourceBody`, which supports both encoding
/// and decoding.
public protocol EncodableResourceBody: Equatable, Encodable {
    associatedtype PrimaryResource
}

/// A `CodableResourceBody` is a representation of the body of the JSON:API Document.
/// It can either be one resource (which can be specified as optional or not)
/// or it can contain many resources (and array with zero or more entries).
public protocol CodableResourceBody: Decodable, EncodableResourceBody {}

/// A `ResourceBody` that has the ability to take on more primary
/// resources by appending another similarly typed `ResourceBody`.
public protocol ResourceBodyAppendable {
    func appending(_ other: Self) -> Self
}

public func +<R: ResourceBodyAppendable>(_ left: R, right: R) -> R {
    return left.appending(right)
}

public protocol SingleResourceBodyProtocol: EncodableResourceBody {
    var value: PrimaryResource { get }

    init(resourceObject: PrimaryResource)
}

/// A type allowing for a document body containing 1 primary resource.
/// If the `Entity` specialization is an `Optional` type, the body can contain
/// 0 or 1 primary resources.
public struct SingleResourceBody<PrimaryResource: JSONAPI.OptionalEncodablePrimaryResource>: SingleResourceBodyProtocol {
    public let value: PrimaryResource

    public init(resourceObject: PrimaryResource) {
        self.value = resourceObject
    }
}

public protocol ManyResourceBodyProtocol: EncodableResourceBody {
    var values: [PrimaryResource] { get }

    init(resourceObjects: [PrimaryResource])
}

/// A type allowing for a document body containing 0 or more primary resources.
public struct ManyResourceBody<PrimaryResource: JSONAPI.EncodablePrimaryResource>: ManyResourceBodyProtocol, ResourceBodyAppendable {
    public let values: [PrimaryResource]

    public init(resourceObjects: [PrimaryResource]) {
        values = resourceObjects
    }

    public func appending(_ other: ManyResourceBody) -> ManyResourceBody {
        return ManyResourceBody(resourceObjects: values + other.values)
    }
}

/// Use NoResourceBody to indicate you expect a JSON API document to not
/// contain a "data" top-level key.
public struct NoResourceBody: CodableResourceBody {
    public typealias PrimaryResource = Void

    public static var none: NoResourceBody { return NoResourceBody() }
}

// MARK: Codable
extension SingleResourceBody {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        let anyNil: Any? = nil
        let nilValue = anyNil as? PrimaryResource
        guard value != nilValue else {
            try container.encodeNil()
            return
        }

        try container.encode(value)
    }
}

extension SingleResourceBody: Decodable, CodableResourceBody where PrimaryResource: OptionalCodablePrimaryResource {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let anyNil: Any? = nil
        if container.decodeNil(),
            let val = anyNil as? PrimaryResource {
            value = val
            return
        }

        value = try container.decode(PrimaryResource.self)
    }
}

extension ManyResourceBody {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        for value in values {
            try container.encode(value)
        }
    }
}

extension ManyResourceBody: Decodable, CodableResourceBody where PrimaryResource: CodablePrimaryResource {
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        var valueAggregator = [PrimaryResource]()
        var idx = 0
        while !container.isAtEnd {
            do {
                valueAggregator.append(try container.decode(PrimaryResource.self))
            } catch let error as ResourceObjectDecodingError {
                throw ManyResourceBodyDecodingError(
                    error: error,
                    idx: idx
                )
            }
            idx = idx + 1
        }
        values = valueAggregator
    }
}

// MARK: CustomStringConvertible

extension SingleResourceBody: CustomStringConvertible {
    public var description: String {
        return "PrimaryResourceBody(\(String(describing: value)))"
    }
}

extension ManyResourceBody: CustomStringConvertible {
    public var description: String {
        return "PrimaryResourceBody(\(String(describing: values)))"
    }
}

// MARK: - DecodingError
public struct ManyResourceBodyDecodingError: Swift.Error, Equatable {
    public let error: ResourceObjectDecodingError
    public let idx: Int
}
