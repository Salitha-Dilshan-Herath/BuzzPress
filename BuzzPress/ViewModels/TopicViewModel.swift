//
//  TopicViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI
import FirebaseAuth

class TopicViewModel: ObservableObject {
    @Published var allTopics: [String] = [
        "National", "International", "Sport", "Lifestyle", "Business",
        "Health", "Fashion", "Technology", "Science", "Art", "Politics"
    ]
    
    @Published var selectedTopics: Set<String> = []
    @Published var searchText: String = ""
    var isGuest: Bool = true

        var selectionsAreSaved: Bool {
            if isGuest {
                return UserDefaults.standard.stringArray(forKey: "guest_selected_topics") != nil
            } else {
                // You might want to track Firestore save success with a flag
                return firestoreSaveSuccessFlag
            }
        }

        var firestoreSaveSuccessFlag = false

    var filteredTopics: [String] {
        if searchText.isEmpty {
            return allTopics
        } else {
            return allTopics.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }

    func toggleSelection(for topic: String) {
        if selectedTopics.contains(topic) {
            selectedTopics.remove(topic)
        } else {
            selectedTopics.insert(topic)
        }
    }

    func saveTopics(for language: String) {
        let selection = UserSelection(language: language, topics: Array(selectedTopics))

        if Auth.auth().currentUser != nil {
            FirestoreService().saveSelectionForUser(selection)
        } else {
            UserDefaultsManager.saveGuestSelection(selection)
        }
    }
    
    func saveSelectionForGuest() {
        let topics = Array(selectedTopics)
        UserDefaults.standard.set(topics, forKey: "guest_selected_topics")
    }
}

