//
//  NewsRepositories.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-02.
//

import Foundation

protocol NewsRepositoryProtocol {
    func getTopNews(language: String, category: String, pageSize: Int , page: Int) async throws -> NewsResponse
    func getSearchNews(language: String, searchText: String, pageSize: Int , page: Int) async throws -> NewsResponse

}

class NewsRepository: NewsRepositoryProtocol {
    
    
    //cache or newtwork
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    func getTopNews(language: String, category: String, pageSize: Int, page: Int) async throws -> NewsResponse {
        
        let request = NewsRequest.top(language: language, category: category, pageSize: pageSize, page: page)
        let newsResponse: NewsResponse = try await networkService.request(endpoint: request)
        return newsResponse
    }
    
    func getSearchNews(language: String, searchText: String, pageSize: Int, page: Int) async throws -> NewsResponse {
        let request = NewsRequest.everyThing(language: language, searchTxt: searchText, pageSize: pageSize, page: page)
        let newsResponse: NewsResponse = try await networkService.request(endpoint: request)
        return newsResponse
    }
    
    
}
