//
//  ContentView.swift
//  BuzzPress
//
//  Created by Spemai on 2025-04-06.
//

import SwiftUI
import CoreData

struct ContentView: View {

    var body: some View {
        VStack{
            Text("Hello World")
        }
    }
}


    
#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
