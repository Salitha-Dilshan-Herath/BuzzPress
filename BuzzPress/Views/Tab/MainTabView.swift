//
//  MainTabView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-03.
//

import SwiftUI

struct MainTabView: View {
    
    var selectedLanguage: String
    var selectedTopics: String
    var body: some View {
        TabView{
            HomePageView( selectedLanguage: selectedLanguage,
                          selectedTopics: selectedTopics)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "safari")
                }
            BookmarkView()
                .tabItem {
                    Label("Bookmark", systemImage: "bookmark")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                    
                }
        }.backgroundStyle(Color.white)
            .tabViewStyle(.automatic)
    }
}

#Preview {
    MainTabView(selectedLanguage: "en", selectedTopics: "Busisness")
}
