//
//  FirestoreService.swift
//  BuzzPress
//
//  Created by user269828 on 5/3/25.
//

import FirebaseFirestore
import FirebaseAuth

protocol FirestoreServiceProtocol {
    func fetchSelectionForUser() async throws -> UserSelection?
    func addComment(articleId: String, text: String) async throws
    func fetchComments(articleId: String) async throws -> [NewsComment]
    func toggleLike(articleId: String) async throws -> Bool
    func isArticleLiked(articleId: String) async throws -> Bool
    func fetchLikeAndCommentCount(articleId: String) async throws -> (likes: Int, comments: Int)
}

class FirestoreService : FirestoreServiceProtocol {
    
    private let db = Firestore.firestore()
    
    //To save the Language and Topic selection when signing in a new user
    func saveSelectionForUser(_ selection: UserSelection, completion: ((Error?) -> Void)? = nil) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion?(NSError(domain: "NoUser", code: 401, userInfo: nil))
            return
        }
        
        let data: [String: Any] = [
            "language": selection.language,
            "topics": selection.topics
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
              let topics = data["topics"] as? [String] else {
            print("Failed to parse user selection data")
            return nil
        }
        
        print("Selected Language: \(language)")
        print("Selected Topics: \(topics)")
        
        return UserSelection(language: language, topics: topics)
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium // e.g., "May 5, 2024"
            dateFormatter.timeStyle = .none   // Exclude time
            let dateString = dateFormatter.string(from: timestamp.dateValue())

            return NewsComment(
                userImage: "person.crop.circle",
                name: (user.displayName ?? user.email) ?? "User",
                comment: text,
                timeAgo: Utility.publishedAgo(dateString))
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
    
    
}

