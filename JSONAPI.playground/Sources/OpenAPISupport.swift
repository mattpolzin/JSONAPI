import Foundation
import JSONAPI
import JSONAPITesting // for the convenience of literal initialization
import JSONAPIOpenAPI
import SwiftCheck
import JSONAPIArbitrary

extension PersonDescription.Attributes: Sampleable {
	public static var sample: PersonDescription.Attributes {
		return .init(name: ["Abbie", "Eibba"], favoriteColor: "Blue")
	}
}

extension PersonDescription.Relationships: Sampleable {
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
}
