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
//    @StateObject var routes = Routes()
    @EnvironmentObject var routes: Routes
    enum Tab: String {
        case dashboard = "Dashboard"
        case servis = "Service"
        case pengingat = "Pengingat"
    }
    
    @State private var selectedTab: Tab = .dashboard
    @State private var reminders: [SparepartReminder] = []
    
    init(){
        setupNavigationBar()
    }
    var body: some View {
        NavigationStack (path: $routes.navPath) {
            TabView(selection: $selectedTab) {
                    DashboardView().tabItem {
                        Image(systemName: "house.fill")
                        Text("Dashboard")
                    }.tag(Tab.dashboard)
                    ServiceView().tabItem {
                        Image(systemName: "list.bullet.rectangle.fill")
                        Text("Servis")
                    }.tag(Tab.servis)
                PengingatView(reminders: reminders).tabItem {
                        Image(systemName: "bell.fill")
                        Text("Pengingat")
                    }.tag(Tab.pengingat)
                
            }.tint(.blue)
            .navigationTitle(selectedTab.rawValue)
                .navigationDestination(for: Routes.Destination.self) { destination in
                    switch destination {
                    case .PengingatView:
                        PengingatView(reminders: reminders)
                    case .ServisView:
                        ServiceView()
                    case .DashboardView:
                        DashboardView()
                    case .AddServiceView:
                        AddServiceView()
                    case .NoServiceView:
                        NoServiceView()
                    case .AddReminderView:
                        AddReminderView(reminders: $reminders)
                    }
                }
                
//                .environmentObject(routes)
        }.tint(.white)
    }
}

