//
//  HomePageView.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI

struct HomePageView: View {
    @StateObject var viewModel = NewsViewModel()
    var selectedLanguage: String
    var selectedTopics: [String]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Trending").font(.title2).bold()
                    if let article = viewModel.trendingArticle {
                        NewsCardView(article: article)
                    }

                    HStack {
                        Text("Latest").font(.title2).bold()
                        Spacer()
                        Button("See all") {
                            // Add navigation to all articles if needed
                        }
                    }

                    ForEach(viewModel.latestArticles) { article in
                        NewsRowView(article: article)
                    }
                }
                .padding()
            }
            .navigationBarTitle("BUZZPRESS", displayMode: .inline)
        }
        .onAppear {
            viewModel.fetchNews(language: selectedLanguage, topics: selectedTopics)
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
            HomePageView(
                selectedLanguage: "en",
                selectedTopics: ["technology", "sports"]
            )
        }
}
