//
//  ProfileView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-03.
//

import SwiftUI

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileSettingsViewModel()
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("isGuestUser") private var isGuestUser: Bool = false
    @AppStorage("selectedLanguage") private var selectedLanguage: String = ""
    @AppStorage("selectedTopic") private var selectedTopic: String = ""
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = false

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
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                        .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                    ) {
                        TextField("Placeholder Text", text: $viewModel.username)
                    }

                    Section(header: Text("Full Name")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                        .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                    ) {
                        TextField("Placeholder Text", text: $viewModel.fullName)
                    }

                    Section(header: Text("Email Address")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                        .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                    ) {
                        TextField("Email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                    }

                    Section(header: Text("Preferred Language")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                        .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                    ) {
                        Picker("Select a Language", selection: $viewModel.selectedLanguageCode) {
                            ForEach(viewModel.languageMap.sorted(by: { $0.value < $1.value }), id: \.key) { code, name in
                                Text(name).tag(code)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    Section(header: Text("Preferred Topic")
                        .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                        .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                    ) {
                        Picker("Select a Topic", selection: $viewModel.selectedTopic) {
                            ForEach(viewModel.availableTopics, id: \.self) { topic in
                                Text(topic.capitalized).tag(topic)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }

                    Section {
                        Toggle(isOn: $darkModeEnabled) {
                            Label("Dark Mode", systemImage: "moon")
                                .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                        }

                        NavigationLink(destination: HelpView()) {
                            Label("Help & Support", systemImage: "questionmark.circle")
                        }

                        Button(action: {
                            Task {
                                await viewModel.userLogout()
                                isLoggedIn = false
                            }
                        }) {
                            Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                                .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                        }
                    }

                    Button("Save Changes") {
                        Task {
                            await viewModel.saveUserDetailsUpdates()
                            selectedLanguage = viewModel.selectedLanguageCode
                            selectedTopic = viewModel.selectedTopic
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .onAppear {
                if !isGuestUser {
                    Task {
                        await viewModel.loadUserDetails()
                    }
                }
            }
            .blur(radius: isGuestUser ? 5 : 0)

            // Guest popup overlay
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
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding()
            }
        }
        .overlay {
            if viewModel.isLoading {
                ZStack {
                    Color(.systemBackground)
                        .opacity(0.5)
                        .ignoresSafeArea()

                    ProgressView("Please wait...")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(.systemBackground))
                                .shadow(radius: 10)
                        )
                }
                .transition(.opacity)
            }
        }
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
        .animation(.easeInOut, value: isGuestUser)
    }
}

#Preview {
    ProfileView()
}
