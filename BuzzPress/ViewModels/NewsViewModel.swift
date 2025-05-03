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
    
    private let repository: NewsRepository
    
    init(repository: NewsRepository = NewsRepository()) {
        self.repository = repository
    }
    
    func fetchNews(language: String, topics: String) async {
       
        do {
            let newsData = try await repository.getTopNews(language: language, category: topics, pageSize: 1, page: 10)
            self.trendingArticle = newsData.articles.first
            self.latestArticles.append(contentsOf: newsData.articles.dropFirst())
            
        }catch {
            print("fetchNews news")
            print(error.localizedDescription)
            //errorMessage = "Something went wrong! \(error.localizedDescription)"
        }
    }
}
