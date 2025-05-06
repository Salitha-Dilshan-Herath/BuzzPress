//
//  SignUpViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/2/25.
//

import Foundation
import FirebaseAuth

@MainActor
class SignUpViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var showAlert = false
    @Published var navigateToLanguageView = false

    // MARK: - Dependencies
    private let repository: FirebaseRepository

    // MARK: - Initialization
    init(repository: FirebaseRepository = FirebaseRepository()) {
        self.repository = repository
    }
    
    
    func sigUpWithEmailAndPassword() async -> Bool {
        guard validateInputs() else { return false }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await performFirebaseSignUp()
            return true
        } catch {
            handleError(error)
            showAlert = true
            return false
        }
    }
    
    func sigUpWithGoogle () async -> Bool  {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await performGoogleLogin()
            return true

        } catch {
            handleError(error)
            showAlert = true
            return false
        }
    }
    
    private func performFirebaseSignUp() async throws {
        
        _ = try await self.repository.signupWithEmail(withEmail: email, password: password)

    }
    
    private func performGoogleLogin() async throws {
        
        let user = try await self.repository.signInWithGoogle()
        let data: [String: Any] = [
            "email": user.email ?? "",
            "fullName": user.displayName ?? "",
            "username": user.displayName?.replacingOccurrences(of: " ", with: "").lowercased() ?? "",
            "provider": "google"
        ]
        try await self.repository.saveUserProfile(data: data)

    }
    
    private func handleError(_ error: Error) {
        if let loginError = error as? LoginError {
            errorMessage = loginError.localizedDescription
        } else {
            errorMessage = "An unexpected error occurred"
        }
    }
    
    // MARK: - Private Methods
    private func validateInputs() -> Bool {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both email and password"
            return false
        }
        
        guard email.contains("@") else {
            errorMessage = "Please enter a valid email address"
            return false
        }
        
        return true
    }
}
