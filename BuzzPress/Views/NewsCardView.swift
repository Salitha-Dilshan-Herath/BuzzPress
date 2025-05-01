//
//  NewsCardView.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI

struct NewsCardView: View {
    let article: Article

    var body: some View {
        VStack(alignment: .leading) {
            if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(height: 200)
                .cornerRadius(12)
            }

            Text(article.source.name.uppercased())
                .font(.caption)
                .foregroundColor(.secondary)

            Text(article.title)
                .font(.headline)
                .lineLimit(2)

            HStack(spacing: 10) {
                Text(article.source.name)
                    .font(.caption)
                    .bold()
                    .foregroundColor(.red)
                Text(publishedAgo(article.publishedAt))
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }

    func publishedAgo(_ isoDate: String) -> String {
        let formatter = ISO8601DateFormatter()
        if let date = formatter.date(from: isoDate) {
            let diff = Int(Date().timeIntervalSince(date) / 60)
            return "\(diff)m ago"
        }
        return ""
    }
}
