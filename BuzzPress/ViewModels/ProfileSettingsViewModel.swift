//
//  ProfileSettingsViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/5/25.
//

import Foundation
import FirebaseAuth

class ProfileSettingsViewModel: ObservableObject {
    @Published var username = ""
    @Published var fullName = ""
    @Published var email = ""

    private let firestoreService = FirestoreService()

    func loadUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        firestoreService.fetchUserProfile(for: uid) { [weak self] profile in
            DispatchQueue.main.async {
                guard let profile = profile else { return }
                self?.username = profile.username
                self?.fullName = profile.fullName
                self?.email = profile.email
            }
        }
    }

    func saveProfileChanges() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let profile = UserProfile(username: username, fullName: fullName, email: email)
        firestoreService.saveUserProfile(profile, for: uid)
    }
}
