//
//  EntityTestTypes.swift
//  JSONAPITests
//
//  Created by Mathew Polzin on 11/15/18.
//

import JSONAPI

public typealias Entity<Description: JSONAPI.EntityDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.Entity<Description, Meta, Links, String>

public typealias BasicEntity<Description: JSONAPI.EntityDescription> = Entity<Description, NoMetadata, NoLinks>

public typealias NewEntity<Description: JSONAPI.EntityDescription, Meta: JSONAPI.Meta, Links: JSONAPI.Links> = JSONAPI.Entity<Description, Meta, Links, Unidentified>
