//
//  FirestoreService.swift
//  BuzzPress
//
//  Created by user269828 on 5/3/25.
//

import FirebaseFirestore
import FirebaseAuth
import GoogleSignIn
import FirebaseCore


protocol FirestoreServiceProtocol {
    func loginWithEmail(withEmail: String, password: String) async throws -> User
    func signInWithGoogle() async throws -> User
    func signupWithEmail(withEmail: String, password: String) async throws -> User

    func fetchSelectionForUser() async throws -> UserSelection?
    func addComment(articleId: String, text: String) async throws
    func fetchComments(articleId: String) async throws -> [NewsComment]
    func toggleLike(articleId: String) async throws -> Bool
    func isArticleLiked(articleId: String) async throws -> Bool
    func fetchLikeAndCommentCount(articleId: String) async throws -> (likes: Int, comments: Int)
    func saveUserProfile(data: [String: Any]) async throws
}


class FirestoreService : FirestoreServiceProtocol {
    
    private let db = Firestore.firestore()
    private let auth: AuthProtocol = Auth.auth()
    
    
    func loginWithEmail(withEmail: String, password: String) async throws -> User  {
        
        do {
            let result = try await auth.signIn(withEmail: withEmail, password: password)
            return result.user
        } catch {
            
            throw LoginError.mapFromFirebaseError(error)
        }
    }
    
    func signupWithEmail(withEmail: String, password: String) async throws -> User {
        
        do {
            let result = try await auth.createUser(withEmail: withEmail, password: password)
            return result.user
        } catch {
            
            throw LoginError.mapFromFirebaseError(error)
        }
    }
    
    func signInWithGoogle() async throws -> User {
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            throw LoginError.unknownError
        }
        
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        guard let windowScene = await UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = await windowScene.windows.first,
              let rootViewController = await window.rootViewController else {
            throw LoginError.unknownError
        }
        
        let googleSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
        let user = googleSignInResult.user
        
        guard let idToken = user.idToken?.tokenString else {
            throw LoginError.invalidCredentials
        }
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: user.accessToken.tokenString)
        
        let authResult = try await Auth.auth().signIn(with: credential)
        
        return authResult.user
    }
    
    func saveUserProfile(data: [String: Any]) async throws{
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = db.collection("users").document(userId)
        try await userRef.setData(data, merge: true)
    }
    
    func fetchSelectionForUser() async throws -> UserSelection? {
        guard let userId = Auth.auth().currentUser?.uid else {
            return nil
        }
        
        let snapshot = try await db.collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(),
              let language = data["language"] as? String,
              let topic = data["topics"] as? String else {
            print("Failed to parse user selection data")
            throw LoginError.userNotRegister
        }
        
        print("Selected Language: \(language)")
        print("Selected Topic: \(topic)")
        
        return UserSelection(language: language, topic: topic)
    }
    
    func addComment(articleId: String, text: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { throw NSError(domain: "NoUser", code: 401) }
        
        let articleRef = db.collection("articles").document(articleId)
        let commentRef = articleRef.collection("comments").document()
        
        let data: [String: Any] = [
            "userId": userId,
            "text": text,
            "timestamp": FieldValue.serverTimestamp()
        ]
        
        let batch = db.batch()
        batch.setData(data, forDocument: commentRef)
        batch.setData(["commentCount": FieldValue.increment(Int64(1))], forDocument: articleRef, merge: true)
        try await batch.commit()
    }
    
    func fetchComments(articleId: String) async throws -> [NewsComment] {
        guard let user = Auth.auth().currentUser else {
            throw NSError(domain: "NoUser", code: 401)
        }
        
        let snapshot = try await db.collection("articles").document(articleId).collection("comments")
            .order(by: "timestamp", descending: true)
            .getDocuments()
        
        return try snapshot.documents.map { doc in
            let data = doc.data()
            guard let text = data["text"] as? String,
                  let timestamp = data["timestamp"] as? Timestamp else {
                throw NSError(domain: "InvalidCommentData", code: 400, userInfo: ["documentId": doc.documentID])
            }
            
            let isoFormatter = ISO8601DateFormatter()
            isoFormatter.formatOptions = [.withInternetDateTime] // You can customize this
            let isoString = isoFormatter.string(from: timestamp.dateValue())
            
            return NewsComment(
                userImage: "person.crop.circle",
                name: (user.displayName ?? user.email) ?? "User",
                comment: text,
                timeAgo: Utility.publishedAgo(isoString))
        }
    }
    
    func toggleLike(articleId: String) async throws -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else { throw NSError(domain: "NoUser", code: 401) }
        
        let likeRef = db.collection("articles").document(articleId).collection("likes").document(userId)
        let articleRef = db.collection("articles").document(articleId)
        
        let snapshot = try await likeRef.getDocument()
        
        if snapshot.exists {
            try await likeRef.delete()
            try await articleRef.updateData(["likeCount": FieldValue.increment(Int64(-1))])
            return false
        } else {
            try await likeRef.setData(["timestamp": FieldValue.serverTimestamp()])
            try await articleRef.setData(["likeCount": FieldValue.increment(Int64(1))], merge: true)
            return true
        }
    }
    
    func isArticleLiked(articleId: String) async throws -> Bool {
        guard let userId = Auth.auth().currentUser?.uid else { return false }
        
        let likeRef = db.collection("articles").document(articleId).collection("likes").document(userId)
        let snapshot = try await likeRef.getDocument()
        return snapshot.exists
    }
    
    func fetchLikeAndCommentCount(articleId: String) async throws -> (likes: Int, comments: Int) {
        let doc = try await db.collection("articles").document(articleId).getDocument()
        let data = doc.data()
        return (
            likes: data?["likeCount"] as? Int ?? 0,
            comments: data?["commentCount"] as? Int ?? 0
        )
    }
    
    
    func fetchUserDetails() async throws -> UserProfile? {
        guard let userId = Auth.auth().currentUser?.uid else {
            return nil
        }
        
        let snapshot = try await db.collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(),
              let fullName = data["fullName"] as? String,
              let email = data["email"] as? String,
              let username = data["username"] as? String,
              let language = data["language"] as? String,
              let topic = data["topic"] as? String else {
            print("Failed to parse user selection data")
            return nil
        }
        
        print("Selected Language: \(language)")
        print("Selected Topic: \(topic)")
        
        return UserProfile(username: username, fullName: fullName, email: email, preferredLanguage: language, preferredTopic: topic)
    }
    
}
