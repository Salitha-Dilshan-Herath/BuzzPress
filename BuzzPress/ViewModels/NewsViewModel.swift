//
//  NewsViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import Foundation

class NewsViewModel: ObservableObject {
    @Published var trendingArticle: Article?
    @Published var latestArticles: [Article] = []

    func fetchNews(language: String, topics: [String]) {
        let apiKey = "6f394d5064a64a64993786412b88d7fb" // Replace with your NewsAPI key

        for topic in topics {
            let urlStr = "https://newsapi.org/v2/top-headlines?language=\(language)&category=\(topic)&apiKey=\(apiKey)"
            guard let url = URL(string: urlStr) else { continue }

            URLSession.shared.dataTask(with: url) { data, _, error in
                guard let data = data else { return }

                if let result = try? JSONDecoder().decode(NewsResponse.self, from: data) {
                    DispatchQueue.main.async {
                        if self.trendingArticle == nil {
                            self.trendingArticle = result.articles.first
                        }
                        self.latestArticles.append(contentsOf: result.articles.dropFirst())
                    }
                }
            }.resume()
        }
    }
}
