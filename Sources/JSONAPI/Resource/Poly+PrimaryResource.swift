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
public typealias JSONPoly = Poly & PrimaryResource

public typealias PolyWrapped = Codable & Equatable

extension Poly0: PrimaryResource {
	public init(from decoder: Decoder) throws {
		throw JSONAPIEncodingError.illegalDecoding("Attempted to decode Poly0, which should represent a thing that is not expected to be found in a document.")
	}

	public func encode(to encoder: Encoder) throws {
		throw JSONAPIEncodingError.illegalEncoding("Attempted to encode Poly0, which should represent a thing that is not expected to be found in a document.")
	}
}

// MARK: - 1 type
extension Poly1: PrimaryResource, MaybePrimaryResource where A: PolyWrapped {}

// MARK: - 2 types
extension Poly2: PrimaryResource, MaybePrimaryResource where A: PolyWrapped, B: PolyWrapped {}

// MARK: - 3 types
extension Poly3: PrimaryResource, MaybePrimaryResource where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped {}

// MARK: - 4 types
extension Poly4: PrimaryResource, MaybePrimaryResource where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped {}

// MARK: - 5 types
extension Poly5: PrimaryResource, MaybePrimaryResource where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped {}

// MARK: - 6 types
extension Poly6: PrimaryResource, MaybePrimaryResource where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped {}

// MARK: - 7 types
extension Poly7: PrimaryResource, MaybePrimaryResource where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped {}

// MARK: - 8 types
extension Poly8: PrimaryResource, MaybePrimaryResource where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped, H: PolyWrapped {}

// MARK: - 9 types
extension Poly9: PrimaryResource, MaybePrimaryResource where A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped, H: PolyWrapped, I: PolyWrapped {}
