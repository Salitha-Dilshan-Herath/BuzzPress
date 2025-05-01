//
//  Article.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import Foundation

struct NewsResponse: Decodable {
    let articles: [Article]
}

struct Article: Decodable, Identifiable {
    let id = UUID()
    let source: Source
    let author: String?
    let title: String
    let description: String?
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String?
}

struct Source: Decodable {
    let name: String
}
