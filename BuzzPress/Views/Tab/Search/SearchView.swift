//
//  SearchView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-03.
//

import SwiftUI

struct SearchView: View {
    
    @State private var selectedCategory = Constants.CATEGORIES[0]
    @StateObject var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Title
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Explore")
                            .font(Font.custom(Constants.FONT_BOLD, size: 32))
                            .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                    }
                    .padding(.horizontal)
                    
                    // Search bar
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
                                    selectedCategory = category
                                    Task {
                                        await viewModel.resetAndFetch(language: "en", topics: category)
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
                                }
                                .animation(.easeInOut, value: selectedCategory)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // News articles with pagination
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.filteredArticles.indices, id: \.self) { index in
                            let article = viewModel.filteredArticles[index]
                            NavigationLink(destination: NewsDetailsView(article: article)
                                .navigationBarBackButtonHidden(true)) {
                                    NewsCardView(article: article)
                                        .onAppear {
                                            if index == viewModel.filteredArticles.count - 1 {
                                                Task {
                                                    await viewModel.fetchNextPage(language: "en")
                                                }
                                            }
                                        }
                                }
                                .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .task {
                await viewModel.resetAndFetch(language: "en", topics: selectedCategory)
            }
        }.navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchView()
}
