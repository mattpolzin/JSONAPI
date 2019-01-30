//
//  Examples.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 11/12/18.
//

import Foundation
import JSONAPI

/*******

Please enjoy these examples, but allow me the forced casting and the lack of error checking for the sake of brevity.

********/

// MARK: - String as CreatableRawIdType
var GlobalStringId: Int = 0
extension String: CreatableRawIdType {
	public static func unique() -> String {
		GlobalStringId += 1
		return String(GlobalStringId)
	}
}

// MARK: - typealiases for convenience
public typealias ExampleEntity<Description: EntityDescription> = Entity<Description, NoMetadata, NoLinks, String>
public typealias ToOne<E: Identifiable> = ToOneRelationship<E, NoMetadata, NoLinks>
public typealias ToMany<E: Relatable> = ToManyRelationship<E, NoMetadata, NoLinks>

// MARK: - A few resource objects (entities)
public enum PersonDescription: EntityDescription {

	public static var jsonType: String { return "people" }
	
	public struct Attributes: JSONAPI.Attributes {
		public let name: Attribute<[String]>
		public let favoriteColor: Attribute<String>

		public var fullName: Attribute<String> {
			return name.map { $0.joined(separator: " ") }
		}

		public init(name: Attribute<[String]>, favoriteColor: Attribute<String>) {
			self.name = name
			self.favoriteColor = favoriteColor
		}
	}
	
	public struct Relationships: JSONAPI.Relationships {
		public let friends: ToMany<Person>
		public let dogs: ToMany<Dog>
		public let home: ToOne<House>

		public init(friends: ToMany<Person>, dogs: ToMany<Dog>, home: ToOne<House>) {
			self.friends = friends
			self.dogs = dogs
			self.home = home
		}
	}
}

public typealias Person = ExampleEntity<PersonDescription>

public extension Entity where Description == PersonDescription, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType == String {
	public init(id: Person.Id? = nil,name: [String], favoriteColor: String, friends: [Person], dogs: [Dog], home: House) throws {
		self = Person(id: id ?? Person.Id(), attributes: .init(name: .init(value: name), favoriteColor: .init(value: favoriteColor)), relationships: .init(friends: .init(entities: friends), dogs: .init(entities: dogs), home: .init(entity: home)), meta: .none, links: .none)
	}
}

public enum DogDescription: EntityDescription {

	public static var jsonType: String { return "dogs" }

	public struct Attributes: JSONAPI.Attributes {
		public let name: Attribute<String>

		public init(name: Attribute<String>) {
			self.name = name
		}
	}

	public struct Relationships: JSONAPI.Relationships {
		public let owner: ToOne<Person?>

		public init(owner: ToOne<Person?>) {
			self.owner = owner
		}
	}
}

public typealias Dog = ExampleEntity<DogDescription>

public enum AlternativeDogDescription: EntityDescription {

	public static var jsonType: String { return "dogs" }

	public struct Attributes: JSONAPI.Attributes {
		public let name: Attribute<String>

		public init(name: Attribute<String>) {
			self.name = name
		}
	}

	public struct Relationships: JSONAPI.Relationships {
		public let human: ToOne<Person?>

		public init(human: ToOne<Person?>) {
			self.human = human
		}

		// define custom key mapping:
		enum CodingKeys: String, CodingKey {
			case human = "owner"
		}
	}
}

public typealias AlternativeDog = ExampleEntity<AlternativeDogDescription>

public extension Entity where Description == DogDescription, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType == String {
	public init(name: String, owner: Person?) throws {
		self = Dog(attributes: .init(name: .init(value: name)), relationships: DogDescription.Relationships(owner: .init(entity: owner)), meta: .none, links: .none)
	}

	public init(name: String, owner: Person.Id) throws {
		self = Dog(attributes: .init(name: .init(value: name)), relationships: .init(owner: .init(id: owner)), meta: .none, links: .none)
	}
}

public enum HouseDescription: EntityDescription {

	public static var jsonType: String { return "houses" }

	public typealias Attributes = NoAttributes
	public typealias Relationships = NoRelationships
}

public typealias House = ExampleEntity<HouseDescription>

public typealias SingleDogDocument = JSONAPI.Document<SingleResourceBody<Dog>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, UnknownJSONAPIError>

public typealias BatchPeopleDocument = JSONAPI.Document<ManyResourceBody<Person>, NoMetadata, NoLinks, Include2<Dog, House>, NoAPIDescription, UnknownJSONAPIError>
