//
//  ContentView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-06.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @AppStorage("isFirstLaunch") private var isFirstLaunch: Bool = false
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @AppStorage("selectedLanguage") private var selectedLanguage: String = ""
    @AppStorage("selectedTopics") private var selectedTopics: String = ""

    
    var body: some View {
        if isFirstLaunch {
            OnboardingCarouselView {
                isFirstLaunch = false  // This will automatically update UserDefaults
            }
        } else {
            if isLoggedIn {
                MainTabView(
                    selectedLanguage: selectedLanguage,
                    selectedTopics: selectedTopics
                )
            } else {
                LoginView()
            }
        }
    }
}



#Preview {
    ContentView()
}
