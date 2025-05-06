//
//  LoginView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-27.
//

import SwiftUI

struct SignUpView: View {
    @StateObject private var viewModel = SignUpViewModel()
    @State private var showAlert = false
    @State private var navigateToLanguageSelection = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text("Hello!")
                        .font(Font.custom(Constants.FONT_BOLD, size: 40))
                        .foregroundColor(Color(Constants.PRIMARY_COLOR))
                    
                    Text("Signup to get Started")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 20))
                        .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                }
                .padding(.bottom, 20)
                
                // Form fields
                VStack(alignment: .leading, spacing: 15) {
                    HStack(spacing: 1) {
                        Text("Username")
                        Text("*").foregroundColor(.red)
                    }
                    .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                    
                    TextField("", text: $viewModel.email)
                        .padding()
                        .frame(height: 45)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                    
                    HStack(spacing: 1) {
                        Text("Password")
                        Text("*").foregroundColor(.red)
                    }
                    .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                    
                    SecureField("", text: $viewModel.password)
                        .padding()
                        .frame(height: 45)
                        .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1))
                }
                
                // Forgot Password
                HStack {
                    Spacer()
                    Button("Forgot the password?") {
                        // Action
                    }
                    .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                    .foregroundColor(Color(Constants.PRIMARY_COLOR))
                    Spacer()
                }
                
                // Sign Up Button
                Button {
                    Task {
                        if await viewModel.sigUpWithEmailAndPassword() {
                            navigateToLanguageSelection = true
                        } else {
                            showAlert = true
                        }
                    }
                } label: {
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Sign In")
                            .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(Constants.PRIMARY_COLOR))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                
                // Or continue with
                HStack {
                    VStack { Divider() }
                    Text("or continue with")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                        .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                    VStack { Divider() }
                }
                
                // Google Login
                HStack {
                    Spacer()
                    Button(action: {
                        Task{
                            if await viewModel.sigUpWithGoogle() {
                                navigateToLanguageSelection = true
                            } else {
                                showAlert = true
                            }
                        }
                    }) {
                        HStack {
                            Image(Constants.ICON_GOOGLE)
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text("Google")
                                .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                        }
                        .frame(maxWidth: 174, maxHeight: 48)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                    }
                    Spacer()
                }
                
                // Already have account
                HStack {
                    Spacer()
                    Text("Already have an account?")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                        .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                    NavigationLink("Login", destination: LoginView())
                        .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 14))
                        .foregroundColor(Color(Constants.PRIMARY_COLOR))
                    Spacer()
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
            .alert("Sign Up Status", isPresented: $showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage ?? "Login successful!")
            }
            .navigationDestination(isPresented: $navigateToLanguageSelection) {
                SelectLanguageView(isGuest: false)
                    .navigationBarBackButtonHidden(true)
            }
        }.navigationBarBackButtonHidden(true)
    }
}



struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
