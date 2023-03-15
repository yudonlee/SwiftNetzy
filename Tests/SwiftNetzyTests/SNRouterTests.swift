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
    case testPostMethodURLEncoded(body: [String: String])
    case testPostMethodJsonEncoded(body: [String: String])
    case testPostmethodParameterAndBodyURLEncoded(body: [String: String], parameter: [String: String])
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
        case .testPostMethodURLEncoded(let body):
            return .urlParameters(parameters: body, URLEncoding.httpBody)
        case .testPostMethodJsonEncoded(let body):
            return .jsonBody(body)
        case .testPostmethodParameterAndBodyURLEncoded(let body, let parameter):
            return .bodyParametersAndURLParameters(bodyParameters: body, bodyEncoding: URLEncoding.httpBody, urlParameters: parameter)
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
        case .testPostmethodParameterAndBodyURLEncoded:
            return "/post"
        }
    }
    
    public var headers: [String : String] {
        switch self {
        case .testPostMethodURLEncoded, .testPostmethodParameterAndBodyURLEncoded:
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
        case .testPostMethod, .testPostMethodJsonEncoded, .testPostMethodURLEncoded, .testPostmethodParameterAndBodyURLEncoded:
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
        let body = [
            "Id": "12345",
            "Customer": "John Smith",
            "Quantity": "1",
            "Price": "10.00"
        ]
        let postResponse = try await router.request(target: .testPostMethodURLEncoded(body: body), type: HttpReqResponseModel.self)
        
    
        XCTAssertEqual(postResponse.success, "true")
    }
    
    func testPostMethodJsonEncoded() async throws {
        let body = [
            "Id": "12345",
            "Customer": "John Smith",
            "Quantity": "1",
            "Price": "10.00"
        ]
        
        let postResponse = try await router.request(target: .testPostMethodJsonEncoded(body: body), type: HttpReqResponseModel.self)
        XCTAssertEqual(postResponse.success, "true")
    }

    func testPostmethodParameterAndBodyURLEncoded() async throws {
        let body = [
            "foo": "bar",
            "baz": "qux"
        ]
        let param = [
            "param1": "value1",
            "param2": "value2"
        ]
        let postResponse = try await router.request(target: .testPostmethodParameterAndBodyURLEncoded(body: body, parameter: param), type: HttpBinResponseModel.self)
        print(postResponse.url)
        XCTAssertEqual(postResponse.url, "https://httpbin.org/post?param1=value1&param2=value2")
    }
}

