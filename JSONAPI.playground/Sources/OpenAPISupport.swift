import Foundation
import JSONAPI
import JSONAPITesting // for the convenience of literal initialization
import JSONAPIOpenAPI

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
