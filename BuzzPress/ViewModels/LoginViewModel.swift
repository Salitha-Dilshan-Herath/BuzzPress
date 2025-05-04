//
//  LoginViewModel.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-01.
//

import FirebaseAuth
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
    private let auth: AuthProtocol
    private let firestoreService: FirestoreServiceProtocol
    
    // MARK: - Initialization
    init(auth: Auth = Auth.auth(),
         firestoreService: FirestoreServiceProtocol = FirestoreService()) {
        self.auth = auth
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
        do {
            _ = try await auth.signIn(withEmail: email, password: password)
        } catch {
            throw LoginError.mapFromFirebaseError(error)
        }
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

// MARK: - Protocols for Dependency Injection
protocol AuthProtocol {
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult
}

extension Auth: AuthProtocol {}



// MARK: - Error Handling
enum LoginError: LocalizedError {
    case invalidCredentials
    case networkError
    case unknownError
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network error. Please try again."
        case .unknownError:
            return "An unknown error occurred"
        }
    }
    
    static func mapFromFirebaseError(_ error: Error) -> LoginError {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.wrongPassword.rawValue, AuthErrorCode.userNotFound.rawValue, AuthErrorCode.invalidCredential.rawValue:
            return .invalidCredentials
        case AuthErrorCode.networkError.rawValue:
            return .networkError
        default:
            return .unknownError
        }
    }
}
