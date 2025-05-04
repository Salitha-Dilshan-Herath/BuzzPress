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
            }else{
                Image("ic-launch-screen")
                    .resizable()
                    .frame(height: 200)
                    .cornerRadius(12)
            }

            Text(article.source.name.uppercased())
                .font(Font.custom(Constants.FONT_REGULAR, size: 13))
                .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
            Text(article.title)
                .font(Font.custom(Constants.FONT_REGULAR, size: 16))
                .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                .lineLimit(2)

            HStack(spacing: 8) {
                Text(article.author ?? "")
                    .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 13))
                    .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                Image(systemName: "clock")
                    .imageScale(.small)
                Text(Utility.publishedAgo(article.publishedAt))
                    .font(.caption2)
                    .foregroundColor(.gray)
            } 
        }
    }
}

struct NewsCardView_Previews: PreviewProvider {
    static var previews: some View {
        NewsCardView(article: Article(source: Source(id: "ds", name: "ded"), author: "dwed", title: "deed", description: "ded", url: "ded", urlToImage: "ded", publishedAt: "2025-05-02T02:42:00Z", content: "ded"))
    }
}
