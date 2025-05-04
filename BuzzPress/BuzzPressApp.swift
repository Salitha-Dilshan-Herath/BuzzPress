//
//  BuzzPressApp.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-06.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}


@main
struct BuzzPressApp: App {
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State private var showOnboarding = UserDefaults.isFirstLaunch
    
    var body: some Scene {
        WindowGroup {
            if showOnboarding {
                OnboardingCarouselView {
                    UserDefaults.isFirstLaunch = false
                    showOnboarding = false
                }
            } else {
                
                    LoginView()
                
            }
            
        }
    }
}
