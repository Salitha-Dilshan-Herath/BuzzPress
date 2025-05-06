//
//  LanguageViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import Foundation
import FirebaseAuth

@MainActor
class LanguageViewModel: ObservableObject {
    @Published var allLanguages: [String] = []
    @Published var searchText = ""
    @Published var selectedLanguage: String = ""
    @Published var errorMessage: String = ""
    @Published var isLoading = false
    @Published var showAlert = false

    private let repository: FirebaseRepositoryProtocol


    private let languageMap: [String: String] = [
        "ar": "Arabic", "de": "German", "en": "English", "es": "Spanish",
        "fr": "French", "he": "Hebrew", "it": "Italian", "nl": "Dutch",
        "no": "Norwegian", "pt": "Portuguese", "ru": "Russian",
        "se": "Northern Sami", "ud": "Urdu", "zh": "Chinese"
    ]
    
    var sortedLanguages: [(code: String, name: String)] {
        languageMap
            .sorted { $0.value < $1.value }
            .map { (code: $0.key, name: $0.value) }
    }
    
    init(repository: FirebaseRepositoryProtocol = FirebaseRepository()) {
        self.repository = repository

    }

    func saveSelection() async {
        
        do {
            try await self.repository.saveUserProfile(data: ["language" : selectedLanguage])
        }catch {
            errorMessage = "Failed to save language: \(error.localizedDescription)"
            showAlert = true 
        }

    }
    
    func saveSelectionForGuest() {
        UserDefaults.standard.set(selectedLanguage, forKey: "guest_selected_language")
    }
}

