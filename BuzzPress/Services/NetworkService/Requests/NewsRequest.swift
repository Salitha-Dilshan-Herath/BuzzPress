//
//  NewsRequest.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-02.
//

import Foundation

enum NewsRequest {
    
    case top(language: String, category: String, pageSize: Int , page: Int)
    case everyThing(language: String, searchTxt: String, pageSize: Int , page: Int)
}

extension NewsRequest : NetworkRequest {
    var scheme: NetworkScheme {
        
        switch self {
        case .top(_, _, _, _):
            return .https
        case .everyThing(_, _, _, _):
            return .https
        }
        
    }
    
    var baseURL: String {
        return APIConstants.baseURLString
    }
    
    var path: String {
        
        switch self {
        case .top(_, _, _, _):
            return "/v2/top-headlines"
        case .everyThing(_, _, _, _):
            return "/v2/everything"
        }
    }
    
    var parameteres: [URLQueryItem] {
        switch self {
        case .top(let language, let category, let pageSize, let page):
            let params = [
                URLQueryItem(name: "apiKey", value: APIConstants.apiKey),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "category", value: category),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "pageSize", value: String(pageSize))
            ]
            return params
        case .everyThing(language: let language, searchTxt: let searchTxt, pageSize: let pageSize, page: let page):
            let params = [
                URLQueryItem(name: "apiKey", value: APIConstants.apiKey),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "q", value: searchTxt),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "pageSize", value: String(pageSize))
            ]
            return params
        }
    }
    
    var methods: NetworkMethod {
        
        switch self {
        case .top(_, _, _, _):
            return .get
        case .everyThing(_, _, _, _):
            return .get
        }
    }
    
    
}
