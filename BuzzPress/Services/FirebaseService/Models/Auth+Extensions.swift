//
//  Auth+Extensions.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-06.
//
import Foundation
import FirebaseAuth
import FirebaseCore

// MARK: - Protocols for Dependency Injection
protocol AuthProtocol {
    func signIn(withEmail email: String, password: String) async throws -> AuthDataResult
    
    func createUser(withEmail email: String, password: String) async throws -> AuthDataResult
}

extension Auth: AuthProtocol {}



// MARK: - Error Handling
enum LoginError: LocalizedError {
    case invalidCredentials
    case networkError
    case unknownError
    case userNotRegister
    
    var localizedDescription: String {
        switch self {
        case .invalidCredentials:
            return "Invalid email or password"
        case .networkError:
            return "Network error. Please try again."
        case .unknownError:
            return "An unknown error occurred"
        case .userNotRegister:
            return "User not register"
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
