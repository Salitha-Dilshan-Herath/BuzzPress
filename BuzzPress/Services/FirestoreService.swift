//
//  FirestoreService.swift
//  BuzzPress
//
//  Created by user269828 on 5/3/25.
//

import FirebaseFirestore
import FirebaseAuth

class FirestoreService {
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
    
    //To fetch the saved language and topic selection of an existing user when logging in and directed to HomePageView
    func fetchSelectionForUser(completion: @escaping (UserSelection?) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }

        db.collection("users").document(userId).getDocument { snapshot, error in
            if let data = snapshot?.data(),
               let language = data["language"] as? String,
               let topics = data["topics"] as? [String] {
                    print("Selected Language: \(language)")
                    print("Selected Topics: \(topics)")

                let selection = UserSelection(language: language, topics: topics)
                completion(selection)
            } else {
                print("Failed to fetch user selection: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
}

