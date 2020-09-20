## Project Status

### JSON:API
#### Document
- [x] `data`
- [x] `included`
- [x] `errors`
- [x] `meta`
- [x] `jsonapi` (i.e. API Information)
- [x] `links`

#### Resource Object
- [x] `id`
- [x] `type`
- [x] `attributes`
- [x] `relationships`
- [x] `links`
- [x] `meta`

#### Relationship Object
- [x] `data`
- [x] `links`
- [x] `meta`

##### Resource Identifier Object
- [x] `id`
- [x] `type`
- [x] `meta`

#### Links Object
- [x] `href`
- [x] `meta`

### Misc
- [x] Support transforms on `Attributes` values (e.g. to support different representations of `Date`)
- [x] Support validation on `Attributes`.
- [x] Support sparse fieldsets (encoding only). A client can likely just define a new model to represent a sparse population of another model in a very specific use case for decoding purposes. On the server side, sparse fieldsets of Resource Objects can be encoded without creating one model for every possible sparse fieldset.

### Testing
#### Resource Object Validator
- [x] Disallow optional array in `Attribute` (should be empty array, not `null`).
- [x] Only allow `TransformedAttribute` and its derivatives as stored properties within `Attributes` struct. Computed properties can still be any type because they do not get encoded or decoded.
- [x] Only allow `MetaRelationship`, `ToManyRelationship` and `ToOneRelationship` within `Relationships` struct.

### Potential Improvements
These ideas could be implemented in future versions.

- [ ] (Maybe) Use `KeyPath` to specify `Includes` thus creating type safety around the relationship between a primary resource type and the types of included resources.
- [ ] (Maybe) Replace `SingleResourceBody` and `ManyResourceBody` with support at the `Document` level to just interpret `PrimaryResource`, `PrimaryResource?`, or `[PrimaryResource]` as the same decoding/encoding strategies.
- [ ] Support sideposting. JSONAPI spec might become opinionated in the future (https://github.com/json-api/json-api/pull/1197, https://github.com/json-api/json-api/issues/1215, https://github.com/json-api/json-api/issues/1216) but there is also an existing implementation to consider (https://jsonapi-suite.github.io/jsonapi_suite/ruby/writes/nested-writes). At this time, any sidepost implementation would be an awesome tertiary library to be used alongside the primary JSONAPI library. Maybe `JSONAPISideloading`.
- [ ] Error or warning if an included resource object is not related to a primary resource object or another included resource object (Turned off or at least not throwing by default).
