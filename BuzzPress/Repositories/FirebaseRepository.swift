//
//  FirebaseRepository.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-05.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn

protocol FirebaseRepositoryProtocol {
    //Auth
    func loginWithEmail(withEmail: String, password: String) async throws -> User
    func signInWithGoogle() async throws -> User
    func signupWithEmail(withEmail: String, password: String) async throws -> User
    //user
    func fetchSelectionForUser() async throws -> UserSelection?
    
    //comment and like
    func addComment(articleId: String, text: String) async throws
    func fetchComments(articleId: String) async throws -> [NewsComment]
    func toggleLike(articleId: String) async throws -> Bool
    func isArticleLiked(articleId: String) async throws -> Bool
    func fetchLikeAndCommentCount(articleId: String) async throws -> (likes: Int, comments: Int)
    
    func saveUserProfile(data: [String: Any]) async throws
    func fetchUserDetails() async throws -> UserProfile?
    func logOut() async throws
    
    func bookmarkArticle(article: Article) async throws
    func removeBookmark(articleId: String) async throws
    func isArticleBookmarked(articleId: String) async throws -> Bool
    func fetchBookmarkedArticles() async throws -> [Article]
}

class FirebaseRepository: FirebaseRepositoryProtocol {
        
    private let firestoreService: FirestoreServiceProtocol
    
    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreService = firestoreService
    }
    
    func loginWithEmail(withEmail: String, password: String) async throws -> User {
        return try await firestoreService.loginWithEmail(withEmail: withEmail, password: password)
    }
    
    func signupWithEmail(withEmail: String, password: String) async throws -> User {
        return try await firestoreService.signupWithEmail(withEmail: withEmail, password: password)
    }
    
    func signInWithGoogle() async throws -> User {
        return try await firestoreService.signInWithGoogle()
    }
    
    func saveUserProfile(data: [String : Any]) async throws {
        return try await firestoreService.saveUserProfile(data: data)   
    }
    
    func fetchUserDetails() async throws -> UserProfile? {
        return try await firestoreService.fetchUserDetails()
    }
    
    func logOut() async throws {
        return try await firestoreService.logOut()
    }
    
    func fetchSelectionForUser() async throws -> UserSelection? {
        return try await firestoreService.fetchSelectionForUser()
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
    
    func bookmarkArticle(article: Article) async throws {
        return try await firestoreService.bookmarkArticle(article: article)
    }
    
    func removeBookmark(articleId: String) async throws {
        return try await firestoreService.removeBookmark(articleId: articleId)
    }
    
    func isArticleBookmarked(articleId: String) async throws -> Bool {
        return try await firestoreService.isArticleBookmarked(articleId: articleId)
    }
    
    func fetchBookmarkedArticles() async throws -> [Article] {
        return try await firestoreService.fetchBookmarkedArticles()
    }
}
