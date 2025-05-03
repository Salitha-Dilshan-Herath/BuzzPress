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
    var selectedTopics: String
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Trending")
                        .font(Font.custom(Constants.FONT_BOLD, size: 16))
                        .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                    if let article = viewModel.trendingArticle {
                        NewsCardView(article: article)
                    }
                    
                    HStack {
                        Text("Latest")
                            .font(Font.custom(Constants.FONT_BOLD, size: 16))
                            .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                        Spacer()
                        Button(action: {
                            //Show all News
                        }) {
                            Text("See all")
                                .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                                .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                        }

                    }
                    
                    ForEach(viewModel.latestArticles) { article in
                        NewsRowView(article: article)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Image("ic-navigation")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 196, height: 32)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchNews(language: selectedLanguage, topics: selectedTopics)
            }
        }
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView(
            selectedLanguage: "en",
            selectedTopics: "technology"
        )
    }
}
