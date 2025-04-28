
# JSONAPI Custom Errors Example

We are about to walk through an example of parsing a JSON:API errors response.
Information on creating models that take advantage of more of the features from
the JSON:API Specification can be found in the [README](https://github.com/mattpolzin/JSONAPI/blob/main/README.md).

First we will define a structure that can parse each of the errors we might
expect to get back from the server. This is the one type for which the framework
does not offer a generic option but we can pretty easily pick the relevant
properties from the **Error Object** description given by JSON:API
[here](https://www.google.com/url?q=https%3A%2F%2Fjsonapi.org%2Fformat%2F%23error-objects).
We will choose only to distinguish between server and client errors for this
example but that is the tip of the iceberg if you wish to make more robust error
handling for yourself.

```swift
enum OurExampleError: JSONAPIError {
  case unknownError
  case server(code: Int, description: String)
  case client(code: Int, description: String)
  
  static var unknown: OurExampleError { return .unknownError }
  
  // Example decoder just switches on the status code
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    
    let code = try Int(container.decode(String.self, forKey: .status))
    
    guard let statusCode = code else {
      throw DecodingError.typeMismatch(Int.self,
                                       .init(codingPath: decoder.codingPath, 
                                             debugDescription: "Expected an integer HTTP status code."))
    }
    
    switch statusCode {
    case 400..<500:
      self = try .client(code: statusCode, description: container.decode(String.self, forKey: .detail))
    case 500..<600:
      self = try .server(code: statusCode, description: container.decode(String.self, forKey: .detail))
    default:
      self = .unknown
    }
  }
  
  // naturally, opposite of decoding except for needing to put something down
  // for the unknown case. We choose 500 here; client won't need to encode errors
  // and 500 is fitting for this situation on the server side.
  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    
    let status: String
    let detail: String
    switch self {
    case .server(let code, let description),
         .client(let code, let description):
      status = String(code)
      detail = description
    default:
      status = "500"
      detail = "Unknown problem occurred"
    }
    
    try container.encode(status, forKey: .status)
    try container.encode(detail, forKey: .detail)
  }
  
  private enum CodingKeys: String, CodingKey {
    case status
    case detail
  }
}
```

Next we will define some utility `typealiases` like we did in the 
[Basic Example](https://github.com/mattpolzin/JSONAPI/blob/main/documentation/basic-example.md).
This time, we will specify that our `Document` type expects to parse
`OurExampleError`.

```swift
typealias Resource<Description: JSONAPI.ResourceObjectDescription> = JSONAPI.ResourceObject<Description, NoMetadata, NoLinks, String>

typealias SingleDocument<Resource: ResourceObjectType> = JSONAPI.Document<SingleResourceBody<Resource>, NoMetadata, NoLinks, NoIncludes, NoAPIDescription, OurExampleError>
```

We will reuse the `Dog` type from the **Basic Example**. We won't actually be
parsing this type because we are showing off error parsing.

```swift
struct DogDescription: ResourceObjectDescription {
  static let jsonType: String = "dogs"
  
  struct Attributes: JSONAPI.Attributes {
    let name: Attribute<String>
  }
  
  typealias Relationships = NoRelationships
}

typealias Dog = Resource<DogDescription>
```

Now let's mock up an error response.

```swift
// snag Foundation for Data and JSONDecoder
import Foundation

let mockErrorResponse = 
"""
{
  "errors": [
    {
      "status": "400",
      "detail": "You made a bad request"
    },
    {
      "status": "500",
      "detail": "The server fell over because it tried to handle your bad request"
    }
  ]
}
""".data(using: .utf8)!
```

Now we can parse the response data and switch on the response body to see if we
are dealing with an error or successful request (although we know in this case
it will be an error, of course).

```swift
let decoder = JSONDecoder()

let dogDocument = try! decoder.decode(SingleDocument<Dog>.self, from: mockErrorResponse)

switch dogDocument.body {
case .data(let response):
  print("this would be unexpected given our mock data!")

case .errors(let errors, meta: _, links: _):
  print("The server returned the following errors:")
  print(errors.map { error -> String in 
    switch error {
    case .client(let code, let description),
         .server(let code, let description):
      return "\(code): \(description)"
    default:
      return "unknown"
    }
  })
}
```

