//
//  Sampleable.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/15/19.
//

import Foundation

/// A Sampleable type can provide a sample value.
/// This is useful for reflection.
public protocol Sampleable {
	/// Get a sample value of type Self. This can be the
	/// same value every time, or it can be an arbitrarily random
	/// value each time.
	static var sample: Self { get }

	/// Get an example of success, if that is meaningful and
	/// available. If not, will be nil.
	///
	/// (optional)
	///
	/// The default implementation returns `nil`.
	static var successSample: Self? { get }

	/// Get an example of failure, if that is meaningful and
	/// available. If not, will be nil.
	///
	/// (optional)
	///
	/// The default implementation returns `nil`.
	static var failureSample: Self? { get }

	/// An array of samples of this Type.
	///
	/// (optional)
	///
	/// The default implementation returns
	/// an array with just the result of
	/// `Self.sample` in it.
	static var samples: [Self] { get }
}

public extension Sampleable {
	// default implementation:
	public static var successSample: Self? { return nil }

	// default implementation:
	public static var failureSample: Self? { return nil }

	// default implementation:
	public static var samples: [Self] { return [Self.sample] }
}

extension Sampleable {
	public static func samples<S1: Sampleable>(using s1: S1.Type, with constructor: (S1) -> Self) -> [Self] {
		return S1.samples.map(constructor)
	}

	public static func samples<S1: Sampleable, S2: Sampleable>(using s1: S1.Type, _ s2: S2.Type, with constructor: (S1, S2) -> Self) -> [Self] {
		return zip(S1.samples, S2.samples).map(constructor)
	}

	public static func samples<S1: Sampleable, S2: Sampleable, S3: Sampleable>(using s1: S1.Type, _ s2: S2.Type, _ s3: S3.Type, with constructor: (S1, S2, S3) -> Self) -> [Self] {
		return zip3(S1.samples, S2.samples, S3.samples).map(constructor)
	}

	public static func samples<S1: Sampleable, S2: Sampleable, S3: Sampleable, S4: Sampleable>(using s1: S1.Type, _ s2: S2.Type, _ s3: S3.Type, _ s4: S4.Type, with constructor: (S1, S2, S3, S4) -> Self) -> [Self] {
		return zip4(S1.samples, S2.samples, S3.samples, S4.samples).map(constructor)
	}

	public static func samples<S1: Sampleable, S2: Sampleable, S3: Sampleable, S4: Sampleable, S5: Sampleable>(using s1: S1.Type, _ s2: S2.Type, _ s3: S3.Type, _ s4: S4.Type, _ s5: S5.Type, with constructor: (S1, S2, S3, S4, S5) -> Self) -> [Self] {
		return zip5(S1.samples, S2.samples, S3.samples, S4.samples, S5.samples).map(constructor)
	}

	public static func samples<S1: Sampleable, S2: Sampleable, S3: Sampleable, S4: Sampleable, S5: Sampleable, S6: Sampleable>(using s1: S1.Type, _ s2: S2.Type, _ s3: S3.Type, _ s4: S4.Type, _ s5: S5.Type, _ s6: S6.Type, with constructor: (S1, S2, S3, S4, S5, S6) -> Self) -> [Self] {
		// the compiler craps out at zip6. breaking it down makes the difference.
		let firstZip = zip3(S1.samples, S2.samples, S3.samples)
		let secondZip = zip3(S4.samples, S5.samples, S6.samples)
		return zip(firstZip, secondZip).map { arg in (arg.0.0, arg.0.1, arg.0.2, arg.1.0, arg.1.1, arg.1.2) }.map(constructor)
	}

	public static func samples<S1: Sampleable, S2: Sampleable, S3: Sampleable, S4: Sampleable, S5: Sampleable, S6: Sampleable, S7: Sampleable>(using s1: S1.Type, _ s2: S2.Type, _ s3: S3.Type, _ s4: S4.Type, _ s5: S5.Type, _ s6: S6.Type, _ s7: S7.Type, with constructor: (S1, S2, S3, S4, S5, S6, S7) -> Self) -> [Self] {
		// the compiler craps out at zip6. breaking it down makes the difference.
		let firstZip = zip3(S1.samples, S2.samples, S3.samples)
		let secondZip = zip4(S4.samples, S5.samples, S6.samples, S7.samples)
		return zip(firstZip, secondZip).map { arg in (arg.0.0, arg.0.1, arg.0.2, arg.1.0, arg.1.1, arg.1.2, arg.1.3) }.map(constructor)
	}

	public static func samples<S1: Sampleable, S2: Sampleable, S3: Sampleable, S4: Sampleable, S5: Sampleable, S6: Sampleable, S7: Sampleable, S8: Sampleable>(using s1: S1.Type, _ s2: S2.Type, _ s3: S3.Type, _ s4: S4.Type, _ s5: S5.Type, _ s6: S6.Type, _ s7: S7.Type, _ s8: S8.Type, with constructor: (S1, S2, S3, S4, S5, S6, S7, S8) -> Self) -> [Self] {
		// the compiler craps out at zip6. breaking it down makes the difference.
		let firstZip = zip4(S1.samples, S2.samples, S3.samples, S4.samples)
		let secondZip = zip4(S5.samples, S6.samples, S7.samples, S8.samples)
		return zip(firstZip, secondZip).map { arg in (arg.0.0, arg.0.1, arg.0.2, arg.0.3, arg.1.0, arg.1.1, arg.1.2, arg.1.3) }.map(constructor)
	}

	@inlinable static func zip3<A: Sequence, B: Sequence, C: Sequence>(_ a: A, _ b: B, _ c: C) -> [(A.Element, B.Element, C.Element)] {
		return zip(a, zip(b, c)).map { arg in (arg.0, arg.1.0, arg.1.1) }
	}

	@inlinable static func zip4<A: Sequence, B: Sequence, C: Sequence, D: Sequence>(_ a: A, _ b: B, _ c: C, _ d: D) -> [(A.Element, B.Element, C.Element, D.Element)] {
		return zip(a, zip(b, zip(c, d))).map { arg in (arg.0, arg.1.0, arg.1.1.0, arg.1.1.1) }
	}

	@inlinable static func zip5<A: Sequence, B: Sequence, C: Sequence, D: Sequence, E: Sequence>(_ a: A, _ b: B, _ c: C, _ d: D, _ e: E) -> [(A.Element, B.Element, C.Element, D.Element, E.Element)] {
		return zip(a, zip(b, zip(c, zip(d, e)))).map { arg in (arg.0, arg.1.0, arg.1.1.0, arg.1.1.1.0, arg.1.1.1.1) }
	}
}
