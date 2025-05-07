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
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    
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
    
    private let repository: FirebaseRepositoryProtocol
    
    init(repository: FirebaseRepositoryProtocol = FirebaseRepository()) {
        self.repository = repository
    }
    
    func loadUserDetails() async {
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            if let profile = try await self.repository.fetchUserDetails() {
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
    
    func saveUserDetailsUpdates() async {
      
        isLoading = true
        defer { isLoading = false }
        
        do {
            let userDict: [String: String] = [
                "fullName": fullName,
                "email": email,
                "username": username,
                "language": selectedLanguageCode,
                "topic": selectedTopic
            ]
            try await self.repository.saveUserProfile(data: userDict)
            
        } catch {
            print("##ProfileSettingsViewModel## Failed to load user details: \(error.localizedDescription)")
        }
    }
    
    func userLogout() async {
        do {
            try await self.repository.logOut()
        }catch {
            print("##ProfileSettingsViewModel## Failed to logout user details: \(error.localizedDescription)")
        }
    }
    
}
