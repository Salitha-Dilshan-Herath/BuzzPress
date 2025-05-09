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
    @AppStorage("isGuestUser") private var isGuestUser: Bool = false

    
    var body: some View {
        if isFirstLaunch {
            OnboardingCarouselView {
                isFirstLaunch = false
            }
        } else {
            if isLoggedIn {
                MainTabView()
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
