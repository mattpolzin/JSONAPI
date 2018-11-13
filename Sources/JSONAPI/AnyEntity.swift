//
//  AnyEntity.swift
//  ElevatedCore
//
//  Created by Mathew Polzin on 11/5/18.
//

import Foundation

//private class AnyRelationshipBase<Entity: ElevatedCore.Entity>: Relationship {
//
//	init() {
//		guard type(of: self) != AnyRelationshipBase.self else {
//			fatalError("Must use subclasses")
//		}
//	}
//
//	var ids: [Id<Entity>] {
//		fatalError("Implemented by subclasses")
//	}
//
//	static func == (lhs: AnyRelationshipBase<Entity>, rhs: AnyRelationshipBase<Entity>) -> Bool {
//		fatalError("Implemented by subclasses")
//	}
//}
//
//private final class AnyRelationshipBox<Concrete: Relationship>: AnyRelationshipBase<Concrete.Entity> {
//	let concrete: Concrete
//
//	init(_ concrete: Concrete) {
//		self.concrete = concrete
//		super.init()
//	}
//
//	override func encode(to encoder: Encoder) throws {
//		try concrete.encode(to: encoder)
//	}
//
//	override var ids: [Id<Concrete.Entity>] {
//		return concrete.ids
//	}
//
//	static func == (lhs: AnyRelationshipBox<Concrete>, rhs: AnyRelationshipBox<Concrete>) -> Bool {
//		return lhs.concrete == rhs.concrete
//	}
//}
//
//public final class AnyRelationship<Entity: ElevatedCore.Entity>: Relationship {
//	private let box: AnyRelationshipBase<Entity>
//
//	public init<Concrete: Relationship>(_ concrete: Concrete) where Concrete.Entity == Entity {
//		box = AnyRelationshipBox(concrete)
//	}
//
//	public func encode(to encoder: Encoder) throws {
//		try box.encode(to: encoder)
//	}
//
//	public var ids: [Id<Entity>] {
//		return box.ids
//	}
//
//	public static func == (lhs: AnyRelationship<Entity>, rhs: AnyRelationship<Entity>) -> Bool {
//		return lhs.box == rhs.box
//	}
//}
//
//private class AnyEntityBase<Attributes: Equatable & Encodable, Relationships: Equatable & Encodable, ID: IdType>: Entity {
//
//	init() {
//		guard Swift.type(of: self) != AnyEntityBase.self else {
//			fatalError("Must use subclasses")
//		}
//	}
//
//	class var type: String { fatalError("Implemented by subclasses") }
//	var id: Id<AnyEntity> { fatalError("Implemented by subclasses") }
//
//	var attributes: Attributes { fatalError("Implemented by subclasses") }
//	var relationships: Relationships { fatalError("Implemented by subclasses") }
//
//	static func == (lhs: AnyEntityBase<Attributes, Relationships, ID>, rhs: AnyEntityBase<Attributes, Relationships, ID>) -> Bool {
//		fatalError("Implemented by subclasses")
//	}
//}
//
//private final class AnyEntityBox<Concrete: Entity>: AnyEntityBase<Concrete.Attributes, Concrete.Relationships, Concrete.ID> {
//
//	let concrete: Concrete
//
//	init(_ concrete: Concrete) {
//		self.concrete = concrete
//		super.init()
//	}
//
//	override class var type: String {
//		return Concrete.type
//	}
//
//	override var id: Id<AnyEntity> {
//		return concrete.id
//	}
//
//	override var attributes: Concrete.Attributes {
//		return concrete.attributes
//	}
//
//	override var relationships: Concrete.Relationships {
//		return concrete.relationships
//	}
//
//	static func == (lhs: AnyEntityBox<Concrete>, rhs: AnyEntityBox<Concrete>) -> Bool {
//		return lhs.concrete == rhs.concrete
//	}
//}
//
//public final class AnyEntity<Attributes: Equatable & Encodable, Relationships: Equatable & Encodable, ID: IdType>: Entity {
//	private let box: AnyEntityBase<Attributes, Relationships, ID>
//
//	init<Concrete: Entity>(_ concrete: Concrete) where Concrete.Attributes == Attributes, Concrete.Relationships == Relationships, Concrete.ID == ID {
//		box = AnyEntityBox(concrete)
//	}
//
//	public class var type: String { return Swift.type(of: box).type }
//}

