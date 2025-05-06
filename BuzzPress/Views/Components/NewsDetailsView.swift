//
//  NewsDetailsView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-05.
//

import SwiftUI

struct NewsDetailsView: View{
    let article: Article
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel: NewsDetailViewModel
    @State private var isShowingComments = false

    init(article: Article) {
        self.article = article
        _viewModel = StateObject(wrappedValue: NewsDetailViewModel(articleId: article.id))
    }
    
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    
                    // Source info
                    HStack(spacing: 10) {
                        
                        if let url = URL(string: Constants.SOURCE_IMAGE_BASE_PATH + (Utility.extractDomain(urlString: article.url) ?? "")) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } placeholder: {
                                ProgressView()
                                    .padding()
                            }
                        }
                        
                        VStack(alignment: .leading) {
                            Text(article.source.name)
                                .font(.headline)
                            Text(Utility.publishedAgo(article.publishedAt))
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    
                    // Article image
                    if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(12)
                                .padding(.horizontal)
                        } placeholder: {
                            ProgressView()
                                .padding()
                        }
                    }else {
                        Image("ic-launch-screen")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    
                    // Title
                    Text(article.title)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    // Description
                    if let description = article.description {
                        Text(AttributedString(description))
                            .font(Font.custom(Constants.FONT_REGULAR, size: 16))
                            .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Content
                    if let content = article.content {
                        Text(AttributedString(content))
                            .font(Font.custom(Constants.FONT_REGULAR, size: 16))
                            .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    // Interaction buttons
                    HStack(spacing: 0) {
                        // Left Content (3 parts, aligned left)
                        HStack(spacing: 15) { // Adjust spacing between like buttons
                           
                            HStack(spacing: 5) {
                                Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                                    .font(.system(size: 20))
                                    .foregroundColor(.pink)
                                Text("\(viewModel.likeCount)")
                                    .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                                    .font(Font.custom(Constants.FONT_REGULAR, size: 20))
                            }
                            .onTapGesture {
                                Task {
                                    await viewModel.toggleLike()
                                }
                                
                            }
                            
                            HStack(spacing: 5) {
                                Image(systemName: "ellipsis.bubble")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                                Text("\(viewModel.commentCount)")
                                    .foregroundColor(Color(Constants.BODY_TEXT_COLOR))
                                    .font(Font.custom(Constants.FONT_REGULAR, size: 20))
                            }
                            .onTapGesture {
                                isShowingComments = true
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack {
                            Spacer()
                            Button(action: {
                                //isBookmarked.toggle()
                            }) {
                                Image(systemName: true ? "bookmark.fill" : "bookmark")
                                    .foregroundColor(.blue)
                                    .font(.system(size: 24))
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                }
            }.navigationBarTitleDisplayMode(.inline)
        }.task { 
            await viewModel.loadInitialData()
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                }
            }
        }.sheet(isPresented: $isShowingComments) {
            NewsCommentView(article: self.article)
                .navigationBarBackButtonHidden(true)
        }.onChange(of: isShowingComments) { oldValue, newValue in
            if oldValue == true && newValue == false {
                Task {
                    await viewModel.loadInitialData()
                }
            }
        }
    }
}
#Preview {
    NewsDetailsView(article: Article(source:
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
