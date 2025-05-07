//
//  HomePageView.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI

struct HomePageView: View {
    @StateObject var viewModel = NewsViewModel()
    @AppStorage("selectedLanguage") private var selectedLanguage: String = ""
    @AppStorage("selectedTopic") private var selectedTopic: String = ""
    @AppStorage("darkModeEnabled") private var darkModeEnabled: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                // Empty State (No News)
                if !viewModel.isLoading && viewModel.trendingArticle == nil && viewModel.latestArticles.isEmpty {
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
                    // Normal Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            
                            // Trending Section
                            Text("Trending")
                                .font(.headline)
                            
                            if let article = viewModel.trendingArticle {
                                NavigationLink(destination: NewsDetailsView(article: article).navigationBarBackButtonHidden(true)) {
                                    NewsCardView(article: article)
                                        .padding(.bottom, 8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Latest Section
                            HStack {
                                Text("Latest")
                                    .font(.headline)
                                Spacer()
                                
                                NavigationLink {
                                    TrendingNewsListView(selectedLanguage: selectedLanguage, selectedTopics: selectedTopic)
                                        .navigationBarBackButtonHidden(true)
                                } label: {
                                    Text("See all")
                                }
                            }
                            
                            ForEach(viewModel.latestArticles, id: \.id) { article in
                                NavigationLink(destination: NewsDetailsView(article: article).navigationBarBackButtonHidden(true)) {
                                    NewsRowView(article: article).padding(.bottom, 8)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                        .padding()
                    }.refreshable {
                        await viewModel.fetchNews(language: selectedLanguage, topics: selectedTopic)
                    }
                }
                
                // Loading Overlay
                if viewModel.isLoading {
                    ZStack {
                        Color(.systemBackground).opacity(0.5).ignoresSafeArea()
                        
                        ProgressView("Loading News...")
                            .foregroundColor(.primary)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemBackground))
                                    .shadow(radius: 5)
                            )
                    }
                }
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
        .task {
            await viewModel.fetchNews(language: selectedLanguage, topics: selectedTopic)
        }.preferredColorScheme(darkModeEnabled ? .dark : .light)
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
