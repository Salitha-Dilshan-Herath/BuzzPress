//
//  NewsRequest.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-02.
//

import Foundation

enum NewsRequest {
    
    case topNews(language: String, category: String, pageSize: Int , page: Int)
}

extension NewsRequest : NetworkRequest {
    var scheme: NetworkScheme {
        
        switch self {
        case .topNews(_, _, _, _):
            return .https
        }
        
    }
    
    var baseURL: String {
        return APIConstants.baseURLString
    }
    
    var path: String {
        
        switch self {
        case .topNews(_, _, _, _):
            return "/v2/top-headlines"
        }
    }
    
    var parameteres: [URLQueryItem] {
        switch self {
        case .topNews(let language, let category, let page, let pageSize):
            let params = [
                URLQueryItem(name: "apiKey", value: APIConstants.apiKey),
                URLQueryItem(name: "language", value: language),
                URLQueryItem(name: "category", value: category),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "pageSize", value: String(pageSize))
            ]
            return params
        }
    }
    
    var methods: NetworkMethod {
        
        switch self {
        case .topNews(_, _, _, _):
            return .get
        }
    }
    
    
}
