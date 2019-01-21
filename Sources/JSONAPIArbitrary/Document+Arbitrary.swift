//
//  Document+Arbitrary.swift
//  JSONAPIArbitrary
//
//  Created by Mathew Polzin on 1/21/19.
//

import SwiftCheck
import JSONAPI

extension Document.Body.Data: Arbitrary where PrimaryResourceBody: Arbitrary, IncludeType: Arbitrary, MetaType: Arbitrary, LinksType: Arbitrary {
	public static var arbitrary: Gen<Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>.Body.Data> {
		return Gen.compose { c in
			Document.Body.Data(primary: c.generate(),
							   includes: c.generate(),
							   meta: c.generate(),
							   links: c.generate())
		}
	}
}

extension Document.Body: Arbitrary where PrimaryResourceBody: Arbitrary, IncludeType: Arbitrary, MetaType: Arbitrary, LinksType: Arbitrary, Error: Arbitrary {
	public static var arbitrary: Gen<Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>.Body> {
		return Gen.one(of: [
			arbitraryData,
			arbitraryErrors
		])
	}
}

extension Document.Body where PrimaryResourceBody: Arbitrary, IncludeType: Arbitrary, MetaType: Arbitrary, LinksType: Arbitrary {
	/// Arbitrary Document.Body with data (guaranteed to not
	/// be an error body).
	public static var arbitraryData: Gen<Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>.Body> {
		return Document.Body.Data.arbitrary.map(Document.Body.data)
	}
}

extension Document.Body where MetaType: Arbitrary, LinksType: Arbitrary, Error: Arbitrary {
	/// Arbitrary Document.Body with errors (guaranteed to not
	/// be a data body).
	public static var arbitraryErrors: Gen<Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>.Body> {
		return Gen.compose { c in
			Document.Body.errors(c.generate(),
								 meta: c.generate(),
								 links: c.generate())
		}
	}
}

extension Document.Body where Error: Arbitrary {
	/// Arbitrary Document.Body with errors but no
	/// metadata or links (also guaranteed to not
	/// be a data body).
	public static var arbitraryErrorsWithoutMetaOrLinks: Gen<Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>.Body> {
		return Gen.compose { c in
			Document.Body.errors(c.generate(),
								 meta: nil,
								 links: nil)
		}
	}
}

extension Document: Arbitrary where PrimaryResourceBody: Arbitrary, IncludeType: Arbitrary, MetaType: Arbitrary, LinksType: Arbitrary, Error: Arbitrary, APIDescription: Arbitrary {
	public static var arbitrary: Gen<Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>> {
		return Gen.one(of: [
			arbitraryData,
			arbitraryErrors
		])
	}
}

extension Document where PrimaryResourceBody: Arbitrary, IncludeType: Arbitrary, MetaType: Arbitrary, LinksType: Arbitrary, APIDescription: Arbitrary {
	/// Arbitrary Document with data (guaranteed to not
	/// be an error body).
	public static var arbitraryData: Gen<Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>> {
		return Gen.compose { c in
			Document(apiDescription: c.generate(),
					 body: c.generate(),
					 includes: c.generate(),
					 meta: c.generate(),
					 links: c.generate())
		}
	}
}

extension Document where MetaType: Arbitrary, LinksType: Arbitrary, Error: Arbitrary, APIDescription: Arbitrary {
	/// Arbitrary Document with errors (guaranteed to not
	/// be a data body).
	public static var arbitraryErrors: Gen<Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>> {
		return Gen.compose { c in
			Document(apiDescription: c.generate(),
					 errors: c.generate(),
					 meta: c.generate(),
					 links: c.generate())
		}
	}
}

extension Document where Error: Arbitrary, APIDescription: Arbitrary {
	/// Arbitrary Document with errors but no
	/// metadata or links (also guaranteed to not
	/// be a data body).
	public static var arbitraryErrors: Gen<Document<PrimaryResourceBody, MetaType, LinksType, IncludeType, APIDescription, Error>> {
		return Gen.compose { c in
			Document(apiDescription: c.generate(),
					 errors: c.generate())
		}
	}
}
