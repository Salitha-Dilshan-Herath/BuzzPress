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
    
}

