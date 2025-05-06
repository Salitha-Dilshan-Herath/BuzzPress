//
//  TopicViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI
import FirebaseAuth

@MainActor
class TopicViewModel: ObservableObject {
    @Published var allTopics: [String] = [
        "National", "International", "Sport", "Lifestyle", "Business",
        "Health", "Fashion", "Technology", "Science", "Art", "Politics"
    ]
    
    @Published var selectedTopic: String = ""
    @Published var searchText: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading = false
    @Published var showAlert = false
    
    private let repository: FirebaseRepositoryProtocol
    var isGuest: Bool = true
    
    init(repository: FirebaseRepositoryProtocol = FirebaseRepository()) {
        self.repository = repository
        
    }
    
    func saveSelection() async {
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            try await self.repository.saveUserProfile(data: ["topic" : selectedTopic])
        }catch {
            errorMessage = "Failed to save Topic: \(error.localizedDescription)"
            showAlert = true
        }
    }
    
    func saveSelectionForGuest() {
        UserDefaults.standard.set(selectedTopic, forKey: "guest_selected_topics")
    }
}

