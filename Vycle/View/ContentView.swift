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
    
    var body: some View {
        TabView {
            DashboardView().tabItem {
                Image(systemName: "house.fill")
                Text("Dashboard")
            }
            ServiceView().tabItem {
                Image(systemName: "list.bullet.rectangle.fill")
                Text("Servis")
            }
            PengingatView().tabItem {
                Image(systemName: "bell.fill")
                Text("Pengingat")
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
