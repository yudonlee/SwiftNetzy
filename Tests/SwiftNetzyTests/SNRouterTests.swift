//
//  SNRouterTests.swift
//  
//
//  Created by yudonlee on 2023/03/01.
//

import XCTest
@testable import SwiftNetzy


public enum SNRouterTestCases {
    case testGetMethod
    case testPostMethod
    case testPutMethod
    case testDeleteMethod
    case testPostMethodURLEncoded
    case testPostMethodJsonEncoded
}

extension SNRouterTestCases: URLTarget {
    public var task: URLRequestTask {
        switch self {
        case .testGetMethod:
            return .none
        case .testPostMethod:
            return .none
        case .testPutMethod:
            return .none
        case .testDeleteMethod:
            return .none
        case .testPostMethodURLEncoded:
            return .none
        case .testPostMethodJsonEncoded:
            return .none
        }
    }

    public var baseURL: String {
        switch self {
        case .testPostMethodURLEncoded, .testPostMethodJsonEncoded:
            return "https://reqbin.com"
        default:
            return "https://httpbin.org"
        }
    }
    
    public var path: String {
        switch self {
        case .testGetMethod:
            return "/get"
        case .testPostMethod:
            return "/post"
        case .testPutMethod:
            return "/put"
        case .testDeleteMethod:
            return "/delete"
        case .testPostMethodURLEncoded, .testPostMethodJsonEncoded:
            return "/echo/post/json"
        }
    }
    
    public var params: [String : String] {
        switch self {
        default:
            return [:]
        }
    }
    
    public var body: [String : String] {
        switch self {
        case .testPostMethodURLEncoded, .testPostMethodJsonEncoded:
            return [
                "Id": "12345",
                "Customer": "John Smith",
                "Quantity": "1",
                "Price": "10.00"
              ]
        default:
            return [:]
        }
    }
    
    public var headers: [String : String] {
        switch self {
        case .testPostMethodURLEncoded:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .testPostMethodJsonEncoded:
            return ["Content-Type": "application/json"]
        default:
            return [:]
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .testGetMethod:
            return .get
        case .testPutMethod:
            return .put
        case .testDeleteMethod:
            return .delete
        case .testPostMethod, .testPostMethodJsonEncoded, .testPostMethodURLEncoded:
            return .post
        }
    }
}

final class SNRouterTests: XCTestCase {
    let router = SNRouter<SNRouterTestCases>()
    
    func testGetMethod() async throws {
        
        let getResponse = try await router.request(target: .testGetMethod, type: HttpBinResponseModel.self)
        XCTAssertEqual(getResponse.url, "https://httpbin.org/get")
    }
    
    func testPostMethod() async throws {
        
        let postResponse = try await router.request(target: .testPostMethod, type: HttpBinResponseModel.self)
        
        XCTAssertEqual(postResponse.url, "https://httpbin.org/post")
    }
    
    func testPutMethod() async throws {
        let putResponse = try await router.request(target: .testPutMethod, type: HttpBinResponseModel.self)
        
        XCTAssertEqual(putResponse.url, "https://httpbin.org/put")
    }
    
    func testDeleteMethod() async throws {
        let deleteResponse = try await router.request(target: .testDeleteMethod, type: HttpBinResponseModel.self)
        
        XCTAssertEqual(deleteResponse.url, "https://httpbin.org/delete")
    }
    
    func testPostMethodURLEncoded() async throws {
        let postResponse = try await router.request(target: .testPostMethodURLEncoded, type: HttpReqResponseModel.self)
        
    
        XCTAssertEqual(postResponse.success, "true")
    }
    
    func testPostMethodJsonEncoded() async throws {
        let postResponse = try await router.request(target: .testPostMethodJsonEncoded, type: HttpReqResponseModel.self)
        XCTAssertEqual(postResponse.success, "true")
    }

}
