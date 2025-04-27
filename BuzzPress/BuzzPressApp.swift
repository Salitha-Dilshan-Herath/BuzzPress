//
//  BuzzPressApp.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-06.
//

import SwiftUI

@main
struct BuzzPressApp: App {
    @State private var showOnboarding = UserDefaults.isFirstLaunch
    
    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingCarouselView {
                    UserDefaults.isFirstLaunch = false
                    showOnboarding = false
                }
            } else {
                ContentView()
            }
            
        }
    }
}
