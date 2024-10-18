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
        case servis = "Servis"
        case pengingat = "Pengingat"
    }
    
    @State private var selectedTab: Tab = .dashboard
    
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
                    PengingatView().tabItem {
                        Image(systemName: "bell.fill")
                        Text("Pengingat")
                    }.tag(Tab.pengingat)
                
            }.tint(.blue)
            .navigationTitle(selectedTab.rawValue)
                .navigationDestination(for: Routes.Destination.self) { destination in
                    switch destination {
                    case .PengingatView:
                        PengingatView()
                    case .ServisView:
                        ServiceView()
                    case .DashboardView:
                        DashboardView()
                    case .AddServiceView(let service):
                        AddServiceView(service: service)
                    case .NoServiceView:
                        NoServiceView()
                    case .AllServiceHistoryView:
                        AllServiceHistoryView()
                    case .ServiceDetailView(let service):
                        ServiceDetailView(service: service)
                    }
                }
                
//                .environmentObject(routes)
        }.tint(.white)
    }
}

