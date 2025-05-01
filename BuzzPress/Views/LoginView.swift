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
                    .font(Font.custom(Constants.FONT_BOLD, size: 40))
                    .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                
                Text("Again!")
                    .font(Font.custom(Constants.FONT_BOLD, size: 40))
                    .foregroundColor(Color(Constants.PRIMARY_COLOR))
                    
                
                Text("Welcome back you've \nbeen missed")
                    .font(Font.custom(Constants.FONT_REGULAR, size: 20))
                    .foregroundColor(Color(Constants.BODY_TEXT_COLOR))

            }
            .padding(.bottom, 20)
            
            // Form fields
            VStack(alignment: .leading, spacing: 15) {
                Text("Username*")
                    .font(Font.custom(Constants.FONT_REGULAR, size: 14))

                
                TextField("", text: $username)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 15)
                    .frame(height: 45)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                    )
                
                Text("Password*")
                    .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                
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
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                        .foregroundColor(Color(Constants.PRIMARY_COLOR))
                        
                }
                Spacer()
            }
            
            
            // Login button
            Button(action: {
                // Login action
            }) {
                Text("Login")
                    .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(Constants.PRIMARY_COLOR))
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            // Or continue with
            HStack {
                VStack { Divider() }
                Text("or continue with")
                    .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                    .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                VStack { Divider() }
            }
            
            // Guest and Google login
            HStack(spacing: 20) {
                Button(action: {
                    // Guest login action
                }) {
                    HStack {
                        Image(Constants.ICON_PROFILE)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Login as Guest")
                            .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 14))
                            .foregroundColor(Color(Constants.BUTTON_TEXT_COLOR))
                    }
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
                        Image(Constants.ICON_GOOGLE)
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("Google")
                            .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 14))
                            .foregroundColor(Color(Constants.BUTTON_TEXT_COLOR))
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
                    .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                    .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                
                Button(action: {
                    // Sign up action
                }) {
                    Text("Sign Up")
                        .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 14))
                        .foregroundColor(Color(Constants.PRIMARY_COLOR))
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
