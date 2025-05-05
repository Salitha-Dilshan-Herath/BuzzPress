//
//  FirebaseRepository.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-05.
//

protocol FirebaseRepositoryProtocol {
    func addComment(articleId: String, text: String) async throws
    func fetchComments(articleId: String) async throws -> [NewsComment]
    func toggleLike(articleId: String) async throws -> Bool
    func isArticleLiked(articleId: String) async throws -> Bool
    func fetchLikeAndCommentCount(articleId: String) async throws -> (likes: Int, comments: Int)
}

class FirebaseRepository: FirebaseRepositoryProtocol {
    
    private let firestoreService: FirestoreServiceProtocol

    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreService = firestoreService
    }

    func addComment(articleId: String, text: String) async throws {
        try await firestoreService.addComment(articleId: articleId, text: text)
    }

    func fetchComments(articleId: String) async throws -> [NewsComment] {
        return try await firestoreService.fetchComments(articleId: articleId)
    }

    func toggleLike(articleId: String) async throws -> Bool {
        return try await firestoreService.toggleLike(articleId: articleId)
    }

    func isArticleLiked(articleId: String) async throws -> Bool {
        return try await firestoreService.isArticleLiked(articleId: articleId)
    }

    func fetchLikeAndCommentCount(articleId: String) async throws -> (likes: Int, comments: Int) {
        return try await firestoreService.fetchLikeAndCommentCount(articleId: articleId)
    }
}
