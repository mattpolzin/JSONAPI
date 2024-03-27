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
public typealias CodablePolyWrapped = EncodablePolyWrapped & Decodable

extension Poly0: CodablePrimaryResource {
    public init(from decoder: Decoder) throws {
        throw JSONAPICodingError.illegalDecoding("Attempted to decode Poly0, which should represent a thing that is not expected to be found in a document.", path: decoder.codingPath)
    }

    public func encode(to encoder: Encoder) throws {
        throw JSONAPICodingError.illegalEncoding("Attempted to encode Poly0, which should represent a thing that is not expected to be found in a document.", path: encoder.codingPath)
    }
}

// MARK: - 1 type
extension Poly1: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped {}

extension Poly1: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped {}

// MARK: - 2 types
extension Poly2: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped {}

extension Poly2: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped, B: CodablePolyWrapped {}

// MARK: - 3 types
extension Poly3: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped, C: EncodablePolyWrapped {}

extension Poly3: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped, B: CodablePolyWrapped, C: CodablePolyWrapped {}

// MARK: - 4 types
extension Poly4: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped, C: EncodablePolyWrapped, D: EncodablePolyWrapped {}

extension Poly4: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped, B: CodablePolyWrapped, C: CodablePolyWrapped, D: CodablePolyWrapped {}

// MARK: - 5 types
extension Poly5: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped, C: EncodablePolyWrapped, D: EncodablePolyWrapped, E: EncodablePolyWrapped {}

extension Poly5: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped, B: CodablePolyWrapped, C: CodablePolyWrapped, D: CodablePolyWrapped, E: CodablePolyWrapped {}

// MARK: - 6 types
extension Poly6: EncodablePrimaryResource, OptionalEncodablePrimaryResource
    where A: EncodablePolyWrapped, B: EncodablePolyWrapped, C: EncodablePolyWrapped, D: EncodablePolyWrapped, E: EncodablePolyWrapped, F: EncodablePolyWrapped {}

extension Poly6: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped, B: CodablePolyWrapped, C: CodablePolyWrapped, D: CodablePolyWrapped, E: CodablePolyWrapped, F: CodablePolyWrapped {}

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

extension Poly7: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped, B: CodablePolyWrapped, C: CodablePolyWrapped, D: CodablePolyWrapped, E: CodablePolyWrapped, F: CodablePolyWrapped, G: CodablePolyWrapped {}

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

extension Poly8: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped, B: CodablePolyWrapped, C: CodablePolyWrapped, D: CodablePolyWrapped, E: CodablePolyWrapped, F: CodablePolyWrapped, G: CodablePolyWrapped, H: CodablePolyWrapped {}

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

extension Poly9: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped, B: CodablePolyWrapped, C: CodablePolyWrapped, D: CodablePolyWrapped, E: CodablePolyWrapped, F: CodablePolyWrapped, G: CodablePolyWrapped, H: CodablePolyWrapped, I: CodablePolyWrapped {}

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

extension Poly10: CodablePrimaryResource, OptionalCodablePrimaryResource
    where A: CodablePolyWrapped, B: CodablePolyWrapped, C: CodablePolyWrapped, D: CodablePolyWrapped, E: CodablePolyWrapped, F: CodablePolyWrapped, G: CodablePolyWrapped, H: CodablePolyWrapped, I: CodablePolyWrapped, J: CodablePolyWrapped {}

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

extension Poly11: CodablePrimaryResource, OptionalCodablePrimaryResource
    where
        A: CodablePolyWrapped,
        B: CodablePolyWrapped,
        C: CodablePolyWrapped,
        D: CodablePolyWrapped,
        E: CodablePolyWrapped,
        F: CodablePolyWrapped,
        G: CodablePolyWrapped,
        H: CodablePolyWrapped,
        I: CodablePolyWrapped,
        J: CodablePolyWrapped,
        K: CodablePolyWrapped {}

// MARK: - 12 types
extension Poly12: EncodablePrimaryResource, OptionalEncodablePrimaryResource
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
K: EncodablePolyWrapped,
L: EncodablePolyWrapped {}

extension Poly12: CodablePrimaryResource, OptionalCodablePrimaryResource
where
A: CodablePolyWrapped,
B: CodablePolyWrapped,
C: CodablePolyWrapped,
D: CodablePolyWrapped,
E: CodablePolyWrapped,
F: CodablePolyWrapped,
G: CodablePolyWrapped,
H: CodablePolyWrapped,
I: CodablePolyWrapped,
J: CodablePolyWrapped,
K: CodablePolyWrapped,
L: CodablePolyWrapped {}

// MARK: - 13 types
extension Poly13: EncodablePrimaryResource, OptionalEncodablePrimaryResource
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
K: EncodablePolyWrapped,
L: EncodablePolyWrapped,
M: EncodablePolyWrapped {}

extension Poly13: CodablePrimaryResource, OptionalCodablePrimaryResource
where
A: CodablePolyWrapped,
B: CodablePolyWrapped,
C: CodablePolyWrapped,
D: CodablePolyWrapped,
E: CodablePolyWrapped,
F: CodablePolyWrapped,
G: CodablePolyWrapped,
H: CodablePolyWrapped,
I: CodablePolyWrapped,
J: CodablePolyWrapped,
K: CodablePolyWrapped,
L: CodablePolyWrapped,
M: CodablePolyWrapped {}

// MARK: - 14 types
extension Poly14: EncodablePrimaryResource, OptionalEncodablePrimaryResource
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
K: EncodablePolyWrapped,
L: EncodablePolyWrapped,
M: EncodablePolyWrapped,
N: EncodablePolyWrapped {}

extension Poly14: CodablePrimaryResource, OptionalCodablePrimaryResource
where
A: CodablePolyWrapped,
B: CodablePolyWrapped,
C: CodablePolyWrapped,
D: CodablePolyWrapped,
E: CodablePolyWrapped,
F: CodablePolyWrapped,
G: CodablePolyWrapped,
H: CodablePolyWrapped,
I: CodablePolyWrapped,
J: CodablePolyWrapped,
K: CodablePolyWrapped,
L: CodablePolyWrapped,
M: CodablePolyWrapped,
N: CodablePolyWrapped {}

// MARK: - 15 types
extension Poly15: EncodablePrimaryResource, OptionalEncodablePrimaryResource
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
K: EncodablePolyWrapped,
L: EncodablePolyWrapped,
M: EncodablePolyWrapped,
N: EncodablePolyWrapped,
O: EncodablePolyWrapped {}

extension Poly15: CodablePrimaryResource, OptionalCodablePrimaryResource
where
A: CodablePolyWrapped,
B: CodablePolyWrapped,
C: CodablePolyWrapped,
D: CodablePolyWrapped,
E: CodablePolyWrapped,
F: CodablePolyWrapped,
G: CodablePolyWrapped,
H: CodablePolyWrapped,
I: CodablePolyWrapped,
J: CodablePolyWrapped,
K: CodablePolyWrapped,
L: CodablePolyWrapped,
M: CodablePolyWrapped,
N: CodablePolyWrapped,
O: CodablePolyWrapped {}
