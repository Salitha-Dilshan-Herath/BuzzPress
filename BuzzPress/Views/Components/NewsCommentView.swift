//
//  NewsCommentView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-05.
//

import SwiftUI

struct NewsCommentView: View {
    let article: Article
    @StateObject private var viewModel: CommentViewModel
    
    @State private var commentText: String = ""
    
    init(article: Article) {
        self.article = article
        _viewModel = StateObject(wrappedValue: CommentViewModel(articleId: article.id))
    }
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Text("Comments")
                    .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                    .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
            }
            .padding()
            
            // Comment List
            ScrollView {
                if viewModel.comments.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "text.bubble")
                                .font(.system(size: 40))
                                .foregroundColor(.gray)
                            
                            Text("No comments available")
                                .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity, minHeight: 200)
                        .padding()
                    } else {
                        LazyVStack(alignment: .leading, spacing: 20) {
                            ForEach(viewModel.comments) { comment in
                                HStack(alignment: .top, spacing: 12) {
                                    Image(systemName: comment.userImage)
                                        .resizable()
                                        .frame(width: 40, height: 40)
                                        .clipShape(Circle())
                                        .foregroundColor(.gray)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(comment.name)
                                            .fontWeight(.semibold)
                                        Text(comment.comment)
                                            .foregroundColor(.gray)
                                            .font(.subheadline)
                                        Text(comment.timeAgo)
                                            .foregroundColor(.gray)
                                            .font(.caption)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
            }
            
            // Comment Input
            HStack {
                TextField("Type your comment", text: $commentText)
                    .font(Font.custom(Constants.FONT_REGULAR, size: 14)) //
                    .padding(10)
                    .background(Color(UIColor.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(UIColor.systemBackground), lineWidth: 1)
                    )
                
                Button(action: {
                    // Send comment
                    if !commentText.isEmpty {
                        Task {
                            await viewModel.addComment(text: commentText)
                            commentText = ""
                        }
                        
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color(UIColor.systemBackground))
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(12)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 5,
                x: 0,
                y: 2
            )
        }.task {
            await viewModel.loadInitialData()
        }
    }
}

#Preview {
    NewsCommentView(article: Article(source:
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
