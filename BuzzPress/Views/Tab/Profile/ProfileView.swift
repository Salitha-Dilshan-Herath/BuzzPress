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

    var body: some View {
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
                Section(header: Text("Username")) {
                    TextField("Placeholder Text", text: $viewModel.username)
                }

                Section(header: Text("Full Name")) {
                    TextField("Placeholder Text", text: $viewModel.fullName)
                }

                Section(header: Text("Email Address").foregroundColor(.red)) {
                    TextField("Placeholder Text", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                }

                Section {
                    Toggle(isOn: .constant(false)) {
                        Label("Dark Mode", systemImage: "moon")
                    }

                    NavigationLink(destination: Text("Help Section")) {
                        Label("Help", systemImage: "questionmark.circle")
                    }

                    Button(action: {
                        try? Auth.auth().signOut()
                        print("##Auth - ProfileView## isAuthenticated: \(AuthHelper.isAuthenticated)")
                        print("##ProfileView## Logged Out")
                        // Navigate back to login or do additional cleanup
                        isLoggedIn = false
                        
                    }) {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                            .foregroundColor(.red)
                    }
                }

                Button("Save Changes") {
                    viewModel.saveProfileChanges()
                }
                .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .onAppear {
            viewModel.loadUserProfile()
        }
    }
}
#Preview {
    ProfileView()
}


