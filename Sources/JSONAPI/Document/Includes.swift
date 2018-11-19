//
//  Includes.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

import Result

public protocol IncludeDecoder: Codable, Equatable {}

public struct Includes<I: IncludeDecoder>: Codable, Equatable {
	public static var none: Includes { return .init(values: []) }
	
	let values: [I]
	
	private init(values: [I]) {
		self.values = values
	}
	
	public init(from decoder: Decoder) throws {
		var container = try decoder.unkeyedContainer()
		
		// If not parsing includes, no need to loop over them.
		guard I.self != NoIncludes.self else {
			values = []
			return
		}
		
		var valueAggregator = [I]()
		while !container.isAtEnd {
			valueAggregator.append(try container.decode(I.self))
		}
		
		values = valueAggregator
	}

	public func encode(to encoder: Encoder) throws {
		var container = encoder.unkeyedContainer()

		guard I.self != NoIncludes.self else {
			throw JSONAPIEncodingError.illegalEncoding("Attempting to encode Include0, which should be represented by the absense of an 'included' entry altogether.")
		}

		for value in values {
			try container.encode(value)
		}
	}
	
	public var count: Int {
		return values.count
	}
}

extension Includes where I == NoIncludes {
	public init() {
		values = []
	}
}

// MARK: - Decoding

func decode<Entity: JSONAPI.EntityType>(_ type: Entity.Type, from container: SingleValueDecodingContainer) throws -> Result<Entity, EncodingError> {
	let ret: Result<Entity, EncodingError>
	do {
		ret = try .success(container.decode(Entity.self))
	} catch (let err as EncodingError) {
		ret = .failure(err)
	} catch (let err) {
		ret = .failure(EncodingError.invalidValue(Entity.Description.self,
												  .init(codingPath: container.codingPath,
														debugDescription: err.localizedDescription,
														underlyingError: err)))
	}
	return ret
}

// MARK: - 0 includes

public protocol _Include0: IncludeDecoder { }
public struct Include0: _Include0 {

	public init() {}

	public init(from decoder: Decoder) throws {
	}

	public func encode(to encoder: Encoder) throws {
		throw JSONAPIEncodingError.illegalEncoding("Attempted to encode Include0, which should be represented by the absence of an 'included' entry altogether.")
	}
}
public typealias NoIncludes = Include0

// MARK: - 1 include
public protocol _Include1: _Include0 {
	associatedtype A: EntityType
	var a: A? { get }
}
public enum Include1<A: EntityType>: _Include1 {
	case a(A)
	
	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
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

extension Includes where I: _Include1 {
	public subscript(_ lookup: I.A.Type) -> [I.A] {
		return values.compactMap { $0.a }
	}
}

// MARK: - 2 includes
public protocol _Include2: _Include1 {
	associatedtype B: EntityType
	var b: B? { get }
}
public enum Include2<A: EntityType, B: EntityType>: _Include2 {
	case a(A)
	case b(B)
	
	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let attempts = [
			try decode(A.self, from: container).map { Include2.a($0) },
			try decode(B.self, from: container).map { Include2.b($0) } ]
		
		let maybeVal: Include2<A, B>? = attempts
			.compactMap { $0.value }
			.first
		
		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Include2<A, B>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
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

extension Includes where I: _Include2 {
	public subscript(_ lookup: I.B.Type) -> [I.B] {
		return values.compactMap { $0.b }
	}
}

// MARK: - 3 includes
public protocol _Include3: _Include2 {
	associatedtype C: EntityType
	var c: C? { get }
}
public enum Include3<A: EntityType, B: EntityType, C: EntityType>: _Include3 {
	case a(A)
	case b(B)
	case c(C)
	
	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}
	
	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let attempts = [
			try decode(A.self, from: container).map { Include3.a($0) },
			try decode(B.self, from: container).map { Include3.b($0) },
			try decode(C.self, from: container).map { Include3.c($0) }]
		
		let maybeVal: Include3<A, B, C>? = attempts
			.compactMap { $0.value }
			.first
		
		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Include3<A, B, C>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
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

extension Includes where I: _Include3 {
	public subscript(_ lookup: I.C.Type) -> [I.C] {
		return values.compactMap { $0.c }
	}
}

// MARK: - 4 includes
public protocol _Include4: _Include3 {
	associatedtype D: EntityType
	var d: D? { get }
}
public enum Include4<A: EntityType, B: EntityType, C: EntityType, D: EntityType>: _Include4 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)
	
	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}
	
	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}
	
	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let attempts = [
			try decode(A.self, from: container).map { Include4.a($0) },
			try decode(B.self, from: container).map { Include4.b($0) },
			try decode(C.self, from: container).map { Include4.c($0) },
			try decode(D.self, from: container).map { Include4.d($0) }]
		
		let maybeVal: Include4<A, B, C, D>? = attempts
			.compactMap { $0.value }
			.first
		
		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Include4<A, B, C, D>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
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

extension Includes where I: _Include4 {
	public subscript(_ lookup: I.D.Type) -> [I.D] {
		return values.compactMap { $0.d }
	}
}

// MARK: - 5 includes
public protocol _Include5: _Include4 {
	associatedtype E: EntityType
	var e: E? { get }
}
public enum Include5<A: EntityType, B: EntityType, C: EntityType, D: EntityType, E: EntityType>: _Include5 {
	case a(A)
	case b(B)
	case c(C)
	case d(D)
	case e(E)
	
	public var a: A? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}
	
	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}
	
	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}
	
	public var e: E? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let attempts = [
			try decode(A.self, from: container).map { Include5.a($0) },
			try decode(B.self, from: container).map { Include5.b($0) },
			try decode(C.self, from: container).map { Include5.c($0) },
			try decode(D.self, from: container).map { Include5.d($0) },
			try decode(E.self, from: container).map { Include5.e($0) }]
		
		let maybeVal: Include5<A, B, C, D, E>? = attempts
			.compactMap { $0.value }
			.first
		
		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Include5<A, B, C, D, E>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
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

extension Includes where I: _Include5 {
	public subscript(_ lookup: I.E.Type) -> [I.E] {
		return values.compactMap { $0.e }
	}
}

// MARK: - 6 includes
public protocol _Include6: _Include5 {
	associatedtype F: EntityType
	var f: F? { get }
}
public enum Include6<A: EntityType, B: EntityType, C: EntityType, D: EntityType, E: EntityType, F: EntityType>: _Include6 {
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
	
	public var b: B? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}
	
	public var c: C? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}
	
	public var d: D? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}
	
	public var e: E? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}
	
	public var f: F? {
		guard case let .f(ret) = self else { return nil }
		return ret
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		let attempts = [
			try decode(A.self, from: container).map { Include6.a($0) },
			try decode(B.self, from: container).map { Include6.b($0) },
			try decode(C.self, from: container).map { Include6.c($0) },
			try decode(D.self, from: container).map { Include6.d($0) },
			try decode(E.self, from: container).map { Include6.e($0) },
			try decode(F.self, from: container).map { Include6.f($0) }]
		
		let maybeVal: Include6<A, B, C, D, E, F>? = attempts
			.compactMap { $0.value }
			.first
		
		guard let val = maybeVal else {
			throw EncodingError.invalidValue(Include6<A, B, C, D, E, F>.self, .init(codingPath: decoder.codingPath, debugDescription: "Failed to find an include of the expected type. Attempts: \(attempts.map { $0.error }.compactMap { $0 })"))
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

extension Includes where I: _Include6 {
	public subscript(_ lookup: I.F.Type) -> [I.F] {
		return values.compactMap { $0.f }
	}
}
