//
//  NewsRowView.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI

struct NewsRowView: View {
    let article: Article

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(8)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(article.source.name.uppercased())
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(article.title)
                    .font(.subheadline)
                    .lineLimit(2)

                HStack(spacing: 8) {
                    Text(article.source.name)
                        .font(.caption2)
                        .bold()
                        .foregroundColor(.red)
                    Text(publishedAgo(article.publishedAt))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
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
