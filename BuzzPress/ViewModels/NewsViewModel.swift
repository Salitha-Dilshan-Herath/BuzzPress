//
//  NewsViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import Foundation

@MainActor
class NewsViewModel: ObservableObject {
    @Published var trendingArticle: Article?
    @Published var latestArticles: [Article] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    private let repository: NewsRepository
    
    init(repository: NewsRepository = NewsRepository()) {
        self.repository = repository
    }
    
    func fetchNews(language: String, topics: String) async {
       
        isLoading = true
        defer { isLoading = false }
        
        do {
            let newsData = try await repository.getTopNews(language: language, category: topics, pageSize: 10, page: 1)
            self.trendingArticle = newsData.articles.first
            self.latestArticles = Array(newsData.articles.dropFirst())
            
        }catch {
            errorMessage = "Something went wrong! \(error.localizedDescription)"
        }
    }
}
