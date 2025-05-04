//
//  SelectLanguageView.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI
struct SelectLanguageView: View {
    var isGuest: Bool
    @StateObject private var viewModel = LanguageViewModel()
    @State private var selectedLanguage: String? = nil
    @State private var navigateToTopics = false
    
    
    
    var body: some View {
            VStack {
                // Header
                HStack {
                    Button(action: {
                        // Go back action
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("Select your Language")
                        .font(.headline)
                    Spacer()
                    // Placeholder for alignment
                    Image(systemName: "arrow.left")
                        .foregroundColor(.clear)
                }
                .padding()

                // Search Bar
                HStack {
                    TextField("Search", text: $viewModel.searchText)
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                }
                .padding([.horizontal])

                // Language List
                List(viewModel.filteredLanguages, id: \.self) { language in
                    HStack {
                        Text(language)
                            .foregroundColor(selectedLanguage == language ? .blue : .primary)
                        Spacer()
                        if selectedLanguage == language {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedLanguage = language
                    }
                }
                .listStyle(PlainListStyle())

                // Next Button
                Button(action: {
                    print("Selected language: \(selectedLanguage ?? "None")")
                    // Navigate to next screen
                    viewModel.selectedLanguage = selectedLanguage
                    navigateToTopics = true
                    
                    if isGuest {
                        viewModel.saveSelectionForGuest() // Save to UserDefaults
                    } else {
                        viewModel.selectedLanguage = selectedLanguage // Already implemented
                    }
                    navigateToTopics = true
                }) {
                    Text("Next")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedLanguage != nil ? Color.blue : Color.gray)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(selectedLanguage == nil)
                
                // NavigationLink to ChooseTopicView
                NavigationLink(
                    destination: ChooseTopicsView(selectedLanguage: selectedLanguage ?? "", isGuest: isGuest),
                    isActive: $navigateToTopics
                ) {
                EmptyView()
                }
                .hidden()
            }
        }
}

// Preview
struct SelectLanguageView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLanguageView(isGuest: true)
            .preferredColorScheme(.light)
        
        SelectLanguageView(isGuest: true)
            .preferredColorScheme(.dark)
    }
}
