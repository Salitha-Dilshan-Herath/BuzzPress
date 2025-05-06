//
//  BookmarkView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-03.
//

import SwiftUI

struct BookmarkView: View {
    @StateObject private var viewModel = BookmarkViewModel()
    @State private var searchText = ""
    
    var body: some View {
        NavigationStack {
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
                
                if viewModel.bookmarkedArticles.isEmpty {
                    Spacer()
                    VStack(spacing: 16) {
                        Image(systemName: "bookmark.slash")
                            .resizable()
                            .frame(width: 64, height: 64)
                            .foregroundColor(.gray)
                        
                        Text("No bookmarked articles")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 10) {
                            ForEach(viewModel.bookmarkedArticles.indices, id: \.self) { index in
                                let article = viewModel.bookmarkedArticles[index]
                                NavigationLink(destination: NewsDetailsView(article: article)
                                    .navigationBarBackButtonHidden(true)) {
                                        NewsRowView(article: article)
                                        .padding(.bottom, 8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.vertical)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    await viewModel.loadBookmarks()
                }
            }
        }
    }
}
