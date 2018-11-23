//
//  Transformer.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/17/18.
//

public protocol Transformer {
	associatedtype From
	associatedtype To

	static func transform(_ from: From) throws -> To
}

public enum IdentityTransformer<T>: Transformer {
	public static func transform(_ from: T) throws -> T { return from }
}

// MARK: - Validator

/// A Validator is a Transformer that throws an error if an invalid value
/// is passed to it but it does not change the type of the value. Any
/// Transformer will perform validation in one sense so a Validator is
/// really just semantic sugar (it can provide clarity in its use).
public protocol Validator: Transformer where From == To {}

extension Validator {
	public static func validate(_ value: To) throws -> To {
		return try transform(value)
	}
}
