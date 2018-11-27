//
//  Entity+Id.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/15/18.
//

import JSONAPI

public typealias Entity<Description: JSONAPI.EntityDescription> = JSONAPI.Entity<Description, Id<String, Description>>

public typealias NewEntity<Description: JSONAPI.EntityDescription> = JSONAPI.Entity<Description, Unidentified<Description>>
