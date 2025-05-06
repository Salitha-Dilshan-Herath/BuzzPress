//
//  ProfileSettingsViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/5/25.
//

import Foundation
import FirebaseAuth

@MainActor
class ProfileSettingsViewModel: ObservableObject {
    @Published var username = ""
    @Published var fullName = ""
    @Published var email = ""

    private let firestoreService = FirestoreService()
    
    @Published var languageMap: [String: String] = [
        "ar": "Arabic", "de": "German", "en": "English", "es": "Spanish",
        "fr": "French", "he": "Hebrew", "it": "Italian", "nl": "Dutch",
        "no": "Norwegian", "pt": "Portuguese", "ru": "Russian",
        "se": "Northern Sami", "ud": "Urdu", "zh": "Chinese"
    ]
    @Published var selectedLanguageCode: String = "" // default
    
    @Published var availableTopics: [String] = [
        "National", "International", "Sport", "Lifestyle", "Business",
        "Health", "Fashion", "Technology", "Science", "Art", "Politics"
    ]

    @Published var selectedTopic: String = ""

    
    func loadUserDetails() async {
        do {
            if let profile = try await firestoreService.fetchUserDetails() {
                self.username = profile.username
                self.fullName = profile.fullName
                self.email = profile.email
                self.selectedLanguageCode = profile.preferredLanguage
                self.selectedTopic = profile.preferredTopic
            }
        } catch {
            print("##ProfileSettingsViewModel## Failed to load user details: \(error.localizedDescription)")
        }
    }
    
    func saveUserDetailsUpdates() {
        let updatedProfile = UserProfile(
            username: username,
            fullName: fullName,
            email: email,
            preferredLanguage: selectedLanguageCode,
            preferredTopic: selectedTopic)
        
        
//        firestoreService.updatedUserDetails(updatedProfile) { error in
//            if let error = error {
//                print("##ProfileSettingsViewModel## Failed to update user details: \(error.localizedDescription)")
//            } else {
//                print("##ProfileSettingsViewModel## Successfully updated user details.")
//            }
//        }
    }

}
