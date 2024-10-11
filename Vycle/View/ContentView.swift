//
//  ContentView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @StateObject var routes = Routes()
    
    var body: some View {
        NavigationStack (path: $routes.navPath) {
                TabView {
                    DashboardView().tabItem {
                        Image(systemName: "house.fill")
                        Text("Dashboard")
                    }
                    ServisView().tabItem {
                        Image(systemName: "list.bullet.rectangle.fill")
                        Text("Servis")
                    }
                    PengingatView().tabItem {
                        Image(systemName: "bell.fill")
                        Text("Pengingat")
                    }
                }
                .navigationDestination(for: Routes.Destination.self) { destination in
                    switch destination {
                    case .PengingatView:
                        PengingatView()
                    case .ServisView:
                        ServisView()
                    case .DashboardView:
                        DashboardView()
                    }
                    
                }
                .environmentObject(routes)
            }
    }
}

