//
//  Poly.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/22/18.
//

/// Poly is a protocol to which types that
/// are polymorphic belong to. Specifically,
/// Poly1, Poly2, Poly3, etc. types conform
/// to the Poly protocol. These types allow
/// typesafe grouping of a number of
/// disparate types under one roof for
/// the purposes of JSON API compliant
/// encoding or decoding.
public protocol Poly: PrimaryResource {}

// MARK: - Generic Decoding

private func decode<Thing: Codable>(_ type: Thing.Type, from container: SingleValueDecodingContainer) throws -> Result<Thing, DecodingError> {
	let ret: Result<Thing, DecodingError>
	do {
		ret = try .success(container.decode(Thing.self))
	} catch (let err as DecodingError) {
		ret = .failure(err)
	} catch (let err) {
		ret = .failure(DecodingError.typeMismatch(Thing.self,
												  .init(codingPath: container.codingPath,
														debugDescription: String(describing: err),
														underlyingError: err)))
	}
	return ret
}

// MARK: - 0 types
public protocol _Poly0: Poly { }
public struct Poly0: _Poly0 {

	public init() {}

	public init(from decoder: Decoder) throws {
		throw JSONAPIEncodingError.illegalDecoding("Attempted to decode Poly0, which should represent a thing that is not expected to be found in a document.")
	}

	public func encode(to encoder: Encoder) throws {
		throw JSONAPIEncodingError.illegalEncoding("Attempted to encode Poly0, which should represent a thing that is not expected to be found in a document.")
	}
}

public typealias PolyWrapped = Codable & Equatable

// MARK: - 1 type
public protocol _Poly1: _Poly0 {
	associatedtype A: PolyWrapped
	var a: A? { get }

	init(_ a: A)
}

public extension _Poly1 {
	subscript(_ lookup: A.Type) -> A? {
		return a
	}
}

public enum Poly1<A: PolyWrapped>: _Poly1 {
	case a(A)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		self = .a(try container.decode(A.self))
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		}
	}
}

extension Poly1: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		}
		return "Poly(\(str))"
	}
}

// MARK: - 2 types
public protocol _Poly2: _Poly1 {
	associatedtype B: PolyWrapped
	var b: B? { get }

	init(_ b: B)
}

public extension _Poly2 {
	subscript(_ lookup: B.Type) -> B? {
		return b
	}
}

public typealias Either = Poly2

public enum Poly2<A: PolyWrapped, B: PolyWrapped>: _Poly2 {
	case a(A)
	case b(B)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly2.a($0) },
			try decode(B.self, from: container).map { Poly2.b($0) } ]

		let maybeVal: Poly2<A, B>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly2<A, B>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		}
	}
}

extension Poly2: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		}
		return "Poly(\(str))"
	}
}

// MARK: - 3 types
public protocol _Poly3: _Poly2 {
	associatedtype C: PolyWrapped
	var c: C? { get }

	init(_ c: C)
}

public extension _Poly3 {
	subscript(_ lookup: C.Type) -> C? {
		return c
	}
}

public enum Poly3<A: PolyWrapped, B: PolyWrapped, C: PolyWrapped>: _Poly3 {
	case a(A)
	case b(B)
	case c(C)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly3.a($0) },
			try decode(B.self, from: container).map { Poly3.b($0) },
			try decode(C.self, from: container).map { Poly3.c($0) }]

		let maybeVal: Poly3<A, B, C>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly3<A, B, C>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		}
	}
}

extension Poly3: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		}
		return "Poly(\(str))"
	}
}

// MARK: - 4 types
public protocol _Poly4: _Poly3 {
	associatedtype D: PolyWrapped
	var d: D? { get }

	init(_ d: D)
}

public extension _Poly4 {
	subscript(_ lookup: D.Type) -> D? {
		return d
	}
}

public enum Poly4<A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped>: _Poly4 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}

	public init(_ d: D) {
		self = .d(d)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly4.a($0) },
			try decode(B.self, from: container).map { Poly4.b($0) },
			try decode(C.self, from: container).map { Poly4.c($0) },
			try decode(D.self, from: container).map { Poly4.d($0) }]

		let maybeVal: Poly4<A, B, C, D>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly4<A, B, C, D>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		case .d(let d):
			try container.encode(d)
		}
	}
}

extension Poly4: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		case .d(let d):
			str = String(describing: d)
		}
		return "Poly(\(str))"
	}
}

// MARK: - 5 types
public protocol _Poly5: _Poly4 {
	associatedtype E: PolyWrapped
	var e: E? { get }

	init(_ e: E)
}

public extension _Poly5 {
	subscript(_ lookup: E.Type) -> E? {
		return e
	}
}

public enum Poly5<A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped>: _Poly5 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)
	case e(E)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}

	public init(_ d: D) {
		self = .d(d)
	}

	public var e: E? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}

	public init(_ e: E) {
		self = .e(e)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly5.a($0) },
			try decode(B.self, from: container).map { Poly5.b($0) },
			try decode(C.self, from: container).map { Poly5.c($0) },
			try decode(D.self, from: container).map { Poly5.d($0) },
			try decode(E.self, from: container).map { Poly5.e($0) }]

		let maybeVal: Poly5<A, B, C, D, E>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly5<A, B, C, D, E>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		case .d(let d):
			try container.encode(d)
		case .e(let e):
			try container.encode(e)
		}
	}
}

extension Poly5: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		case .d(let d):
			str = String(describing: d)
		case .e(let e):
			str = String(describing: e)
		}
		return "Poly(\(str))"
	}
}

// MARK: - 6 types
public protocol _Poly6: _Poly5 {
	associatedtype F: PolyWrapped
	var f: F? { get }

	init(_ f: F)
}

public extension _Poly6 {
	subscript(_ lookup: F.Type) -> F? {
		return f
	}
}

public enum Poly6<A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped>: _Poly6 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)
	case e(E)
	case f(F)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}

	public init(_ d: D) {
		self = .d(d)
	}

	public var e: E? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}

	public init(_ e: E) {
		self = .e(e)
	}

	public var f: F? {
		guard case let .f(ret) = self else { return nil }
		return ret
	}

	public init(_ f: F) {
		self = .f(f)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly6.a($0) },
			try decode(B.self, from: container).map { Poly6.b($0) },
			try decode(C.self, from: container).map { Poly6.c($0) },
			try decode(D.self, from: container).map { Poly6.d($0) },
			try decode(E.self, from: container).map { Poly6.e($0) },
			try decode(F.self, from: container).map { Poly6.f($0) }]

		let maybeVal: Poly6<A, B, C, D, E, F>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly6<A, B, C, D, E, F>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		case .d(let d):
			try container.encode(d)
		case .e(let e):
			try container.encode(e)
		case .f(let f):
			try container.encode(f)
		}
	}
}

extension Poly6: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		case .d(let d):
			str = String(describing: d)
		case .e(let e):
			str = String(describing: e)
		case .f(let f):
			str = String(describing: f)
		}
		return "Poly(\(str))"
	}
}

// MARK: - 7 types
public protocol _Poly7: _Poly6 {
	associatedtype G: PolyWrapped
	var g: G? { get }

	init(_ g: G)
}

public extension _Poly7 {
	subscript(_ lookup: G.Type) -> G? {
		return g
	}
}

public enum Poly7<A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped>: _Poly7 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)
	case e(E)
	case f(F)
	case g(G)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}

	public init(_ d: D) {
		self = .d(d)
	}

	public var e: E? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}

	public init(_ e: E) {
		self = .e(e)
	}

	public var f: F? {
		guard case let .f(ret) = self else { return nil }
		return ret
	}

	public init(_ f: F) {
		self = .f(f)
	}

	public var g: G? {
		guard case let .g(ret) = self else { return nil }
		return ret
	}

	public init(_ g: G) {
		self = .g(g)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly7.a($0) },
			try decode(B.self, from: container).map { Poly7.b($0) },
			try decode(C.self, from: container).map { Poly7.c($0) },
			try decode(D.self, from: container).map { Poly7.d($0) },
			try decode(E.self, from: container).map { Poly7.e($0) },
			try decode(F.self, from: container).map { Poly7.f($0) },
			try decode(G.self, from: container).map { Poly7.g($0) }]

		let maybeVal: Poly7<A, B, C, D, E, F, G>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly7<A, B, C, D, E, F, G>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		case .d(let d):
			try container.encode(d)
		case .e(let e):
			try container.encode(e)
		case .f(let f):
			try container.encode(f)
		case .g(let g):
			try container.encode(g)
		}
	}
}

extension Poly7: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		case .d(let d):
			str = String(describing: d)
		case .e(let e):
			str = String(describing: e)
		case .f(let f):
			str = String(describing: f)
		case .g(let g):
			str = String(describing: g)
		}

		return "Poly(\(str))"
	}
}

// MARK: - 8 types
public protocol _Poly8: _Poly7 {
	associatedtype H: PolyWrapped
	var h: H? { get }

	init(_ h: H)
}

public extension _Poly8 {
	subscript(_ lookup: H.Type) -> H? {
		return h
	}
}

public enum Poly8<A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped, H: PolyWrapped>: _Poly8 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)
	case e(E)
	case f(F)
	case g(G)
	case h(H)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}

	public init(_ d: D) {
		self = .d(d)
	}

	public var e: E? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}

	public init(_ e: E) {
		self = .e(e)
	}

	public var f: F? {
		guard case let .f(ret) = self else { return nil }
		return ret
	}

	public init(_ f: F) {
		self = .f(f)
	}

	public var g: G? {
		guard case let .g(ret) = self else { return nil }
		return ret
	}

	public init(_ g: G) {
		self = .g(g)
	}

	public var h: H? {
		guard case let .h(ret) = self else { return nil }
		return ret
	}

	public init(_ h: H) {
		self = .h(h)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly8.a($0) },
			try decode(B.self, from: container).map { Poly8.b($0) },
			try decode(C.self, from: container).map { Poly8.c($0) },
			try decode(D.self, from: container).map { Poly8.d($0) },
			try decode(E.self, from: container).map { Poly8.e($0) },
			try decode(F.self, from: container).map { Poly8.f($0) },
			try decode(G.self, from: container).map { Poly8.g($0) },
			try decode(H.self, from: container).map { Poly8.h($0) }]

		let maybeVal: Poly8<A, B, C, D, E, F, G, H>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly8<A, B, C, D, E, F, G, H>.self, .init(codingPath: decoder.codingPath,
																					   debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		case .d(let d):
			try container.encode(d)
		case .e(let e):
			try container.encode(e)
		case .f(let f):
			try container.encode(f)
		case .g(let g):
			try container.encode(g)
		case .h(let h):
			try container.encode(h)
		}
	}
}

extension Poly8: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		case .d(let d):
			str = String(describing: d)
		case .e(let e):
			str = String(describing: e)
		case .f(let f):
			str = String(describing: f)
		case .g(let g):
			str = String(describing: g)
		case .h(let h):
			str = String(describing: h)
		}

		return "Poly(\(str))"
	}
}

// MARK: - 9 types
public protocol _Poly9: _Poly8 {
	associatedtype I: PolyWrapped
	var i: I? { get }

	init(_ i: I)
}

public extension _Poly9 {
	subscript(_ lookup: I.Type) -> I? {
		return i
	}
}

public enum Poly9<A: PolyWrapped, B: PolyWrapped, C: PolyWrapped, D: PolyWrapped, E: PolyWrapped, F: PolyWrapped, G: PolyWrapped, H: PolyWrapped, I: PolyWrapped>: _Poly9 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)
	case e(E)
	case f(F)
	case g(G)
	case h(H)
	case i(I)

	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}

	public init(_ a: A) {
		self = .a(a)
	}

	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}

	public init(_ b: B) {
		self = .b(b)
	}

	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}

	public init(_ c: C) {
		self = .c(c)
	}

	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}

	public init(_ d: D) {
		self = .d(d)
	}

	public var e: E? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}

	public init(_ e: E) {
		self = .e(e)
	}

	public var f: F? {
		guard case let .f(ret) = self else { return nil }
		return ret
	}

	public init(_ f: F) {
		self = .f(f)
	}

	public var g: G? {
		guard case let .g(ret) = self else { return nil }
		return ret
	}

	public init(_ g: G) {
		self = .g(g)
	}

	public var h: H? {
		guard case let .h(ret) = self else { return nil }
		return ret
	}

	public init(_ h: H) {
		self = .h(h)
	}

	public var i: I? {
		guard case let .i(ret) = self else { return nil }
		return ret
	}

	public init(_ i: I) {
		self = .i(i)
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()

		let attempts = [
			try decode(A.self, from: container).map { Poly9.a($0) },
			try decode(B.self, from: container).map { Poly9.b($0) },
			try decode(C.self, from: container).map { Poly9.c($0) },
			try decode(D.self, from: container).map { Poly9.d($0) },
			try decode(E.self, from: container).map { Poly9.e($0) },
			try decode(F.self, from: container).map { Poly9.f($0) },
			try decode(G.self, from: container).map { Poly9.g($0) },
			try decode(H.self, from: container).map { Poly9.h($0) },
			try decode(I.self, from: container).map { Poly9.i($0) }]

		let maybeVal: Poly9<A, B, C, D, E, F, G, H, I>? = attempts
			.compactMap { $0.value }
			.first

		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Poly9<A, B, C, D, E, F, G, H, I>.self, .init(codingPath: decoder.codingPath,
																						  debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
		}

		self = val
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.singleValueContainer()

		switch self {
		case .a(let a):
			try container.encode(a)
		case .b(let b):
			try container.encode(b)
		case .c(let c):
			try container.encode(c)
		case .d(let d):
			try container.encode(d)
		case .e(let e):
			try container.encode(e)
		case .f(let f):
			try container.encode(f)
		case .g(let g):
			try container.encode(g)
		case .h(let h):
			try container.encode(h)
		case .i(let i):
			try container.encode(i)
		}
	}
}

extension Poly9: CustomStringConvertible {
	public var description: String {
		let str: String
		switch self {
		case .a(let a):
			str = String(describing: a)
		case .b(let b):
			str = String(describing: b)
		case .c(let c):
			str = String(describing: c)
		case .d(let d):
			str = String(describing: d)
		case .e(let e):
			str = String(describing: e)
		case .f(let f):
			str = String(describing: f)
		case .g(let g):
			str = String(describing: g)
		case .h(let h):
			str = String(describing: h)
		case .i(let i):
			str = String(describing: i)
		}

		return "Poly(\(str))"
	}
}
