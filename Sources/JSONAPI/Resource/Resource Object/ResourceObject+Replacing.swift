//
//  ResourceObject+Replacing.swift
//  JSONAPI
//
//  Created by Mathew Polzin on 10/12/19.
//

public extension JSONAPI.ResourceObject {
    /// Return a new `ResourceObject`, having replaced `self`'s
    /// `attributes` with the attributes returned by the given
    /// replacement function.
    ///
    /// - important: `self` is not mutated. A copy of self is returned.
    ///
    /// - parameters:
    ///     - replacement: A function that takes the existing `attributes` and returns the replacement.
    func replacingAttributes(_ replacement: (Description.Attributes) -> Description.Attributes) -> Self {
        return Self(id: id,
                    attributes: replacement(attributes),
                    relationships: relationships,
                    meta: meta,
                    links: links)
    }

    /// Return a new `ResourceObject`, having updated `self`'s
    /// `attributes` with the tap function given.
    ///
    /// - important: `self` is not mutated. A copy of self is returned.
    ///
    /// - parameters:
    ///     - tap: A function that takes a copy of the existing `attributes` and mutates them.
    func tappingAttributes(_ tap: (inout Description.Attributes) -> Void) -> Self {
        var newAttributes = attributes
        tap(&newAttributes)
        return Self(id: id,
                    attributes: newAttributes,
                    relationships: relationships,
                    meta: meta,
                    links: links)
    }

    /// Return a new `ResourceObject`, having replaced `self`'s
    /// `relationships` with the `relationships` returned by the given
    /// replacement function.
    ///
    /// - important: `self` is not mutated. A copy of self is returned.
    ///
    /// - parameters:
    ///     - replacement: A function that takes the existing relationships and returns the replacement.
    func replacingRelationships(_ replacement: (Description.Relationships) -> Description.Relationships) -> Self {
        return Self(id: id,
                    attributes: attributes,
                    relationships: replacement(relationships),
                    meta: meta,
                    links: links)
    }

    /// Return a new `ResourceObject`, having updated `self`'s
    /// `relationships` with the tap function given.
    ///
    /// - important: `self` is not mutated. A copy of self is returned.
    ///
    /// - parameters:
    ///     - tap: A function that takes a copy of the existing `relationships` and mutates them.
    func tappingRelationships(_ tap: (inout Description.Relationships) -> Void) -> Self {
        var newRelationships = relationships
        tap(&newRelationships)
        return Self(id: id,
                    attributes: attributes,
                    relationships: newRelationships,
                    meta: meta,
                    links: links)
    }
}
