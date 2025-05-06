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
    @Published private(set) var showSuccessAlert = false
    @Published private(set) var userSelection: UserSelection?
    
    // MARK: - Dependencies
    private let firestoreService: FirestoreServiceProtocol
    
    // MARK: - Initialization
    init(firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.firestoreService = firestoreService
    }
    
    // MARK: - Public Methods
    func login() async -> UserSelection? {
        guard validateInputs() else { return nil }
        
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        
        do {
            try await performFirebaseLogin()
            showSuccessAlert = true
            return await fetchUserSelection()
        } catch {
            handleError(error)
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
        
        let user = try await firestoreService.loginWithEmail(withEmail: email, password: password)

    }
    
    private func fetchUserSelection() async -> UserSelection? {
        do {
            return try await firestoreService.fetchSelectionForUser()
        } catch {
            errorMessage = "Failed to fetch user data"
            return nil
        }
    }
    
    private func handleError(_ error: Error) {
        if let loginError = error as? LoginError {
            errorMessage = loginError.localizedDescription
        } else {
            errorMessage = "An unexpected error occurred"
        }
    }
}


