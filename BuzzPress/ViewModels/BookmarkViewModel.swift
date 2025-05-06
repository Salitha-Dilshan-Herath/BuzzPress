//
//  BookmarkViewModel.swift
//  BuzzPress
//
//  Created by user269828 on 5/6/25.
//

import Foundation

class BookmarkViewModel: ObservableObject {
    @Published var bookmarks: [BookmarkedNews] = []
    @Published var bookmarkedArticles: [Article] = []
    
    private let coreDataService: CoreDataService
        
    
    
    init(coreDataService: CoreDataService = CoreDataService.shared) async {
            self.coreDataService = coreDataService
        await loadBookmarks()
        }
        
    func loadBookmarks() async {
        let bookmarks = await coreDataService.fetchBookmarks()
            //bookmarkedArticles = bookmarks.map { $0.toArticle() }
        }

    func removeBookmark(url: String) {
        Task {
            await CoreDataService.shared.removeBookmark(withURL: url)
            await loadBookmarks()
        }
    }
}

