//
//  Include+Sampleable.swift
//  JSONAPIOpenAPI
//
//  Created by Mathew Polzin on 1/23/19.
//

import JSONAPI
import Sampleable

extension Includes: Sampleable where I: Sampleable {
	public static var sample: Includes<I> {
		guard I.self != NoIncludes.self else {
			return .none
		}

		return .init(values: I.samples)
	}
}

extension NoIncludes: Sampleable {
	public static var sample: NoIncludes {
		return NoIncludes()
	}
}

extension Include1: Sampleable where A: Sampleable {
	public static var sample: Include1<A> {
		return .init(A.sample)
	}

	public static var samples: [Include1<A>] {
		return A.samples.map(Include1<A>.init)
	}
}

extension Include2: Sampleable where A: Sampleable, B: Sampleable {
	public static var sample: Include2<A, B> {
		let randomChoice = Int.random(in: 0..<samples.count)

		return samples[randomChoice]
	}

	public static var samples: [Include2<A, B>] {
		return A.samples.map(Include2<A, B>.init)
			+ B.samples.map(Include2<A, B>.init)
	}
}

extension Include3: Sampleable where A: Sampleable, B: Sampleable, C: Sampleable {
	public static var sample: Include3<A, B, C> {
		let randomChoice = Int.random(in: 0..<samples.count)

		return samples[randomChoice]
	}

	public static var samples: [Include3<A, B, C>] {
		return A.samples.map(Include3<A, B, C>.init)
			+ B.samples.map(Include3<A, B, C>.init)
			+ C.samples.map(Include3<A, B, C>.init)
	}
}

extension Include4: Sampleable where A: Sampleable, B: Sampleable, C: Sampleable, D: Sampleable {
	public static var sample: Include4<A, B, C, D> {
		let randomChoice = Int.random(in: 0..<samples.count)

		return samples[randomChoice]
	}

	public static var samples: [Include4<A, B, C, D>] {
		return A.samples.map(Include4<A, B, C, D>.init)
			+ B.samples.map(Include4<A, B, C, D>.init)
			+ C.samples.map(Include4<A, B, C, D>.init)
			+ D.samples.map(Include4<A, B, C, D>.init)
	}
}

extension Include5: Sampleable where A: Sampleable, B: Sampleable, C: Sampleable, D: Sampleable, E: Sampleable {
	public static var sample: Include5<A, B, C, D, E> {
		let randomChoice = Int.random(in: 0..<samples.count)

		return samples[randomChoice]
	}

	public static var samples: [Include5<A, B, C, D, E>] {
		let set1: [Include5<A, B, C, D, E>] = A.samples.map(Include5<A, B, C, D, E>.init)
			+ B.samples.map(Include5<A, B, C, D, E>.init)
			+ C.samples.map(Include5<A, B, C, D, E>.init)

		let set2: [Include5<A, B, C, D, E>] = D.samples.map(Include5<A, B, C, D, E>.init)
			+ E.samples.map(Include5<A, B, C, D, E>.init)

		return set1 + set2
	}
}

extension Include6: Sampleable where A: Sampleable, B: Sampleable, C: Sampleable, D: Sampleable, E: Sampleable, F: Sampleable {
	public static var sample: Include6<A, B, C, D, E, F> {
		let randomChoice = Int.random(in: 0..<samples.count)

		return samples[randomChoice]
	}

	public static var samples: [Include6<A, B, C, D, E, F>] {
		let set1: [Include6<A, B, C, D, E, F>] = A.samples.map(Include6<A, B, C, D, E, F>.init)
			+ B.samples.map(Include6<A, B, C, D, E, F>.init)
			+ C.samples.map(Include6<A, B, C, D, E, F>.init)

		let set2: [Include6<A, B, C, D, E, F>] = D.samples.map(Include6<A, B, C, D, E, F>.init)
			+ E.samples.map(Include6<A, B, C, D, E, F>.init)
			+ F.samples.map(Include6<A, B, C, D, E, F>.init)

		return set1 + set2
	}
}

extension Include7: Sampleable where A: Sampleable, B: Sampleable, C: Sampleable, D: Sampleable, E: Sampleable, F: Sampleable, G: Sampleable {
	public static var sample: Include7<A, B, C, D, E, F, G> {
		let randomChoice = Int.random(in: 0..<samples.count)

		return samples[randomChoice]
	}

	public static var samples: [Include7<A, B, C, D, E, F, G>] {
		let set1: [Include7<A, B, C, D, E, F, G>] = A.samples.map(Include7<A, B, C, D, E, F, G>.init)
			+ B.samples.map(Include7<A, B, C, D, E, F, G>.init)
			+ C.samples.map(Include7<A, B, C, D, E, F, G>.init)

		let set2: [Include7<A, B, C, D, E, F, G>] = D.samples.map(Include7<A, B, C, D, E, F, G>.init)
			+ E.samples.map(Include7<A, B, C, D, E, F, G>.init)
			+ F.samples.map(Include7<A, B, C, D, E, F, G>.init)

		let set3: [Include7<A, B, C, D, E, F, G>] = G.samples.map(Include7<A, B, C, D, E, F, G>.init)

		return set1 + set2 + set3
	}
}

extension Include8: Sampleable where A: Sampleable, B: Sampleable, C: Sampleable, D: Sampleable, E: Sampleable, F: Sampleable, G: Sampleable, H: Sampleable {
	public static var sample: Include8<A, B, C, D, E, F, G, H> {
		let randomChoice = Int.random(in: 0..<samples.count)

		return samples[randomChoice]
	}

	public static var samples: [Include8<A, B, C, D, E, F, G, H>] {
		let set1: [Include8<A, B, C, D, E, F, G, H>] = A.samples.map(Include8<A, B, C, D, E, F, G, H>.init)
			+ B.samples.map(Include8<A, B, C, D, E, F, G, H>.init)
			+ C.samples.map(Include8<A, B, C, D, E, F, G, H>.init)

		let set2: [Include8<A, B, C, D, E, F, G, H>] = D.samples.map(Include8<A, B, C, D, E, F, G, H>.init)
			+ E.samples.map(Include8<A, B, C, D, E, F, G, H>.init)
			+ F.samples.map(Include8<A, B, C, D, E, F, G, H>.init)

		let set3: [Include8<A, B, C, D, E, F, G, H>] = G.samples.map(Include8<A, B, C, D, E, F, G, H>.init)
			+ H.samples.map(Include8<A, B, C, D, E, F, G, H>.init)

		return set1 + set2 + set3
	}
}

extension Include9: Sampleable where A: Sampleable, B: Sampleable, C: Sampleable, D: Sampleable, E: Sampleable, F: Sampleable, G: Sampleable, H: Sampleable, I: Sampleable {
	public static var sample: Include9<A, B, C, D, E, F, G, H, I> {
		let randomChoice = Int.random(in: 0..<samples.count)

		return samples[randomChoice]
	}

	public static var samples: [Include9<A, B, C, D, E, F, G, H, I>] {
		let set1: [Include9<A, B, C, D, E, F, G, H, I>] = A.samples.map(Include9<A, B, C, D, E, F, G, H, I>.init)
			+ B.samples.map(Include9<A, B, C, D, E, F, G, H, I>.init)
			+ C.samples.map(Include9<A, B, C, D, E, F, G, H, I>.init)

		let set2: [Include9<A, B, C, D, E, F, G, H, I>] = D.samples.map(Include9<A, B, C, D, E, F, G, H, I>.init)
			+ E.samples.map(Include9<A, B, C, D, E, F, G, H, I>.init)
			+ F.samples.map(Include9<A, B, C, D, E, F, G, H, I>.init)

		let set3: [Include9<A, B, C, D, E, F, G, H, I>] = G.samples.map(Include9<A, B, C, D, E, F, G, H, I>.init)
			+ H.samples.map(Include9<A, B, C, D, E, F, G, H, I>.init)
			+ I.samples.map(Include9<A, B, C, D, E, F, G, H, I>.init)

		return set1 + set2 + set3
	}
}
