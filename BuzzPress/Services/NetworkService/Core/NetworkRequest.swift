//
//  NetworkRequest.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-02.
//

import Foundation

protocol NetworkRequest {
    
    var scheme: NetworkScheme { get }
    var baseURL: String { get }
    var path: String { get }
    var parameteres: [URLQueryItem] { get }
    var methods: NetworkMethod { get }
    
}

extension NetworkRequest {
    
    func buildURLComponents() -> URLComponents {
        var components = URLComponents()
        components.scheme = scheme.rawValue
        components.host = baseURL
        components.path = path
        components.queryItems = parameteres
        
        print(scheme.rawValue)
        print(baseURL)
        print(path)
        print(parameteres)
        print(components.url)
        return components
    }
}
