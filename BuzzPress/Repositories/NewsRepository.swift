//
//  NewsRepositories.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-02.
//

import Foundation

protocol NewsRepositoryProtocol {
    func getTopNews(language: String, category: String, pageSize: Int, page: Int) async throws -> NewsResponse
    func getSearchNews(language: String, searchText: String, pageSize: Int, page: Int) async throws -> NewsResponse
    func invalidateCache(for language: String, category: String)
}

class NewsRepository: NewsRepositoryProtocol {
    
    private let networkService: NetworkServiceProtocol
    private let cacheService: CoreDataServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService(),
         cacheService: CoreDataServiceProtocol = CoreDataService.shared) {
        self.networkService = networkService
        self.cacheService = cacheService
    }
    
    // MARK: - Public Methods
    
    func getTopNews(language: String, category: String, pageSize: Int, page: Int) async throws -> NewsResponse {
        let cacheKey = generateCacheKey(language: language, category: category, pageSize: pageSize, page: page)
        
        // Try to load from cache first
        if let cachedResponse = try await loadFromCache(cacheKey: cacheKey) {
            print("dev test: ******* get from Cache ******* \(cacheKey)")
            return cachedResponse
        }
        
        // Fall back to network request
        let request = NewsRequest.top(language: language, category: category, pageSize: pageSize, page: page)
        let newsResponse: NewsResponse = try await networkService.request(endpoint: request)
        
        print("dev test: ******* get from API ******* \(cacheKey)")
        // Save to cache
        await cacheService.cacheNews(
            query: cacheKey,
            page: page,
            pageSize: pageSize,
            data: newsResponse
        )
        
        return newsResponse
    }
    
    func getSearchNews(language: String, searchText: String, pageSize: Int, page: Int) async throws -> NewsResponse {
        // Typically we don't cache search results as they're highly variable
        let request = NewsRequest.everyThing(language: language, searchTxt: searchText, pageSize: pageSize, page: page)
        return try await networkService.request(endpoint: request)
    }
    
    func invalidateCache(for language: String, category: String) {
        let prefix = generateCacheKeyPrefix(language: language, category: category)
        Task {
            await cacheService.invalidateCache(withPrefix: prefix)
        }
    }
    
    // MARK: - Private Helpers
    
    private func generateCacheKey(language: String, category: String, pageSize: Int, page: Int) -> String {
        return "\(language)_\(category)_\(pageSize)_\(page)".sha256()
    }
    
    private func generateCacheKeyPrefix(language: String, category: String) -> String {
        return "\(language)_\(category)_".sha256()
    }
    
    private func loadFromCache(cacheKey: String) async throws -> NewsResponse? {
        guard let cachedNews = await cacheService.fetchNews(query: cacheKey),
              let expireTime = cachedNews.expireTime,
              expireTime > Date() else {
            return nil
        }
    
        guard let response = cachedNews.toNewsResponse() else {
            throw NetworkServiceError.decodingFailed
        }
        
        return response
    }
}
