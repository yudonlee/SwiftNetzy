import XCTest
@testable import SwiftNetzy

struct HttpBinResponseModel: Codable {
    let url: String
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
}
