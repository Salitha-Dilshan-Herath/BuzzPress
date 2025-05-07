//
//  SearchView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-03.
//

import SwiftUI

struct SearchView: View {
    
    @State private var selectedCategory = Constants.CATEGORIES[0]
    @AppStorage("selectedLanguage") private var selectedLanguage: String = ""
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = false
    @StateObject private var viewModel = SearchViewModel(language: "")

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Explore")
                        .font(Font.custom(Constants.FONT_BOLD, size: 32))
                        .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                }
                .padding(.horizontal)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    
                    TextField("Search", text: $viewModel.searchText)
                        .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color(.systemBackground))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(Constants.BODY_TEXT_COLOR), lineWidth: 1)
                )
                .padding(.horizontal)
                
                // Categories
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(Constants.CATEGORIES, id: \.self) { category in
                            Button(action: {
                                Task {
                                    await viewModel.resetAndFetch(language: selectedLanguage, topics: category)
                                    selectedCategory = category
                                }
                            }) {
                                VStack(spacing: 4) {
                                    Text(category)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 12)
                                        .foregroundColor(.primary)
                                    
                                    Rectangle()
                                        .fill(selectedCategory == category ? Color.blue : Color.clear)
                                        .frame(height: 2)
                                }
                                .fixedSize()
                            }
                            .animation(.easeInOut, value: selectedCategory)
                        }
                    }
                    .padding(.horizontal)
                    .frame(height: 50)
                }
                
                // News List or Empty State
                ScrollView {
                    if viewModel.filteredArticles.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "newspaper")
                                .resizable()
                                .frame(width: 64, height: 64)
                                .foregroundColor(.gray)
                            
                            Text("No news available for your selected category.")
                                .font(.headline)
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(viewModel.filteredArticles.indices, id: \.self) { index in
                                let article = viewModel.filteredArticles[index]
                                NavigationLink(destination: NewsDetailsView(article: article)
                                    .navigationBarBackButtonHidden(true)) {
                                        NewsCardView(article: article)
                                            .onAppear {
                                                if index == viewModel.filteredArticles.count - 1 {
                                                    Task {
                                                        await viewModel.fetchNextPage(language: selectedLanguage)
                                                    }
                                                }
                                            }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .task {
                await viewModel.resetAndFetch(language: selectedLanguage, topics: selectedCategory)
            }
        }
        .onAppear {
            viewModel.selectedLanguage = selectedLanguage
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(darkModeEnabled ? .dark : .light)
    }
}

#Preview {
    SearchView()
}
