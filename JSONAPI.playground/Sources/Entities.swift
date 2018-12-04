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

// MARK: - Entity typealias for convenience
public typealias ExampleEntity<Description: EntityDescription> = Entity<Description, NoMetadata, NoLinks, String>

// MARK: - A few resource objects (entities)
public enum PersonDescription: EntityDescription {

	public static var type: String { return "people" }
	
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
		public let friends: ToManyRelationship<Person>
		public let dogs: ToManyRelationship<Dog>
		public let home: ToOneRelationship<House>

		public init(friends: ToManyRelationship<Person>, dogs: ToManyRelationship<Dog>, home: ToOneRelationship<House>) {
			self.friends = friends
			self.dogs = dogs
			self.home = home
		}
	}
}

public typealias Person = ExampleEntity<PersonDescription>

public extension Entity where Description == PersonDescription, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType == String {
	public init(id: Person.Id? = nil,name: [String], favoriteColor: String, friends: [Person], dogs: [Dog], home: House) throws {
		self = try Person(id: id ?? Person.Id(), attributes: .init(name: .init(rawValue: name), favoriteColor: .init(rawValue: favoriteColor)), relationships: .init(friends: .init(entities: friends), dogs: .init(entities: dogs), home: .init(entity: home)))
	}
}

public enum DogDescription: EntityDescription {

	public static var type: String { return "dogs" }

	public struct Attributes: JSONAPI.Attributes {
		public let name: Attribute<String>

		public init(name: Attribute<String>) {
			self.name = name
		}
	}

	public struct Relationships: JSONAPI.Relationships {
		public let owner: ToOneRelationship<Person?>

		public init(owner: ToOneRelationship<Person?>) {
			self.owner = owner
		}
	}
}

public typealias Dog = ExampleEntity<DogDescription>

public extension Entity where Description == DogDescription, MetaType == NoMetadata, LinksType == NoLinks, EntityRawIdType == String {
	public init(name: String, owner: Person?) throws {
		self = try Dog(attributes: .init(name: .init(rawValue: name)), relationships: DogDescription.Relationships(owner: .init(entity: owner)))
	}

	public init(name: String, owner: Person.Id) throws {
		self = try Dog(attributes: .init(name: .init(rawValue: name)), relationships: .init(owner: .init(id: owner)))
	}
}

public enum HouseDescription: EntityDescription {

	public static var type: String { return "houses" }

	public typealias Attributes = NoAttributes
	public typealias Relationships = NoRelationships
}

public typealias House = ExampleEntity<HouseDescription>


