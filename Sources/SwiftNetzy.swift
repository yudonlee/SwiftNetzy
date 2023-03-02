//
//  File.swift
//  
//
//  Created by 이유돈 on 2023/02/16.
//

import Foundation

public final class SwiftNetzy {
    
    public static func request<T: Codable>(_ type: T.Type, _ urlEnable: URLEnable, method: HTTPMethod, headers: [String: String] = [:], params: [String: String] = [:], body: [String: String] = [:], encoding: Encoding = .parameterUrlEncoded) async throws -> T {
        
        let url = try urlEnable.toURL()
        
        var urlQueries = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlQueries?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        guard let urlQueries = urlQueries else { throw SNError.invalidURL(url: url) }
        let urlRequestURL = try urlQueries.toURL()
        
        let urlRequest = try self.makeURLRequest(url: urlRequestURL, method: method, headers: headers, body: body, encoding: encoding)
        
        let (data, response) = try await {
            if #available(iOS 15, *) {
                return try await URLSession.shared.data(for: urlRequest)
            } else {
                return try await self.requestURLSessionDataEscaping(for: urlRequest)
            }
        }()
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200..<300 ~= httpResponse.statusCode) {
            throw SNError.invalidHttpResponse(statusCode: httpResponse.statusCode)
        }
        
        let result = try JSONDecoder().decode(T.self, from: data)
        return result
    }
    
    static func requestURLSessionDataEscaping(for urlRequest: URLRequest) async throws -> (Data, URLResponse) {
        try await withCheckedThrowingContinuation({ continuation in
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let error = error {
                    continuation.resume(throwing: error)
                }
                if let data = data, let response = response {
                    continuation.resume(returning: (data, response))
                }
            }.resume()
        })
    }
    
    static func makeURLRequest(url: URL, method: HTTPMethod, headers: [String: String], body: [String: String],  encoding: Encoding) throws -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = headers
        
        let httpMethods: [HTTPMethod] = [.put, .post]
        
        if !httpMethods.contains(method) || body.isEmpty {
            return urlRequest
        }
        
        switch encoding {
        case .bodyJsonEncoded:
            if headers["Content-Type"] == "application/json" {
                let encodedBody = try JSONEncoder().encode(body)
                urlRequest.httpBody = encodedBody
            } else {
                throw SNError.EncodingFailure.contentTypeInvalid(contentType: headers["Content-Type"] ?? "Content Type", encoding: encoding)
            }
        case .bodyURLEncoded:
            if headers["Content-Type"] == "application/x-www-form-urlencoded" || headers["Content-Type"] == "application/x-www-form-urlencoded; charset=utf-8" {
                var requestBodyComponents = URLComponents()
                requestBodyComponents.queryItems = body.map { URLQueryItem(name: $0, value: $1) }
                urlRequest.httpBody = requestBodyComponents.query?.data(using: .utf8)
            } else {
                throw SNError.EncodingFailure.contentTypeInvalid(contentType: headers["Content-Type"] ?? "Content Type", encoding: encoding)
            }
        default:
            break
        }
        
        return urlRequest
    }
}



