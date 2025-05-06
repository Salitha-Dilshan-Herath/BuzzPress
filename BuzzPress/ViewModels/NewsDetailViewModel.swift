//
//  NewsDetailViewModel.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-05.
//

import Foundation

@MainActor
class NewsDetailViewModel: ObservableObject {
    
    @Published var isLiked: Bool = false
    @Published var isBookmaked: Bool = false

    @Published var likeCount: Int = 0
    @Published var commentCount: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: FirebaseRepositoryProtocol
    private let article: Article

    init(article: Article, repository: FirebaseRepositoryProtocol = FirebaseRepository()) {
        self.article = article
        self.repository = repository
    }

    func loadInitialData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let isLikedResult = repository.isArticleLiked(articleId: article.id)
            async let countsResult = repository.fetchLikeAndCommentCount(articleId: article.id)
            async let isArticleBookmarked = repository.isArticleBookmarked(articleId: article.id)

            self.isLiked = try await isLikedResult
            self.isBookmaked = try await isArticleBookmarked

            let counts = try await countsResult
            self.likeCount = counts.likes
            self.commentCount = counts.comments
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
    }

    func toggleLike() async {
        do {
            let newStatus = try await repository.toggleLike(articleId: article.id)
            isLiked = newStatus
            likeCount += newStatus ? 1 : -1
        } catch {
            errorMessage = "Error toggling like: \(error.localizedDescription)"
        }
    }
    
    func toggleBookMark() async {
        do {
            if isBookmaked {
                try await repository.removeBookmark(articleId: article.id)
            }else{
                try await repository.bookmarkArticle(article: article)
            }
            isBookmaked.toggle()
        } catch {
            errorMessage = "Error toggling bookmark: \(error.localizedDescription)"
        }
    }
}
