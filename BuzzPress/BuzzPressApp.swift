//
//  BuzzPressApp.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-06.
//

import SwiftUI

@main
struct BuzzPressApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
