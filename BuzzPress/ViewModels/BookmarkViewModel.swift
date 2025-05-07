//
//  BookmarkViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/6/25.
//

import Foundation

@MainActor
class BookmarkViewModel: ObservableObject {
    @Published var bookmarkedArticles: [Article] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var searchText: String = ""

    private let repository: FirebaseRepositoryProtocol
    
    init(repository: FirebaseRepositoryProtocol = FirebaseRepository()) {
        self.repository = repository
    }
        
    func loadBookmarks() async {
        
        isLoading = true
        defer { isLoading = false }

        do {
            async let bookmarkResult = repository.fetchBookmarkedArticles()
            self.bookmarkedArticles = try await bookmarkResult
            
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
    }
}

