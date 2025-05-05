//
//  NewsDetailViewModel.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-05.
//

import Foundation

@MainActor
class NewsDetailViewModel: ObservableObject {
    
    @Published var comments: [NewsComment] = []
    @Published var isLiked: Bool = false
    @Published var likeCount: Int = 0
    @Published var commentCount: Int = 0
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let repository: FirebaseRepositoryProtocol
    private let articleId: String

    init(articleId: String, repository: FirebaseRepositoryProtocol = FirebaseRepository()) {
        self.articleId = articleId
        self.repository = repository
    }

    func loadInitialData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let commentsResult = repository.fetchComments(articleId: articleId)
            async let isLikedResult = repository.isArticleLiked(articleId: articleId)
            async let countsResult = repository.fetchLikeAndCommentCount(articleId: articleId)

            self.comments = try await commentsResult
            self.isLiked = try await isLikedResult
            let counts = try await countsResult
            self.likeCount = counts.likes
            self.commentCount = counts.comments
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
    }

    func toggleLike() async {
        do {
            let newStatus = try await repository.toggleLike(articleId: articleId)
            isLiked = newStatus
            likeCount += newStatus ? 1 : -1
        } catch {
            errorMessage = "Error toggling like: \(error.localizedDescription)"
        }
    }

    func addComment(text: String) async {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        do {
            try await repository.addComment(articleId: articleId, text: text)
            await loadInitialData() // Or just refetch comments and update count
        } catch {
            errorMessage = "Error adding comment: \(error.localizedDescription)"
        }
    }
}
