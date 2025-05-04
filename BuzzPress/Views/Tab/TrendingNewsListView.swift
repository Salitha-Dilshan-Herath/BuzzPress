//
//  TrendingNewsListView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-03.
//

import SwiftUI

struct TrendingNewsListView: View {

    @StateObject var viewModel = TrendingNewsViewModel()
    var selectedLanguage: String
    var selectedTopics: String

    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    if let error = viewModel.errorMessage {
                        Text(error)
                            .foregroundColor(.red)
                            .padding()
                    }

                    ForEach(viewModel.latestArticles.indices, id: \.self) { index in
                        let article = viewModel.latestArticles[index]
                        NewsCardView(article: article)
                            .onAppear {
                                if viewModel.shouldLoadMore(currentIndex: index) {
                                    Task {
                                        await viewModel.fetchNews(language: selectedLanguage, topics: selectedTopics)
                                    }
                                }
                            }
                    }

                    if viewModel.isLoading {
                        HStack {
                            Spacer()
                            ProgressView()
                            Spacer()
                        }
                        .padding(.top)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                if viewModel.isFirstLoad {
                    await viewModel.fetchNews(language: selectedLanguage, topics: selectedTopics)
                    viewModel.isFirstLoad = false
                }
            }
        }
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
                Text("Trending")
                    .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                    .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
            }
        }
    }
}

#Preview {
    TrendingNewsListView(
        selectedLanguage: "en",
        selectedTopics: "technology"
    )
}
