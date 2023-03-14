//
//  File.swift
//  
//
//  Created by yudonlee on 2023/03/01.
//

import Foundation


/// The protocol for making URL Request
public protocol URLTarget {
    
    /// The base path of the URL
    var baseURL: String { get }
    
    /// The path of the URL
    var path: String { get }
    
    /// HTTP request headers
    var headers: [String: String] { get }
    
    /// Type of HTTP method(get, post, put, delete)
    var method: HTTPMethod { get }
    
    ///  The specific details of the request
    var task: URLRequestTask { get }
}


public enum URLRequestTask {
    case none
    
    case jsonBody(Codable)
    
    case urlParameters(parameters: [String: String], ParameterEncoding)
    
    case jsonAndURLParameters(body: Codable, parameter: [String: String])
    
    case bodyParametersAndURLParameters(bodyParameters: [String: String], bodyEncoding: ParameterEncoding, urlParameters: [String: String])
}
