//
//  AuthHelper.swift
//  BuzzPress
//
//  Created by user269828 on 5/5/25.
//

import FirebaseAuth

class AuthHelper {
    
    static var isAuthenticated: Bool = Auth.auth().currentUser != nil
    static var currentUser: User? = Auth.auth().currentUser
}
