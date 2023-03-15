//
//  File.swift
//  
//
//  Created by yudonlee on 2023/03/14.
//

import Foundation

public protocol ParameterEncoding {
    func encode(urlRequest: URLRequest, parameter: [String: String]) throws -> URLRequest
}

public class JSONEncoding: ParameterEncoding {
    
    public static var `default` = JSONEncoding()
    
    public func encode(urlRequest: URLRequest, parameter: [String: String]) throws -> URLRequest {
        guard let headers = urlRequest.allHTTPHeaderFields,
              headers["Content-Type"] == "application/json" else {
            throw SNError.EncodingFailure.invalidContentType(contentType: urlRequest.allHTTPHeaderFields?["Content-Type"] ?? "Content Type", encoding: self)
        }
        
        do {
            let body = try JSONEncoder().encode(parameter)
            var urlRequest = urlRequest
            urlRequest.httpBody = body
            return urlRequest
        } catch {
            throw SNError.EncodingFailure.jsonEncodingFailed(parameters: parameter)
        }
    }
}

public class URLEncoding: ParameterEncoding {
    
    public enum Destination {
        case queryString
        case httpBody
    }
    
    private init(destination: Destination) {
        self.destination = destination
    }
    
    public static var `default` = URLEncoding(destination: .queryString)
    public static var httpBody = URLEncoding(destination: .httpBody)
    public let destination: Destination
    
    
    public func encode(urlRequest: URLRequest, parameter: [String: String]) throws -> URLRequest {
        var urlRequest = urlRequest
        switch destination {
        case .queryString:
            guard let url = urlRequest.url else { throw SNError.URLRequestFailure.isURLEmpty(urlRequest: urlRequest) }
            
            var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
            urlComponents?.queryItems = parameter.map { URLQueryItem(name: $0, value: $1)}
            guard let url = urlComponents?.url else { throw SNError.invalidURL(url: url) }
            urlRequest.url = url
            
        case .httpBody:
            guard urlRequest.allHTTPHeaderFields?["Content-Type"] == "application/x-www-form-urlencoded" || urlRequest.allHTTPHeaderFields?["Content-Type"] == "application/x-www-form-urlencoded; charset=utf-8"  else {
                throw SNError.EncodingFailure.invalidContentType(contentType: urlRequest.allHTTPHeaderFields?["Content-Type"] ?? "Content Type", encoding: self)
            }
            
            var requestBodyComponents = URLComponents()
            requestBodyComponents.queryItems = parameter.map { URLQueryItem(name: $0, value: $1) }
            
            guard let data = requestBodyComponents.query?.data(using: .utf8) else {
                throw SNError.EncodingFailure.urlEncodingFailed(parameters: parameter)
            }
            urlRequest.httpBody = data
        }
        
        return urlRequest
    }
    

}


