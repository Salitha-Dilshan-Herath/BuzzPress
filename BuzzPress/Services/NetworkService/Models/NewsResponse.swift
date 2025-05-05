//
//  Untitled.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-02.
//


import Foundation
import CryptoKit

// MARK: - Welcome
struct NewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [Article]
}

// MARK: - Article
struct Article: Codable, Identifiable {
    var id: String {
        // Combine key fields that make an article unique
        let uniqueString = "\(url)-\(publishedAt)"
        
        // Compute SHA256 hash (deterministic)
        let data = Data(uniqueString.utf8)
        let hash = SHA256.hash(data: data)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

// MARK: - Source
struct Source: Codable {
    let id: String?
    let name: String
}
