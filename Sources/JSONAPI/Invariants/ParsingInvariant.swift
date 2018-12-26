//
//  ParsingInvariant.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 12/24/18.
//

/// An Error produced when an invariant fails.
public enum InvariantError: Swift.Error {
	case failure(description: String)
}

/// Set a reaction to a particular type of invariant failure.
/// `Warning` and `Quiet` will take a default strategy for handling
/// the invariant and parsing will not fail. `Error` will cause parsing
/// to fail due to the given invariant failing.
public protocol IReaction {
	/// Perform the given Invariant strategy.
	static func trigger(invariant: InvariantType.Type) throws
}

public enum Invariant {
	/// Used to indicate an invariant failure shoud be considered an error.
	/// Parsing will fail if an Error invariant fails.
	public enum Error: IReaction {
		public static func trigger(invariant: InvariantType.Type) throws {
			throw InvariantError.failure(description: String(describing: invariant))
		}
	}

	/// Used to indicate an invariant failure should be considered a warning.
	/// The invariant description will be printed to the console but parsing
	/// will not fail. A default strategy for addressing the invariant will
	/// be taken. See the given invariant's documentation for details.
	public enum Warning: IReaction {
		public static func trigger(invariant: InvariantType.Type) throws {
			print("**WARN** \(String(describing: invariant))")
		}
	}

	/// Used to indicate an invariant failures should be considered inconsequential.
	/// Parsing will continue and a default strategy for addressing the invariant
	/// will be taken. See the given invariant's documentation for details.
	public enum Quiet: IReaction {
		public static func trigger(invariant: InvariantType.Type) throws {}
	}

	/// A strategy pairs an invariant type with the desired reaction.
	public enum Strategy<IType: InvariantType, IReaction: JSONAPI.IReaction>: IStrategy {}
}

public protocol InvariantType {}

public protocol IStrategy {
	associatedtype IType: InvariantType
	associatedtype IReaction: JSONAPI.IReaction
}

// TODO: Does this invariant make sense? I can't actually know whether arbitrary
// Id types are "empty" so I think I started down this path without having fully
// thought through it. Perhaps there are still other obvious invariants to add
// though.
public protocol RelationshipNonEmptyIdInvariant: IStrategy where IType == Invariant.Relationships.NonEmptyId {}

extension Invariant {
	public enum Relationships {

		/// The Empty Id Invariant holds as long as a relationships's Id
		/// is not "empty"
		public enum NonEmptyId: InvariantType {}

		public enum Strategies<NonEmptyId: RelationshipNonEmptyIdInvariant> {}
	}
}

// Would be used like `ToOneRelationship<OtherEntity, Invariant.Relationships.Strategies<Invariant.Strategy<Invariant.Relationships.NonEmptyId, Invariant.Error>>>`
