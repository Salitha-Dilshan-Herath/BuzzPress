//
//  LoginViewModel.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-01.
//

import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var email = ""
    @Published var password = ""
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String?
    @Published  var showAlert = false
    @Published private(set) var userSelection: UserSelection?
    
    // MARK: - Dependencies
    private let repository: FirebaseRepository

    // MARK: - Initialization
    init(repository: FirebaseRepository = FirebaseRepository()) {
        self.repository = repository
    }
    
    // MARK: - Public Methods
    func loginWithEmail() async -> UserSelection? {
        guard validateInputs() else { return nil }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await performFirebaseLogin()
            return try await fetchUserSelection()
        } catch {
            handleError(error)
            showAlert = true
            return nil
        }
    }
    
    func loginWithGoogle () async -> UserSelection?  {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await performGoogleLogin()
            return try await fetchUserSelection()
        } catch {
            handleError(error)
            showAlert = true
            return nil
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
    
    private func performFirebaseLogin() async throws {
        
        _ = try await self.repository.loginWithEmail(withEmail: email, password: password)

    }
    
    private func performGoogleLogin() async throws {
        
        _ = try await self.repository.signInWithGoogle()

    }
    
    private func fetchUserSelection() async throws -> UserSelection? {
        return try await self.repository.fetchSelectionForUser()
    }
    
    private func handleError(_ error: Error) {
        if let loginError = error as? LoginError {
            errorMessage = loginError.localizedDescription
        } else {
            errorMessage = "An unexpected error occurred"
        }
    }
}


