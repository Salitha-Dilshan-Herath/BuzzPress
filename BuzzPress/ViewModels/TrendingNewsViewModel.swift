//
//  TrendingNewsViewModel.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-04.
//

import Foundation

@MainActor
class TrendingNewsViewModel: ObservableObject {
    @Published var latestArticles: [Article] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var isFirstLoad = true

    private var currentPage = 1
    private var hasMore = true
    private let repository: NewsRepository

    init(repository: NewsRepository = NewsRepository()) {
        self.repository = repository
    }

    func fetchNews(language: String, topics: String) async {
        guard !isLoading, hasMore else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let newsData = try await repository.getTopNews(
                language: language,
                category: topics,
                pageSize: 10,
                page: currentPage
            )

            if newsData.articles.isEmpty {
                hasMore = false
            } else {
                print("addd")
                latestArticles.append(contentsOf: newsData.articles)
                currentPage += 1
            }
        } catch {
            errorMessage = "Failed to fetch news: \(error.localizedDescription)"
        }
    }

    func shouldLoadMore(currentIndex: Int) -> Bool {
        return currentIndex == latestArticles.count - 1 && !isLoading && hasMore
    }
}
