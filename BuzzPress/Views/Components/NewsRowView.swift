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
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Color.gray.opacity(0.3)
                }
                .frame(width: 80, height: 80)
                .cornerRadius(8)
                .clipped()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(article.source.name.uppercased())
                    .font(Font.custom(Constants.FONT_REGULAR, size: 13))
                    .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                
                Text(article.title)
                    .font(Font.custom(Constants.FONT_REGULAR, size: 16))
                    .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                    .lineLimit(2)
                
                HStack(spacing: 8) {
                    Text(article.source.name)
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
    
    
}

struct NewsRowView_Previews: PreviewProvider {
    static var previews: some View {
        NewsCardView(article: Article(source:
                                        Source(id: "ds",
                                               name: "Yahoo Entertainment"),
                                      author: "Ian Casselberry",
                                      title: "NBA playoffs: Jalen Brunson scores 40, leading Knicks to 1st-round series win over Pistons - Yahoo Sports",
                                      description: "The Knicks will face the Celtics in the Eastern Conference semifinals.",
                                      url: "https://sports.yahoo.com/nba/article/nba-playoffs-jalen-brunson-hits-game-winning-3-pointer-to-close-out-knicks-first-round-series-win-over-pistons-023119818.html",
                                      urlToImage: "https://s.yimg.com/ny/api/res/1.2/mV18cqXJTRgeVMq5xOItZg--/YXBwaWQ9aGlnaGxhbmRlcjt3PTEyMDA7aD03NjI7Y2Y9d2VicA--/https://s.yimg.com/os/creatr-uploaded-images/2025-04/742da6d0-239a-11f0-bfbf-f875f294e3ea",
                                      publishedAt: "2025-05-02T02:42:00Z",
                                      content: "Jalen Brunson's 3-pointer from the top of the arc with 4.3 seconds remaining in regulation lifted the New York Knicks to a 116-113 win over the Detroit Pistons in Game 6 of their first-round NBA play… [+3903 chars]"))
    }
}
