//
//  ProfileView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-03.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    @StateObject private var viewModel = ProfileSettingsViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("isGuestUser") private var isGuestUser: Bool = false
    
    
    var body: some View {
        
        ZStack {
            VStack {
                Spacer().frame(height: 20)
                
                // Profile image
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                
                Text("Profile Settings")
                    .font(.title2)
                    .padding(.top, 8)
                
                Form {
                    Section(header: Text("Username")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))) {
                            TextField("Placeholder Text", text: $viewModel.username)
                        }
                    
                    Section(header: Text("Full Name")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))) {
                            TextField("Placeholder Text", text: $viewModel.fullName)
                        }
                    
                    Section(header: Text("Email Address")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))) {
                            TextField("Email", text: $viewModel.email)
                                .keyboardType(.emailAddress)
                        }
                    
                    Section(header: Text("Preferred Language")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))) {
                            Picker("Select a Language", selection: $viewModel.selectedLanguageCode) {
                                ForEach(viewModel.languageMap.sorted(by: { $0.value < $1.value }), id: \.key) { code, name in
                                    Text(name).tag(code)
                                }
                            }
                            .pickerStyle(MenuPickerStyle()) // or .inline, .wheel
                        }
                    
                    
                    Section(header: Text("Preferred Topic")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))) {
                            Picker("Select a Topic", selection:
                                    $viewModel.selectedTopic) {
                                ForEach(viewModel.availableTopics, id: \.self) { topic in
                                    Text(topic.capitalized).tag(topic)
                                }
                            }
                                    .pickerStyle(MenuPickerStyle())
                        }
                    
                    
                    
                    Section {
                        Toggle(isOn: .constant(false)) {
                            Label("Dark Mode", systemImage: "moon")
                                .foregroundColor(.black)
                        }
                        
                        //Colour is not getting applied
                        NavigationLink(destination: HelpView()) {
                            Label("Help & Support", systemImage: "questionmark.circle")
                        }
                        
                        Button(action: {
                            try? Auth.auth().signOut()
                            print("##Auth - ProfileView## isAuthenticated: \(AuthHelper.isAuthenticated)")
                            print("##ProfileView## Logged Out")
                            // Navigate back to login or do additional cleanup
                            isLoggedIn = false
                            
                        }){
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(.black)
                        }
                    }
                    
                    Button("Save Changes") {
                        viewModel.saveUserDetailsUpdates()
                    }
                    
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .onAppear {
                if !isGuestUser{
                    Task {
                        await viewModel.loadUserDetails()
                    }
                }
            }.blur(radius: isGuestUser ? 5 : 0)
            
            // Popup overlay
            if isGuestUser {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text("Do you want create profile?")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            isLoggedIn = false
                        }) {
                            Text("Login")
                                .frame(width: 100, height: 44)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
                .padding()
                .background(.ultraThinMaterial) // For blur effect on popup background
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
        }
        .animation(.easeInOut, value: isGuestUser)
    }
}

#Preview {
    ProfileView()
}


