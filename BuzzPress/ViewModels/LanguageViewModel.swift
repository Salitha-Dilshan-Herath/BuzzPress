//
//  LanguageViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import Foundation
import FirebaseAuth

class LanguageViewModel: ObservableObject {
    @Published var allLanguages: [String] = []
    @Published var searchText = ""
    @Published var selectedLanguage: String?

    var filteredLanguages: [String] {
        searchText.isEmpty ? allLanguages : allLanguages.filter { $0.lowercased().contains(searchText.lowercased()) }
    }

    private let languageMap: [String: String] = [
        "ar": "Arabic", "de": "German", "en": "English", "es": "Spanish",
        "fr": "French", "he": "Hebrew", "it": "Italian", "nl": "Dutch",
        "no": "Norwegian", "pt": "Portuguese", "ru": "Russian",
        "se": "Northern Sami", "ud": "Urdu", "zh": "Chinese"
    ]

    init() {
        loadLanguages()
    }

    func loadLanguages() {
        allLanguages = languageMap.values.sorted()
    }

    func saveSelection(topics: [String]) {
        guard let selectedLanguage = selectedLanguage else { return }
        let selection = UserSelection(language: selectedLanguage, topics: topics)

        if Auth.auth().currentUser != nil {
            FirestoreService().saveSelectionForUser(selection)
        } else {
            UserDefaultsManager.saveGuestSelection(selection)
        }
    }
}

