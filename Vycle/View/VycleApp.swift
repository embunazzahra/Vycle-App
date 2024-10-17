//
//  VycleApp.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import SwiftData

@main
struct VycleApp: App {
    @StateObject var routes = Routes()
    
    var sharedModelContainer: ModelContainer = {
         let schema = Schema([
            Servis.self,
            Odometer.self,
            LocationHistory.self,
            Trip.self,
            Vehicle.self,
            Reminder.self,
         ])
         let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
         
         do {
             return try ModelContainer(for: schema, configurations: [modelConfiguration])
         } catch {
             fatalError("Could not create ModelContainer: \(error)")
         }
     }()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(routes)
                .modelContainer(sharedModelContainer)
        }
    }
}
