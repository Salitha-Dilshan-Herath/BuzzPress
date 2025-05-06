//
//  ChooseTopicsView.swift
//  BuzzPress
//
//  Created by user269828 on 5/1/25.
//

import SwiftUI

struct ChooseTopicsView: View {
    let isGuest: Bool
    
    @StateObject private var viewModel = TopicViewModel()
    @Environment(\.presentationMode) var presentationMode
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("selectedTopic") private var selectedTopics: String = ""

    var body: some View {
        
        NavigationStack{
            VStack {
                // Topic selection UI
                WrapHStack(viewModel.allTopics, spacing: 10) { topic in
                    Button(action: {
                        selectedTopics = topic
                    }) {
                        Text(topic)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(selectedTopics == topic  ? Color.blue : Color.white)
                            .foregroundColor(selectedTopics == topic ? .white : .blue)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                            .cornerRadius(8)
                    }
                }
                .padding()
                
                Spacer()
                Button(action: {
                    
                    Task {
                        viewModel.selectedTopic = selectedTopics
                        if isGuest {
                            viewModel.saveSelectionForGuest()
                        } else {
                            await viewModel.saveSelection()
                            isLoggedIn = true
                        }
                    }
                }) {
                    
                    if viewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Next")
                            .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                            .foregroundColor(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(selectedTopics.isEmpty ? Color.gray : Color.blue)
                            .cornerRadius(10)
                    }
                }
                .padding()
                .disabled(selectedTopics.isEmpty)
                
            }.navigationBarTitleDisplayMode(.inline)
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
                    
                    ToolbarItem(placement: .principal) {
                        Text("Choose your Topics")
                            .font(Font.custom(Constants.FONT_SEMI_BOLD, size: 16))
                            .foregroundColor(Color(Constants.TITLE_TEXT_COLOR))
                    }
                }
        }.alert("Topic Save Failed", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

struct ChooseTopicsView_Previews: PreviewProvider {
    static var previews: some View {
        ChooseTopicsView(isGuest: false)
    }
}

