//
//  ChooseTopicsView.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI

struct ChooseTopicsView: View {
    let selectedLanguage: String
    @StateObject private var viewModel = TopicViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToHome = false

    var body: some View {
        VStack {
            // Search bar
            TextField("Search", text: $viewModel.searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            // Topic selection UI
            WrapHStack(viewModel.filteredTopics, spacing: 10) { topic in
                Button(action: {
                    viewModel.toggleSelection(for: topic)
                }) {
                    Text(topic)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(viewModel.selectedTopics.contains(topic) ? Color.blue : Color.white)
                        .foregroundColor(viewModel.selectedTopics.contains(topic) ? .white : .blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .cornerRadius(8)
                }
            }
            .padding()

            Spacer()

            // Next button
            Button("Next") {
                // Save the selected language and topics
                let languageVM = LanguageViewModel()
                languageVM.selectedLanguage = selectedLanguage
                languageVM.saveSelection(topics: Array(viewModel.selectedTopics))

                navigateToHome = true // Example navigation flag
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(viewModel.selectedTopics.isEmpty ? Color.gray : Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
            .disabled(viewModel.selectedTopics.isEmpty)

            // NavigationLink to next screen (e.g., HomeView)
//            NavigationLink(destination: HomePageView(), isActive: $navigateToHome) {
//                EmptyView()
//            }
        }
        .navigationTitle("Choose your Topics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

