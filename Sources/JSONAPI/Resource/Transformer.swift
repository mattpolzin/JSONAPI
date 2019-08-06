//
//  Transformer.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/17/18.
//

/// A Transformer simply defines a static function that transforms a value.
public protocol Transformer {
    associatedtype From
    associatedtype To

    /// Turn value of type `From` into a value of type `To` or
    /// throw an error on failure.
    static func transform(_ value: From) throws -> To
}

/// ReversibleTransformers define a function that reverses the transform
/// operation.
public protocol ReversibleTransformer: Transformer {
    /// Turn a value of type `To` into a value of type `From` or
    /// throw an error on failure.
    static func reverse(_ value: To) throws -> From
}

/// The IdentityTransformer does not perform any transformation on a value.
public enum IdentityTransformer<T>: ReversibleTransformer {
    public static func transform(_ value: T) throws -> T { return value }
    public static func reverse(_ value: T) throws -> T { return value }
}

// MARK: - Validator

/// A Validator is a Transformer that throws an error if an invalid value
/// is passed to it but it does not change the type of the value. Any
/// Transformer will perform validation in one sense so a Validator is
/// really just semantic sugar (it can provide clarity in its use).
/// To enforce the semantics, any change of the value in your implementation
/// of `Validator.transform()` will be ignored.
public protocol Validator: ReversibleTransformer where From == To {
}

extension Validator {
    public static func reverse(_ value: To) throws -> To {
        let _ = try transform(value)
        return value
    }

    /// Validate the given value and then return it if valid.
    /// throws an erro if invalid.
    /// - returns: The same value passed in, if it was valid.
    public static func validate(_ value: To) throws -> To {
        let _ = try transform(value)
        return value
    }
}
