//
//  Poly+PrimaryResource.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/22/18.
//

import Poly

/// Poly is a protocol to which types that
/// are polymorphic belong to. Specifically,
/// Poly1, Poly2, Poly3, etc. types conform
/// to the Poly protocol. These types allow
/// typesafe grouping of a number of
/// disparate types under one roof for
/// the purposes of JSON API compliant
/// encoding or decoding.
public typealias EncodableJSONPoly = Poly & EncodablePrimaryResource

public typealias EncodablePolyWrapped = Encodable & Equatable
public typealias PolyWrapped = EncodablePolyWrapped & Decodable

extension Poly0: PrimaryResource {
    public init(from decoder: Decoder) throws {
        throw JSONAPIEncodingError.illegalDecoding("Attempted to decode Poly0, which should represent a thing that is not expected to be found in a document.")
    }

    public func encode(to encoder: Encoder) throws {
        throw JSONAPIEncodingError.illegalEncoding("Attempted to encode Poly0, which should represent a thing that is not expected to be found in a document.")
    }
}

// MARK: - 1 type
extension Poly1: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped {}

extension Poly1: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped {}

// MARK: - 2 types
extension Poly2: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped {}

extension Poly2: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped, B: PolyWrapped {}

// MARK: - 3 types
extension Poly3: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped, C: EncodablePolyWrapped {}

extension Poly3: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped {}

// MARK: - 4 types
extension Poly4: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped, C: EncodablePolyWrapped, D: EncodablePolyWrapped {}

extension Poly4: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped {}

// MARK: - 5 types
extension Poly5: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped, C: EncodablePolyWrapped, D: EncodablePolyWrapped, E: EncodablePolyWrapped {}

extension Poly5: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped {}

// MARK: - 6 types
extension Poly6: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped, C: EncodablePolyWrapped, D: EncodablePolyWrapped, E: EncodablePolyWrapped, F: EncodablePolyWrapped {}

extension Poly6: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped {}

// MARK: - 7 types
extension Poly7: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where
        A: EncodablePolyWrapped,
        B: EncodablePolyWrapped,
        C: EncodablePolyWrapped,
        D: EncodablePolyWrapped,
        E: EncodablePolyWrapped,
        F: EncodablePolyWrapped,
        G: EncodablePolyWrapped {}

extension Poly7: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped {}

// MARK: - 8 types
extension Poly8: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where
        A: EncodablePolyWrapped,
        B: EncodablePolyWrapped,
        C: EncodablePolyWrapped,
        D: EncodablePolyWrapped,
        E: EncodablePolyWrapped,
        F: EncodablePolyWrapped,
        G: EncodablePolyWrapped,
        H: EncodablePolyWrapped {}

extension Poly8: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped, H: PolyWrapped {}

// MARK: - 9 types
extension Poly9: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where
        A: EncodablePolyWrapped,
        B: EncodablePolyWrapped,
        C: EncodablePolyWrapped,
        D: EncodablePolyWrapped,
        E: EncodablePolyWrapped,
        F: EncodablePolyWrapped,
        G: EncodablePolyWrapped,
        H: EncodablePolyWrapped,
        I: EncodablePolyWrapped {}

extension Poly9: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped, H: PolyWrapped, I: PolyWrapped {}

// MARK: - 10 types
extension Poly10: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where
        A: EncodablePolyWrapped,
        B: EncodablePolyWrapped,
        C: EncodablePolyWrapped,
        D: EncodablePolyWrapped,
        E: EncodablePolyWrapped,
        F: EncodablePolyWrapped,
        G: EncodablePolyWrapped,
        H: EncodablePolyWrapped,
        I: EncodablePolyWrapped,
        J: EncodablePolyWrapped {}

extension Poly10: PrimaryResource, OptionalPrimaryResource
    where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped, H: PolyWrapped, I: PolyWrapped, J: PolyWrapped {}

// MARK: - 11 types
extension Poly11: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where
        A: EncodablePolyWrapped,
        B: EncodablePolyWrapped,
        C: EncodablePolyWrapped,
        D: EncodablePolyWrapped,
        E: EncodablePolyWrapped,
        F: EncodablePolyWrapped,
        G: EncodablePolyWrapped,
        H: EncodablePolyWrapped,
        I: EncodablePolyWrapped,
        J: EncodablePolyWrapped,
        K: EncodablePolyWrapped {}

extension Poly11: PrimaryResource, OptionalPrimaryResource
    where
        A: PolyWrapped,
        B: PolyWrapped,
        C: PolyWrapped,
        D: PolyWrapped,
        E: PolyWrapped,
        F: PolyWrapped,
        G: PolyWrapped,
        H: PolyWrapped,
        I: PolyWrapped,
        J: PolyWrapped,
        K: PolyWrapped {}
