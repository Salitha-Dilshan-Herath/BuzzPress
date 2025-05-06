//
//  ContentView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = true
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("selectedLanguage") private var selectedLanguage: String = ""
    @AppStorage("selectedTopic") private var selectedTopic: String = ""
    
    
    var body: some View {
        if isFirstLaunch {
            OnboardingCarouselView {
                isFirstLaunch = false
            }
        } else {
            if isLoggedIn {
                MainTabView(
                    selectedLanguage: selectedLanguage,
                    selectedTopics: selectedTopic
                )
            } else {
                NavigationStack {
                    LoginView()
                }
                
            }
        }
    }
}



#Preview {
    ContentView()
}
