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
    @Environment(\.presentationMode) var presentationMode
    @State private var navigateToTopics = false
    @AppStorage("selectedLanguage") private var selectedLanguage: String = ""

    var body: some View {
        NavigationStack {
            VStack {
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
                List(viewModel.sortedLanguages, id: \.code) { language in
                    HStack {
                        Text(language.name)
                            .foregroundColor(selectedLanguage == language.code ? .blue : .primary)
                        Spacer()
                        if selectedLanguage == language.code {
                            Image(systemName: "checkmark")
                                .foregroundColor(.blue)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedLanguage = language.code
                    }
                }
                .listStyle(PlainListStyle())
                
                // Next Button
                Button(action: {
                    print("Selected language: \(selectedLanguage)")
                    // Navigate to next screen
                    viewModel.selectedLanguage = selectedLanguage
                    navigateToTopics = true
                    
                    if isGuest {
                        viewModel.saveSelectionForGuest()
                        navigateToTopics = true
                    } else {
                        Task {
                            await viewModel.saveSelection()
                            navigateToTopics = true
                        }
                    }
                }) {
                    Text("Next")
                        .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(selectedLanguage.isEmpty ? Color.gray : Color.blue)
                        .cornerRadius(10)
                }
                .padding()
                .disabled(selectedLanguage.isEmpty)
            }.navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                    }
                }
                
                ToolbarItem(placement: .principal) {
                    Text("Choose your Topics")
                        .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                        .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                }
            }.navigationDestination(isPresented: $navigateToTopics) {
                ChooseTopicsView(isGuest: isGuest)
                    .navigationBarBackButtonHidden(true)
            }.alert("Language Save Failed", isPresented: $viewModel.showAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
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
