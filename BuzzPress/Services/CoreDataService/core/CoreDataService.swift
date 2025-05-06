//
//  CoreDataService.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-06.
//

import Foundation
import CoreData

protocol CoreDataServiceProtocol {
    func cacheNews(query: String, page: Int, pageSize: Int, data: NewsResponse) async
    func fetchNews(query: String) async -> CachedNews?
    func invalidateCache(withPrefix prefix: String) async
    func invalidateCache(query: String) async
    func clearAllCache() async
}

actor CoreDataService: CoreDataServiceProtocol {
    static let shared = CoreDataService()
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: "BuzzPress")
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        self.persistentContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    private var context: NSManagedObjectContext {
        let context = persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        return context
    }
    
    func cacheNews(query: String, page: Int, pageSize: Int, data: NewsResponse) async {
        await performContextOperation { context in
            // First, remove any existing cache for this query
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CachedNews.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "query == %@", query)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(deleteRequest)
                
                // Then create new cache entry
                let cache = CachedNews(context: context)
                cache.page = Int64(page)
                cache.pageSize = Int64(pageSize)
                cache.query = query
                cache.data = try JSONEncoder().encode(data)
                cache.expireTime = Date().addingTimeInterval(600) // 10 minutes
                
                try context.save()
                
                print("Save success \(query)")
            } catch {
                print("Failed to cache news: \(error)")
            }
        }
    }
    
    func fetchNews(query: String) async -> CachedNews? {
        await performContextOperation { context in
            let request: NSFetchRequest<CachedNews> = CachedNews.fetchRequest()
            request.predicate = NSPredicate(format: "query == %@", query)
            request.fetchLimit = 1
            
            do {
                let result = try context.fetch(request).first
                print("dev test: \(result?.expireTime)")
                return result
            } catch {
                print("Failed to fetch cached news: \(error)")
                return nil
            }
        }
    }
    
    func saveBookmark(_ article: Article) async {
        await performContextOperation{ context in
            let bookmark = BookmarkedNews(context: context)
            bookmark.title = article.title
            bookmark.url = article.url
            bookmark.publishedAt = article.publishedAt
            bookmark.source = article.source.name
            bookmark.imageURL = article.urlToImage
        
            do{
                try context.save()
                print("##CoreDataService## saveBookmark: Bookmark saved")
            } catch {
                print("##CoreDataService## saveBookmard: Failed to save bookmark - \(error)")
            }
        }
    }
    
    func fetchBookmarks() async -> [BookmarkedNews] {
        await performContextOperation { context in
            let request: NSFetchRequest<BookmarkedNews> = BookmarkedNews.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: false)]
            do {
                return try context.fetch(request)
            } catch {
                print("##CoreDataService## fetchBookmarks: Failed to fetch bookmarks: \(error)")
                return []
            }
        }
    }
    
    func removeBookmark(withURL url: String) async {
        await performContextOperation { context in
            let request: NSFetchRequest<BookmarkedNews> = BookmarkedNews.fetchRequest()
            request.predicate = NSPredicate(format: "url == %@", url)
            request.fetchLimit = 1
            do {
                if let bookmark = try context.fetch(request).first {
                    context.delete(bookmark)
                    try context.save()
                }
            } catch {
                print("Failed to remove bookmark: \(error)")
            }
        }
    }
    
    func isBookmarked(url: String) async -> Bool {
        await performContextOperation { context in
            let request: NSFetchRequest<BookmarkedNews> = BookmarkedNews.fetchRequest()
            request.predicate = NSPredicate(format: "url == %@", url)
            return (try? context.count(for: request)) ?? 0 > 0
        }
        return false
    }
    
    
    func invalidateCache(withPrefix prefix: String) async {
        await performContextOperation { context in
            let request: NSFetchRequest<NSFetchRequestResult> = CachedNews.fetchRequest()
            request.predicate = NSPredicate(format: "query BEGINSWITH %@", prefix)
            
            do {
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("Failed to invalidate cache with prefix: \(error)")
            }
        }
    }
    
    func invalidateCache(query: String) async {
        await performContextOperation { context in
            let request: NSFetchRequest<NSFetchRequestResult> = CachedNews.fetchRequest()
            request.predicate = NSPredicate(format: "query == %@", query)
            
            do {
                let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("Failed to invalidate cache: \(error)")
            }
        }
    }
    
    func clearAllCache() async {
        await performContextOperation { context in
            let request: NSFetchRequest<NSFetchRequestResult> = CachedNews.fetchRequest()
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
            
            do {
                try context.execute(deleteRequest)
                try context.save()
            } catch {
                print("Failed to clear all cache: \(error)")
            }
        }
    }
    
    
    
    private func performContextOperation<T>(_ operation: @escaping (NSManagedObjectContext) throws -> T) async rethrows -> T {
        let context = self.context
        return try await context.perform {
            try operation(context)
        }
    }
}
