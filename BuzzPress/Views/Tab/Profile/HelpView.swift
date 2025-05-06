//
//  HelpView.swift
//  BuzzPress
//
//  Created by user269828 on 5/6/25.
//

import SwiftUI

struct HelpView: View {
    struct HelpItem: Identifiable {
        let id = UUID()
        let question: String
        let answer: String
    }

    private let helpItems: [HelpItem] = [
        HelpItem(question: "How do I bookmark an article?",
                 answer: "Tap the bookmark icon on any article to save it for later."),
        HelpItem(question: "Where can I find my bookmarks?",
                 answer: "Go to the 'Bookmarks' section from the main menu or bottom tab."),
        HelpItem(question: "Can I use the app without an account?",
                 answer: "Yes, you can use the app as a guest, but your data won't sync across devices."),
        HelpItem(question: "What is the difference between guest and logged-in users?",
                 answer: "Logged-in users can sync their preferences and bookmarks with Firebase, while guest users' data is stored only on the device."),
        HelpItem(question: "How do I change language or topics?",
                 answer: "Visit the 'Settings' or 'Preferences' section in your ProfileView.")
    ]

    var body: some View {
        NavigationView {
            List(helpItems) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.question)
                        .font(.headline)
                    Text(item.answer)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            .navigationTitle("Help & Support")
        }
    }
}
