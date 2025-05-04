//
//  AuthViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/3/25.
//

import FirebaseAuth
import SwiftUI

class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    @Published var showSuccessAlert = false

    init() {
        self.isAuthenticated = Auth.auth().currentUser != nil
    }

    func login() {
        errorMessage = nil
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    self?.isAuthenticated = false
                } else {
                    self?.isAuthenticated = true
                    self?.showSuccessAlert = true
                }
            }
        }
    }

    func signup(completion: @escaping (Bool) -> Void) {
        errorMessage = nil
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    completion(false)
                } else {
                    self?.isAuthenticated = true
                    completion(true)
                }
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            email = ""
            password = ""
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
