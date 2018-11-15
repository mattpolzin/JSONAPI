//
//  Includes.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/10/18.
//

import Result

public protocol IncludeDecoder: Decodable {}

public struct Includes<I: IncludeDecoder>: Decodable {
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
	
	public var count: Int {
		return values.count
	}
}

// MARK: - Decoding

func decode<EntityType: JSONAPI.EntityDescription>(_ type: EntityType.Type, from container: SingleValueDecodingContainer) throws -> Result<Entity<EntityType>, EncodingError> {
	let ret: Result<Entity<EntityType>, EncodingError>
	do {
		ret = try .success(container.decode(Entity<EntityType>.self))
	} catch (let err as EncodingError) {
		ret = .failure(err)
	} catch (let err) {
		ret = .failure(EncodingError.invalidValue(EntityType.self,
												  .init(codingPath: container.codingPath,
														debugDescription: err.localizedDescription,
														underlyingError: err)))
	}
	return ret
}

// MARK: - 0 includes

public protocol _Include0: IncludeDecoder { }
public struct Include0: _Include0 {
	
	public init(from decoder: Decoder) throws {
	}
}
public typealias NoIncludes = Include0

// MARK: - 1 include
public protocol _Include1: _Include0 {
	associatedtype A: EntityDescription
	var a: Entity<A>? { get }
}
public enum Include1<A: EntityDescription>: _Include1 {
	case a(Entity<A>)
	
	public var a: Entity<A>? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.singleValueContainer()
		
		self = .a(try container.decode(Entity<A>.self))
	}
}

extension Includes where I: _Include1 {
	public subscript(_ lookup: I.A.Type) -> [Entity<I.A>] {
		return values.compactMap { $0.a }
	}
	
	public subscript(_ lookup: Entity<I.A>.Type) -> [Entity<I.A>] {
		return values.compactMap { $0.a}
	}
}

// MARK: - 2 includes
public protocol _Include2: _Include1 {
	associatedtype B: EntityDescription
	var b: Entity<B>? { get }
}
public enum Include2<A: EntityDescription, B: EntityDescription>: _Include2 {
	case a(Entity<A>)
	case b(Entity<B>)
	
	public var a: Entity<A>? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public var b: Entity<B>? {
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
}

extension Includes where I: _Include2 {
	public subscript(_ lookup: I.B.Type) -> [Entity<I.B>] {
		return values.compactMap { $0.b }
	}
	
	public subscript(_ lookup: Entity<I.B>.Type) -> [Entity<I.B>] {
		return values.compactMap { $0.b}
	}
}

// MARK: - 3 includes
public protocol _Include3: _Include2 {
	associatedtype C: EntityDescription
	var c: Entity<C>? { get }
}
public enum Include3<A: EntityDescription, B: EntityDescription, C: EntityDescription>: _Include3 {
	case a(Entity<A>)
	case b(Entity<B>)
	case c(Entity<C>)
	
	public var a: Entity<A>? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public var b: Entity<B>? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}
	
	public var c: Entity<C>? {
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
}

extension Includes where I: _Include3 {
	public subscript(_ lookup: I.C.Type) -> [Entity<I.C>] {
		return values.compactMap { $0.c }
	}
	
	public subscript(_ lookup: Entity<I.C>.Type) -> [Entity<I.C>] {
		return values.compactMap { $0.c}
	}
}

// MARK: - 4 includes
public protocol _Include4: _Include3 {
	associatedtype D: EntityDescription
	var d: Entity<D>? { get }
}
public enum Include4<A: EntityDescription, B: EntityDescription, C: EntityDescription, D: EntityDescription>: _Include4 {
	case a(Entity<A>)
	case b(Entity<B>)
	case c(Entity<C>)
	case d(Entity<D>)
	
	public var a: Entity<A>? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public var b: Entity<B>? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}
	
	public var c: Entity<C>? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}
	
	public var d: Entity<D>? {
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
}

extension Includes where I: _Include4 {
	public subscript(_ lookup: I.D.Type) -> [Entity<I.D>] {
		return values.compactMap { $0.d }
	}
	
	public subscript(_ lookup: Entity<I.D>.Type) -> [Entity<I.D>] {
		return values.compactMap { $0.d}
	}
}

// MARK: - 5 includes
public protocol _Include5: _Include4 {
	associatedtype E: EntityDescription
	var e: Entity<E>? { get }
}
public enum Include5<A: EntityDescription, B: EntityDescription, C: EntityDescription, D: EntityDescription, E: EntityDescription>: _Include5 {
	case a(Entity<A>)
	case b(Entity<B>)
	case c(Entity<C>)
	case d(Entity<D>)
	case e(Entity<E>)
	
	public var a: Entity<A>? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public var b: Entity<B>? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}
	
	public var c: Entity<C>? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}
	
	public var d: Entity<D>? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}
	
	public var e: Entity<E>? {
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
}

extension Includes where I: _Include5 {
	public subscript(_ lookup: I.E.Type) -> [Entity<I.E>] {
		return values.compactMap { $0.e }
	}
	
	public subscript(_ lookup: Entity<I.E>.Type) -> [Entity<I.E>] {
		return values.compactMap { $0.e}
	}
}

// MARK: - 6 includes
public protocol _Include6: _Include5 {
	associatedtype F: EntityDescription
	var f: Entity<F>? { get }
}
public enum Include6<A: EntityDescription, B: EntityDescription, C: EntityDescription, D: EntityDescription, E: EntityDescription, F: EntityDescription>: _Include6 {
	case a(Entity<A>)
	case b(Entity<B>)
	case c(Entity<C>)
	case d(Entity<D>)
	case e(Entity<E>)
	case f(Entity<F>)
	
	public var a: Entity<A>? {
		guard case let .a(ret) = self else { return nil }
		return ret
	}
	
	public var b: Entity<B>? {
		guard case let .b(ret) = self else { return nil }
		return ret
	}
	
	public var c: Entity<C>? {
		guard case let .c(ret) = self else { return nil }
		return ret
	}
	
	public var d: Entity<D>? {
		guard case let .d(ret) = self else { return nil }
		return ret
	}
	
	public var e: Entity<E>? {
		guard case let .e(ret) = self else { return nil }
		return ret
	}
	
	public var f: Entity<F>? {
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
}

extension Includes where I: _Include6 {
	public subscript(_ lookup: I.F.Type) -> [Entity<I.F>] {
		return values.compactMap { $0.f }
	}
	
	public subscript(_ lookup: Entity<I.F>.Type) -> [Entity<I.F>] {
		return values.compactMap { $0.f}
	}
}
