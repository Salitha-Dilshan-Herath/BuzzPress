//
//  CommentViewModel.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-05.
//
import Foundation


@MainActor
class CommentViewModel: ObservableObject {
    
    @Published var comments: [NewsComment] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false

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
            self.comments = try await commentsResult
            
        } catch {
            errorMessage = "Failed to load data: \(error.localizedDescription)"
        }
    }
    
    func addComment(text: String) async {
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        do {
            try await repository.addComment(articleId: articleId, text: text)
            await loadInitialData()
        } catch {
            errorMessage = "Error adding comment: \(error.localizedDescription)"
        }
    }
}

