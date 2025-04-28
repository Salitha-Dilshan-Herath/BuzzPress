//
//  LoginView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-27.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Header
            VStack(alignment: .leading, spacing: 8) {
                Text("Hello")
                    .font(Font.custom("Poppins-Bold", size: 40))
                    .foregroundColor(Color("cr-title"))
                
                Text("Again!")
                    .font(Font.custom("Poppins-Bold", size: 40))
                    .foregroundColor(Color("AccentColor"))
                    
                
                Text("Welcome back you've \nbeen missed")
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .foregroundColor(Color("cr-body-text"))

            }
            .padding(.bottom, 20)
            
            // Form fields
            VStack(alignment: .leading, spacing: 15) {
                Text("Username*")
                    .font(Font.custom("Poppins-Regular", size: 14))

                
                TextField("", text: $username)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .frame(height: 45)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                Text("Password*")
                    .font(Font.custom("Poppins-Regular", size: 14))
                
                SecureField("", text: $password)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .frame(height: 45)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
            }
            
            // Forgot password
            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    // Forgot password action
                }) {
                    Text("Forgot the password?")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        
                }
                Spacer()
            }
            
            
            // Login button
            Button(action: {
                // Login action
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // Or continue with
            HStack {
                VStack { Divider() }
                Text("or continue with")
                    .font(.caption)
                    .foregroundColor(.gray)
                VStack { Divider() }
            }
            
            // Guest and Google login
            HStack(spacing: 20) {
                Button(action: {
                    // Guest login action
                }) {
                    Text("Login as Guest")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    // Google login action
                }) {
                    HStack {
                        Image(systemName: "g.circle.fill")
                        Text("Google")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                }
            }
            
            // Sign up
            HStack {
                Spacer()
                Text("don't have an account?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button(action: {
                    // Sign up action
                }) {
                    Text("Sign Up")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
                Spacer()
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .padding()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
