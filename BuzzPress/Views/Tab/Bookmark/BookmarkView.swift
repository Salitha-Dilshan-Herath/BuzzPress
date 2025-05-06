//
//  BookmarkView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-03.
//

import SwiftUICore
import SwiftUI

struct BookmarkView: View {
    @StateObject private var viewModel = BookmarkViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.bookmarks.filter {
                    searchText.isEmpty ? true : $0.title?.lowercased().contains(searchText.lowercased()) == true
                }) { bookmark in
                    NewsRowView(article: bookmark.toArticle())
                }
            }
            .listStyle(.plain)
            .navigationTitle("Bookmark")
            .searchable(text: $searchText)
            .onAppear {
                viewModel.loadBookmarks()
            }
        }
    }
}


