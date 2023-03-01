import XCTest
@testable import SwiftNetzy

struct HttpBinResponseModel: Codable {
    let url: String
}

struct HttpReqResponseModel: Codable {
    let success: String
}

final class SwiftNetzyTests: XCTestCase {

    func testGetMethod() async throws {
        
        let getResponse = try await SwiftNetzy.request(HttpBinResponseModel.self, "https://httpbin.org/get", method: .get)
        
        XCTAssertEqual(getResponse.url, "https://httpbin.org/get")
    }
    
    func testPostMethod() async throws {
        
        let postResponse = try await SwiftNetzy.request(HttpBinResponseModel.self, "https://httpbin.org/post", method: .post)
        
        XCTAssertEqual(postResponse.url, "https://httpbin.org/post")
    }
    
    func testPutMethod() async throws {
        let putResponse = try await SwiftNetzy.request(HttpBinResponseModel.self, "https://httpbin.org/put", method: .put)
        
        XCTAssertEqual(putResponse.url, "https://httpbin.org/put")
    }
    
    func testDeleteMethod() async throws {
        let deleteResponse = try await SwiftNetzy.request(HttpBinResponseModel.self, "https://httpbin.org/delete", method: .delete)
        
        XCTAssertEqual(deleteResponse.url, "https://httpbin.org/delete")
    }
    
    func testPostMethodURLEncoded() async throws {
        let headers = ["Content-Type": "application/x-www-form-urlencoded"]
        let bodyInfo: [String: String] = [
            "Id": "12345",
            "Customer": "John Smith",
            "Quantity": "1",
            "Price": "10.00"
          ]
        let postResponse = try await SwiftNetzy.request(HttpReqResponseModel.self, "https://reqbin.com/echo/post/json", method: .post, headers: headers, body: bodyInfo, encoding: .bodyURLEncoded)
        XCTAssertEqual(postResponse.success, "true")
    }
    
    func testPostMethodJsonEncoded() async throws {
        let headers = ["Content-Type": "application/json"]
        let bodyInfo: [String: String] = [
            "Id": "12345",
            "Customer": "John Smith",
            "Quantity": "1",
            "Price": "10.00"
          ]
        let postResponse = try await SwiftNetzy.request(HttpReqResponseModel.self, "https://reqbin.com/echo/post/json", method: .post, headers: headers, body: bodyInfo, encoding: .bodyJsonEncoded)
        XCTAssertEqual(postResponse.success, "true")
    }
    
}
