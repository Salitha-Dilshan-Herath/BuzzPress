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
        NavigationStack {  // Changed from NavigationView to NavigationStack (iOS 16+)
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Trending Section
                    Text("Trending")
                        .font(Font.custom(Constants.FONT_BOLD, size: 16))
                        .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                    
                    if let article = viewModel.trendingArticle {
                        NavigationLink(destination: NewsDetailsView(article: article)
                            .navigationBarBackButtonHidden(true)) {
                            NewsCardView(article: article)
                                .padding(.bottom, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    // Latest Section
                    HStack {
                        Text("Latest")
                            .font(Font.custom(Constants.FONT_BOLD, size: 16))
                            .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                        Spacer()
                        
                        NavigationLink {
                            TrendingNewsListView(selectedLanguage: selectedLanguage, selectedTopics: selectedTopics)
                                .navigationBarBackButtonHidden(true)
                        } label: {
                            Text("See all")
                                .font(Font.custom(Constants.FONT_REGULAR, size: 14))
                                .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                        }
                    }
                    
                    ForEach(viewModel.latestArticles, id: \.id) { article in
                        NavigationLink(destination: NewsDetailsView(article: article)
                            .navigationBarBackButtonHidden(true)) {
                                NewsRowView(article: article)
                                .padding(.bottom, 8)
                        }
                        .buttonStyle(PlainButtonStyle())
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
        .task {  // Changed from onAppear to .task for async operations
            await viewModel.fetchNews(language: selectedLanguage, topics: selectedTopics)
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
