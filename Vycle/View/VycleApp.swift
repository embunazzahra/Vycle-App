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
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject var routes = Routes()
    @StateObject var popUpControl: PopUpHelper = PopUpHelper()
    
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
            ZStack {
                ContentView()
                    .environmentObject(routes)
                    .environmentObject(popUpControl)
                    .modelContainer(SwiftDataService.shared.modelContainer)
                    .preferredColorScheme(.light)
                
                if popUpControl.showPopUp {
                    Color.black.opacity(0.6)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .ignoresSafeArea()
                    PopUpMessage(
                        type: popUpControl.popUpType,
                        isShowingPopUp: $popUpControl.showPopUp,
                        action: popUpControl.popUpAction
                    )
                    .transition(.opacity)
                }
            }
        }
    }
}
