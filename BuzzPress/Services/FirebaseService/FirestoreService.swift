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
    func saveUserDataAfterGoogleSignIn(user: User) async throws
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
        
        try await saveUserDataAfterGoogleSignIn(user: authResult.user)
        
        return authResult.user
    }
    
    func saveUserProfile(data: [String: Any]) async throws{
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let userRef = db.collection("users").document(userId)
        try await userRef.setData(data, merge: true)
    }
    
    func saveUserDataAfterGoogleSignIn(user: User) async throws {
        let userRef = db.collection("users").document(user.uid)
        
        let data: [String: Any] = [
            "email": user.email ?? "",
            "fullName": user.displayName ?? "",
            "username": user.displayName?.replacingOccurrences(of: " ", with: "").lowercased() ?? "",
            "provider": "google"
        ]
        
        try await userRef.setData(data, merge: true)
    }
    
    
    func saveSelectionForUser(_ selection: UserSelection, completion: ((Error?) -> Void)? = nil) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion?(NSError(domain: "NoUser", code: 401, userInfo: nil))
            return
        }
        
        let data: [String: Any] = [
            "language": selection.language,
            "topics": selection.topic
        ]
        
        db.collection("users").document(userId).setData(data, merge: true) { error in
            if let error = error {
                print("Error saving to Firestore: \(error.localizedDescription)")
            } else {
                print("Selection saved to Firestore")
            }
        }
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
    
    
    func fetchUserProfile(for uid: String, completion: @escaping (UserProfile?) -> Void) {
        
        db.collection("users").document(uid).getDocument { snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                print("Failed to fetch user data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }
            
            let username = data["username"] as? String ?? ""
            let fullName = data["fullName"] as? String ?? ""
            let email = data["email"] as? String ?? ""
            completion(UserProfile(username: username, fullName: fullName, email: email))
        }
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
              let topics = data["topics"] as? [String] else {
            print("Failed to parse user selection data")
            return nil
        }
        
        print("Selected Language: \(language)")
        print("Selected Topics: \(topics)")
        
        return UserProfile(username: username, fullName: fullName, email: email, preferredLanguage: language, preferredTopic: topics)
    }
    
    
    
}



// MARK: - Protocols for Dependency Injection
protocol AuthProtocol {
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult
}

extension Auth: AuthProtocol {}



// MARK: - Error Handling
enum LoginError: LocalizedError {
    case invalidCredentials
    case networkError
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network error. Please try again."
        case .unknownError:
            return "An unknown error occurred"
        }
    }
    
    func saveUserProfile(_ profile: UserProfile, for uid: String) {
        //            guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let data: [String: Any] = [
            "username": profile.username,
            "fullName": profile.fullName,
            "email": profile.email
        ]
        
        db.collection("users").document(uid).setData(data, merge: true)
    }
}
