import Foundation
import JSONAPI
import JSONAPITesting // for the convenience of literal initialization
import JSONAPIOpenAPI
import SwiftCheck
import JSONAPIArbitrary

extension PersonDescription.Attributes: Arbitrary, Sampleable {
	public static var arbitrary: Gen<PersonDescription.Attributes> {
		return Gen.compose { c in
			return PersonDescription.Attributes(name: c.generate(),
												favoriteColor: c.generate())
		}
	}

	public static var sample: PersonDescription.Attributes {
		return .init(name: ["Abbie", "Eibba"], favoriteColor: "Blue")
	}
}

extension PersonDescription.Relationships: Arbitrary, Sampleable {
	public static var arbitrary: Gen<PersonDescription.Relationships> {
		return Gen.compose { c in
			return PersonDescription.Relationships(friends: c.generate(),
												   dogs: c.generate(),
												   home: c.generate())
		}
	}

	public static var sample: PersonDescription.Relationships {
		return .init(friends: ["1", "2"], dogs: ["2"], home: "1")
	}
}

extension DogDescription.Attributes: Arbitrary, Sampleable {
	public static var arbitrary: Gen<DogDescription.Attributes> {
		return Gen.compose { c in
			return DogDescription.Attributes(name: c.generate())
		}
	}

	public static var sample: DogDescription.Attributes {
		return DogDescription.Attributes.arbitrary.generate
	}
}

extension DogDescription.Relationships: Arbitrary, Sampleable {
	public static var arbitrary: Gen<DogDescription.Relationships> {
		return Gen.compose { c in
			return DogDescription.Relationships(owner: c.generate())
		}
	}

	public static var sample: DogDescription.Relationships {
		return DogDescription.Relationships.arbitrary.generate
	}
}

extension Document: Sampleable where PrimaryResourceBody: Arbitrary, IncludeType: Arbitrary, MetaType: Arbitrary, LinksType: Arbitrary, Error: Arbitrary, APIDescription: Arbitrary {
	public static var sample: Document {
		return Document.arbitrary.generate
	}

	public static var successSample: Document? {
		return Document.arbitraryData.generate
	}

	public static var failureSample: Document? {
		return Document.arbitraryErrors.generate
	}
}
