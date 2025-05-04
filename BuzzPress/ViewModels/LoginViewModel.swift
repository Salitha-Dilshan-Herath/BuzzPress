//
//  LoginViewModel.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-01.
//

import FirebaseAuth

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @Published var showSuccessAlert = false
    @Published var userSelection: UserSelection? = nil
    
    private let firestoreService = FirestoreService()

    func login(completion: @escaping (Bool) -> Void) {
        isLoading = true
        errorMessage = nil
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if error == nil {
                    self?.showSuccessAlert = true
                    self?.firestoreService.fetchSelectionForUser { selection in
                        DispatchQueue.main.async {
                            self?.userSelection = selection
                            completion(true)
                        }
                    }
                } else {
                    print("Login failed: \(error)")
                    completion(false)
                }
            }
        }
    }
}
