//
//  SearchViewModel.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-04.
//

import Foundation

import Combine
import Foundation

@MainActor
class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var filteredArticles: [Article] = []

    private var searchCancellable: AnyCancellable?
    private let repository: NewsRepository
    private var currentPage = 1
    private var selectedCategory = Constants.CATEGORIES[0]

    init(repository: NewsRepository = NewsRepository()) {
        self.repository = repository
        observeSearchText()
    }

    private func observeSearchText() {
        searchCancellable = $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                Task {
                    await self?.onSearchTextChanged()
                }
            }
    }

    func onSearchTextChanged() async {
        do {
            self.filteredArticles.removeAll()
            if searchText.isEmpty {
                let news = try await repository.getTopNews(language: "en", category: selectedCategory, pageSize: 10, page: 1)
                self.filteredArticles = news.articles
            } else {
                let searchResults = try await repository.getSearchNews(language: "en", searchText: searchText, pageSize: 10, page: 1)
                self.filteredArticles = searchResults.articles
            }
        } catch {
            print("Search error:", error.localizedDescription)
        }
    }

    func resetAndFetch(language: String, topics: String) async {
        self.selectedCategory = topics
        self.searchText = ""
        self.currentPage = 1
        do {
            let news = try await repository.getTopNews(language: language, category: topics, pageSize: 10, page: 1)
            self.filteredArticles = news.articles
        } catch {
            print("Initial fetch error:", error.localizedDescription)
        }
    }

    func fetchNextPage(language: String) async {
        guard searchText.isEmpty else { return } // disable paging when searching
        currentPage += 1
        do {
            let news = try await repository.getTopNews(language: language, category: selectedCategory, pageSize: 10, page: currentPage)
            self.filteredArticles.append(contentsOf: news.articles)
        } catch {
            print("Pagination error:", error.localizedDescription)
        }
    }
}
