//
//  File.swift
//  
//
//  Created by 이유돈 on 2023/02/16.
//

import Foundation

public final class SwiftNetzy {
    
    public static func request<T: Codable>(_ type: T.Type, _ urlEnable: URLEnable, method: HTTPMethod, headers: [String: String] = [:], params: [String: String] = [:], body: [String: String] = [:]) async throws -> T {
        
        let url = try urlEnable.toURL()
        
        var urlQueries = URLComponents(url: url, resolvingAgainstBaseURL: false)
        urlQueries?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        
        
        guard let urlQueries = urlQueries else { throw SNError.invalidURL(url: url) }
        let urlRequestURL = try urlQueries.toURL()
        var urlRequest = URLRequest(url: urlRequestURL)
        urlRequest.httpMethod = method.rawValue
        
        if !body.isEmpty {
            let encodedBody = try JSONEncoder().encode(body)
            urlRequest.httpBody = encodedBody
            
        }
        
        urlRequest.allHTTPHeaderFields = headers
        
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
}
