//
//  File.swift
//  
//
//  Created by 이유돈 on 2023/02/16.
//

import Foundation

public final class SwiftNetzy {
    
    public static func request<T: Codable>(_ type: T.Type, urlRequest: URLRequest) async throws -> T {
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
    
    public static func request<T: Codable>(_ type: T.Type, _ urlEnable: URLEnable, method: HTTPMethod, headers: [String: String] = [:], params: [String: String] = [:], body: [String: String] = [:], bodyEncoding: ParameterEncoding = JSONEncoding.default) async throws -> T {
        
        var urlRequest = try URLRequest(url: urlEnable, method: method, headers: headers)
        
        if !params.isEmpty {
            urlRequest = try URLEncoding.default.encode(urlRequest: urlRequest, parameter: params)
        }
        
        if !body.isEmpty {
            urlRequest = try bodyEncoding.encode(urlRequest: urlRequest, parameter: body)
        }
        
        return try await self.request(type, urlRequest: urlRequest)
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
}



