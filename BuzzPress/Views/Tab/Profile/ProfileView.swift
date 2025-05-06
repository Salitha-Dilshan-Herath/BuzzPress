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
                            $viewModel.selectedTopics) {
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
                    NavigationLink(destination: Text("Help Section")) {
                        HStack {
                            Image(systemName: "questionmark.circle")
                            Text("Help")
                        }
                        .foregroundColor(.black)
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        try? Auth.auth().signOut()
                        print("##Auth - ProfileView## isAuthenticated: \(AuthHelper.isAuthenticated)")
                        print("##ProfileView## Logged Out")
                        // Navigate back to login or do additional cleanup
                        isLoggedIn = false
                        
                    })
                    
                    {
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
            viewModel.loadUserDetails()
        }

    }
}
#Preview {
    ProfileView()
}


