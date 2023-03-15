# SwiftNetzy

SwiftNetzy is an open-source library that simplifies HTTP communication in Swift. 
This library is using Swift Concurrency and URLSession to handle HTTP communication asynchronously.     

![Swift 5.7 Badge](https://img.shields.io/badge/Swift-5.7-orange.svg?style=flat&logo=swift)
![macOS 12.0](https://img.shields.io/badge/macOS-12.0-blue.svg?style=flat&logo=apple)
![Swift Package Manager Badge](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg?style=flat-square)



## Features

- Easy-to-use API for making HTTP requests
- Support HTTP methods(get, post, put, delete available. others will be supported)
- Support defining API endpoints with a simple, readable syntax
- Send URL query parameters or make HTTP requests with URL-encoded or JSON-encoded parameters 

## Installation

SwiftNetzy can be installed using [Swift Package Manager](https://www.swift.org/package-manager/).    
Add the following line to your dependencies array in Package.swift.    
In the project, select File > Swift Packages > Add Package Dependency.

```swift
dependencies: [
    .package(url: "https://github.com/yudonlee/SwiftNetzy.git", from: "1.0.0")
]
```

## Usage
### SwiftNetzy Example
To make an HTTP request using SwiftNetzy, simply call the __request__ function, passing in the URL, method, headers, parameters, and body as needed. 
For example:
```swift
struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}

func exampleAsyncFunction() async throws {
    let url = URL(string: "https://jsonplaceholder.typicode.com/posts/1")!
    let headers = ["Authorization": "Bearer <YOUR_ACCESS_TOKEN>"]
    do {
        let post: Post = try await SwiftNetzy.request(Post.self, url, method: .get, headers: headers)
        print(post)
    } catch {
        print(error)
    }
}
```

### API Endpoint Example
To make an HTTP request using SNRouter And URLTarget, SNRouter initializes a generic type that conforms to the URLTarget Protocol.

```swift
struct HttpBinResponseModel: Codable {
    let url: String
}

public enum APIEndPointEasily {
    case example(body: [String: String], parameter: [String: String])
}

extension APIEndPointEasily: URLTarget {
    public var task: URLRequestTask {
        switch self {
        case .example(let body, let parameter):
            return .bodyParametersAndURLParameters(bodyParameters: body, bodyEncoding: URLEncoding.httpBody, urlParameters: parameter)
        }
    }

    public var baseURL: String {
        switch self {
        case .example:
            return "https://httpbin.org"
        }
    }
    
    public var path: String {
        switch self {
        case .example:
            return "/post"
        }
    }
    
    public var headers: [String : String] {
        switch self {
        case .example:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .example:
            return .post
        }
    }
}
func apiEndPointEasily() async throws {
    let router = SNRouter<APIEndPointEasily>()
    let body = [
        "foo": "bar",
        "baz": "qux"
    ]
    let param = [
        "param1": "value1",
        "param2": "value2"
    ]
    
    let postResponse = try await router.request(target: .example(body: body, parameter: param), type: HttpBinResponseModel.self)
    print(postResponse.url)
    
}
```

## License

SwiftNetzy is released under the MIT license. See [LICENSE](https://github.com/yudonlee/SwiftNetzy/blob/main/License) for more information.



