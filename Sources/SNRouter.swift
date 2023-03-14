//
//  File.swift
//  
//
//  Created by yudonlee on 2023/03/01.
//

import Foundation

public class SNRouter<Target: URLTarget> {
    
    func request<T: Codable>(target: Target, type: T.Type) async throws -> T {
        let urlRequest = try makeURLRequest(target: target)
        return try await SwiftNetzy.request(type, urlRequest: urlRequest)
    }
    
    func makeURLRequest(target: Target) throws -> URLRequest {
        let url = "\(target.baseURL)\(target.path)"
        var urlRequest = try URLRequest(url: url, method: target.method, headers: target.headers)
        
        switch target.task {
        case .none:
            return urlRequest
        case .jsonBody(let data):
            guard target.headers["Content-Type"] == "application/json" else {
                throw SNError.EncodingFailure.invalidContentType(contentType: target.headers["Content-Type"] ?? "Content Type", encoding: JSONEncoding.default)
            }
            let encodedBody = try JSONEncoder().encode(data)
            urlRequest.httpBody = encodedBody
            
        case .urlParameters(let parameter, let encoding):
            return try encoding.encode(urlRequest: urlRequest, parameter: parameter)
            
        case .jsonAndURLParameters(let data, let parameter):
            urlRequest = try URLEncoding.default.encode(urlRequest: urlRequest, parameter: parameter)
            guard target.headers["Content-Type"] == "application/json" else {
                throw SNError.EncodingFailure.invalidContentType(contentType: target.headers["Content-Type"] ?? "Content Type", encoding: JSONEncoding.default)
            }
            let encodedBody = try JSONEncoder().encode(data)
            urlRequest.httpBody = encodedBody
            
        case .bodyParametersAndURLParameters(let bodyParameters, let bodyEncoding, let urlParameters):
            let bodyEncodedRequest = try bodyEncoding.encode(urlRequest: urlRequest, parameter: bodyParameters)
            urlRequest = try URLEncoding.default.encode(urlRequest: bodyEncodedRequest, parameter: urlParameters)
            
        }
        
        return urlRequest
    }
}

