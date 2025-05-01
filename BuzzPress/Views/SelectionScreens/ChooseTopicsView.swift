//
//  ChooseTopicsView.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI

struct ChooseTopicsView: View {
    @StateObject private var viewModel = TopicViewModel()

    var body: some View {
        VStack {
            TextField("Search", text: $viewModel.searchText)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            WrapHStack(viewModel.filteredTopics, spacing: 10) { topic in
                Button(action: {
                    viewModel.toggleSelection(for: topic)
                }) {
                    Text(topic)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(viewModel.selectedTopics.contains(topic) ? Color.blue : Color.white)
                        .foregroundColor(viewModel.selectedTopics.contains(topic) ? .white : .blue)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.blue, lineWidth: 1)
                        )
                        .cornerRadius(8)
                }
            }
            .padding()

            Spacer()

            Button("Next") {
                print("Selected topics: \(viewModel.selectedTopics)")
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.horizontal)
        }
        .navigationTitle("Choose your Topics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct ChooseTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChooseTopicsView()
        }
    }
}
