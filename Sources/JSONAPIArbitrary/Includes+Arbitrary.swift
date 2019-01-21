//
//  Includes+Arbitrary.swift
//  JSONAPIArbitrary
//
//  Created by Mathew Polzin on 1/21/19.
//

import SwiftCheck
import JSONAPI

extension Includes: Arbitrary where I: Arbitrary {
	public static var arbitrary: Gen<Includes<I>> {
		return I
			.arbitrary
			.proliferate
			.map(Includes.init(values:))
	}
}

extension NoIncludes: Arbitrary {
	public static var arbitrary: Gen<NoIncludes> {
		return Gen.pure(NoIncludes())
	}
}

extension Include1: Arbitrary where A: Arbitrary {
	public static var arbitrary: Gen<Include1<A>> {
		return Gen.one(of: [
			A.arbitrary.map(Include1.init)
			])
	}
}

extension Include2: Arbitrary where A: Arbitrary, B: Arbitrary {
	public static var arbitrary: Gen<Include2<A, B>> {
		return Gen.one(of: [
			A.arbitrary.map(Include2.init),
			B.arbitrary.map(Include2.init)
			])
	}
}

extension Include3: Arbitrary where A: Arbitrary, B: Arbitrary, C: Arbitrary {
	public static var arbitrary: Gen<Include3<A, B, C>> {
		return Gen.one(of: [
			A.arbitrary.map(Include3.init),
			B.arbitrary.map(Include3.init),
			C.arbitrary.map(Include3.init)
			])
	}
}

extension Include4: Arbitrary where A: Arbitrary, B: Arbitrary, C: Arbitrary, D: Arbitrary {
	public static var arbitrary: Gen<Include4<A, B, C, D>> {
		return Gen.one(of: [
			A.arbitrary.map(Include4.init),
			B.arbitrary.map(Include4.init),
			C.arbitrary.map(Include4.init),
			D.arbitrary.map(Include4.init)
			])
	}
}

extension Include5: Arbitrary where A: Arbitrary, B: Arbitrary, C: Arbitrary, D: Arbitrary, E: Arbitrary {
	public static var arbitrary: Gen<Include5<A, B, C, D, E>> {
		return Gen.one(of: [
			A.arbitrary.map(Include5.init),
			B.arbitrary.map(Include5.init),
			C.arbitrary.map(Include5.init),
			D.arbitrary.map(Include5.init),
			E.arbitrary.map(Include5.init)
			])
	}
}

extension Include6: Arbitrary where A: Arbitrary, B: Arbitrary, C: Arbitrary, D: Arbitrary, E: Arbitrary, F: Arbitrary {
	public static var arbitrary: Gen<Include6<A, B, C, D, E, F>> {
		// Note broken up because compiler cannot typecheck entire array
		// before it times out
		let set1: [Gen<Include6<A, B, C, D, E, F>>] = [
			A.arbitrary.map(Include6.init),
			B.arbitrary.map(Include6.init),
			C.arbitrary.map(Include6.init)
		]

		let set2: [Gen<Include6<A, B, C, D, E, F>>] = [
			D.arbitrary.map(Include6.init),
			E.arbitrary.map(Include6.init),
			F.arbitrary.map(Include6.init)
		]

		return Gen.one(of: set1 + set2)
	}
}

extension Include7: Arbitrary where A: Arbitrary, B: Arbitrary, C: Arbitrary, D: Arbitrary, E: Arbitrary, F: Arbitrary, G: Arbitrary {
	public static var arbitrary: Gen<Include7<A, B, C, D, E, F, G>> {
		// Note broken up because compiler cannot typecheck entire array
		// before it times out
		let set1: [Gen<Include7<A, B, C, D, E, F, G>>] = [
			A.arbitrary.map(Include7.init),
			B.arbitrary.map(Include7.init),
			C.arbitrary.map(Include7.init)
		]

		let set2: [Gen<Include7<A, B, C, D, E, F, G>>] = [
			D.arbitrary.map(Include7.init),
			E.arbitrary.map(Include7.init),
			F.arbitrary.map(Include7.init),
			G.arbitrary.map(Include7.init)
		]

		return Gen.one(of: set1 + set2)
	}
}

extension Include8: Arbitrary where A: Arbitrary, B: Arbitrary, C: Arbitrary, D: Arbitrary, E: Arbitrary, F: Arbitrary, G: Arbitrary, H: Arbitrary {
	public static var arbitrary: Gen<Include8<A, B, C, D, E, F, G, H>> {
		// Note broken up because compiler cannot typecheck entire array
		// before it times out
		let set1: [Gen<Include8<A, B, C, D, E, F, G, H>>] = [
			A.arbitrary.map(Include8.init),
			B.arbitrary.map(Include8.init),
			C.arbitrary.map(Include8.init)
		]

		let set2: [Gen<Include8<A, B, C, D, E, F, G, H>>] = [
			D.arbitrary.map(Include8.init),
			E.arbitrary.map(Include8.init),
			F.arbitrary.map(Include8.init)
		]

		let set3: [Gen<Include8<A, B, C, D, E, F, G, H>>] = [
			G.arbitrary.map(Include8.init),
			H.arbitrary.map(Include8.init)
		]

		return Gen.one(of: set1 + set2 + set3)
	}
}

extension Include9: Arbitrary where A: Arbitrary, B: Arbitrary, C: Arbitrary, D: Arbitrary, E: Arbitrary, F: Arbitrary, G: Arbitrary, H: Arbitrary, I: Arbitrary {
	public static var arbitrary: Gen<Include9<A, B, C, D, E, F, G, H, I>> {
		// Note broken up because compiler cannot typecheck entire array
		// before it times out
		let set1: [Gen<Include9<A, B, C, D, E, F, G, H, I>>] = [
			A.arbitrary.map(Include9.init),
			B.arbitrary.map(Include9.init),
			C.arbitrary.map(Include9.init)
		]

		let set2: [Gen<Include9<A, B, C, D, E, F, G, H, I>>] = [
			D.arbitrary.map(Include9.init),
			E.arbitrary.map(Include9.init),
			F.arbitrary.map(Include9.init)
		]

		let set3: [Gen<Include9<A, B, C, D, E, F, G, H, I>>] = [
			G.arbitrary.map(Include9.init),
			H.arbitrary.map(Include9.init),
			I.arbitrary.map(Include9.init)
		]

		return Gen.one(of: set1 + set2 + set3)
	}
}
