//
//  LanguageViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import Foundation

class LanguageViewModel: ObservableObject {
    @Published var allLanguages: [String] = []
    @Published var searchText = ""
    
    var filteredLanguages: [String] {
            if searchText.isEmpty {
                return allLanguages
            } else {
                return allLanguages.filter { $0.lowercased().contains(searchText.lowercased()) }
            }
        }
    
    init() {
        loadSupportedLanguages()
    }
    
    private func loadSupportedLanguages() {
            // Fetch from static dictionary for now
            allLanguages = languageMap.values.sorted()
        }

        let languageMap: [String: String] = [
            "ar": "Arabic",
            "de": "German",
            "en": "English",
            "es": "Spanish",
            "fr": "French",
            "he": "Hebrew",
            "it": "Italian",
            "nl": "Dutch",
            "no": "Norwegian",
            "pt": "Portuguese",
            "ru": "Russian",
            "se": "Northern Sami",
            "ud": "Urdu",
            "zh": "Chinese"
        ]}
