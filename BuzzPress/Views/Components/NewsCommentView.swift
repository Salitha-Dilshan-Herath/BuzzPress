//
//  NewsCommentView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-05-05.
//

import SwiftUI

struct NewsCommentView: View {
    @ObservedObject private var keyboard = KeyboardResponder()
    @State private var commentText: String = ""
    @State private var comments: [NewsComment] = [
        NewsComment(userImage: "person.crop.circle", name: "Wilson Franci", comment: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", timeAgo: "4w"),
        NewsComment(userImage: "person.2.circle", name: "Marley Botosh", comment: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", timeAgo: "4w"),
        NewsComment(userImage: "person.crop.circle.fill", name: "Alfonso Septimus", comment: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", timeAgo: "4w"),
        NewsComment(userImage: "person.crop.circle.badge.checkmark", name: "Omar Herwitz", comment: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", timeAgo: "4w"),
        NewsComment(userImage: "person.crop.circle.fill.badge.exclam", name: "Corey Geidt", comment: "Lorem Ipsum is simply dummy text of the printing and typesetting industry.", timeAgo: "4w")
    ]
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Button(action: {
                    // Handle back
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Comments")
                    .font(.headline)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "ellipsis")
                    .foregroundColor(.clear)
            }
            .padding()
            
            // Comment List
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(comments) { comment in
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
            
            // Comment Input
            HStack {
                TextField("Type your comment", text: $commentText)
                    .padding(10)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {
                    // Send comment
                    if !commentText.isEmpty {
                        comments.append(NewsComment(userImage: "person.crop.circle", name: "You", comment: commentText, timeAgo: "Now"))
                        commentText = ""
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(10)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .padding(.bottom, keyboard.currentHeight)
        .animation(.easeOut(duration: 0.25), value: keyboard.currentHeight)
    }
}

#Preview {
    NewsCommentView()
}
