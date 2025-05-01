//
//  TopicViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI

class TopicViewModel: ObservableObject {
    @Published var allTopics: [String] = [
        "National", "International", "Sport", "Lifestyle", "Business",
        "Health", "Fashion", "Technology", "Science", "Art", "Politics"
    ]
    
    @Published var selectedTopics: Set<String> = []
    @Published var searchText: String = ""
    
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
}
