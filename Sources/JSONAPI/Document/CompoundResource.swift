//
//  CompoundResource.swift
//  
//
//  Created by Mathew Polzin on 5/25/20.
//

public protocol CompoundResourceProtocol {
    associatedtype JSONAPIModel: JSONAPI.ResourceObjectType
    associatedtype JSONAPIIncludeType: JSONAPI.Include

    var primary: JSONAPIModel { get }
    var relatives: [JSONAPIIncludeType] { get }

    func filteringRelatives(by filter: (JSONAPIIncludeType) -> Bool) -> Self
}

/// A Resource Object and any relevant related resources. This object
/// is helpful in the context of constructing a Document.
///
/// You can resolve a primary resource and all of the intended includes
/// for that resource and pass them around as a `CompoundResource`
/// prior to constructing a Document.
///
/// Among other things, using this abstraction means you do not need to
/// specialized for a single or batch document at the same time as you are
/// resolving (i.e. materializing or decoding) one or more resources and its
/// relatives.
///
/// - Important: This type is not intended to guarantee
///     that all `relationships` of the primary resource are available
///     in the `relatives` array.
public struct CompoundResource<JSONAPIModel: JSONAPI.ResourceObjectType, JSONAPIIncludeType: JSONAPI.Include>: Equatable, CompoundResourceProtocol {
    public let primary: JSONAPIModel
    public let relatives: [JSONAPIIncludeType]

    public init(primary: JSONAPIModel, relatives: [JSONAPIIncludeType]) {
        self.primary = primary
        self.relatives = relatives
    }

    /// Create a new Compound Resource having
    /// filtered the relatives by the given closure (which
    /// must return `true` for any relative that should
    /// remain part of the `CompoundObject`).
    ///
    /// This does not remove relatives from the primary
    /// resource's `relationships`, it just filters out
    /// which relatives have complete resource objects
    /// in the newly created `CompoundResource`.
    public func filteringRelatives(by filter: (JSONAPIIncludeType) -> Bool) -> CompoundResource {
        return .init(
            primary: primary,
            relatives: relatives.filter(filter)
        )
    }
}

extension Sequence where Element: CompoundResourceProtocol {
    /// Create new Compound Resources having
    /// filtered the relatives by the given closure (which
    /// must return `true` for any relative that should
    /// remain part of the `CompoundObject`).
    ///
    /// This does not remove relatives from the primary
    /// resource's `relationships`, it just filters out
    /// which relatives have complete resource objects
    /// in the newly created `CompoundResource`.
    public func filteringRelatives(by filter: (Element.JSONAPIIncludeType) -> Bool) -> [Element] {
        return map { $0.filteringRelatives(by: filter) }
    }
}

extension EncodableJSONAPIDocument where PrimaryResourceBody: EncodableResourceBody, PrimaryResourceBody.PrimaryResource: ResourceObjectType {
    public typealias CompoundResource = JSONAPI.CompoundResource<PrimaryResourceBody.PrimaryResource, IncludeType>
}

extension SucceedableJSONAPIDocument where PrimaryResourceBody: SingleResourceBodyProtocol, PrimaryResourceBody.PrimaryResource: ResourceObjectType {

    public init(
        apiDescription: APIDescription,
        resource: CompoundResource,
        meta: MetaType,
        links: LinksType
    ) {
        self.init(
            apiDescription: apiDescription,
            body: .init(resourceObject: resource.primary),
            includes: .init(values: resource.relatives),
            meta: meta,
            links: links
        )
    }
}

extension SucceedableJSONAPIDocument where PrimaryResourceBody: ManyResourceBodyProtocol, PrimaryResourceBody.PrimaryResource: ResourceObjectType, IncludeType: Hashable {

    public init(
        apiDescription: APIDescription,
        resources: [CompoundResource],
        meta: MetaType,
        links: LinksType
    ) {
        var included = Set<Int>()
        let includes = resources.reduce(into: [IncludeType]()) { (result, next) in
            for include in next.relatives {
                if !included.contains(include.hashValue) {
                    included.insert(include.hashValue)
                    result.append(include)
                }
            }
        }
        self.init(
            apiDescription: apiDescription,
            body: .init(resourceObjects: resources.map(\.primary)),
            includes: .init(values: Array(includes)),
            meta: meta,
            links: links
        )
    }
}
