//
//  ContentView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
//    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @Environment(\.modelContext) private var context
    @EnvironmentObject var routes: Routes
    @StateObject var locationManager = LocationManager()
    enum Tab: String {
        case dashboard = "Dashboard"
        case servis = "Service"
        case pengingat = "Pengingat"
    }
    
    @State private var selectedTab: Tab = .dashboard
    
    init(){
        setupNavigationBar()
    }
    var body: some View {
        NavigationStack (path: $routes.navPath) {
            TabView(selection: $selectedTab) {
                DashboardView(locationManager: locationManager).tabItem {
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
                        DashboardView(locationManager: locationManager)
                    case .AddServiceView:
                        AddServiceView()
                    case .NoServiceView:
                        NoServiceView()
                    }
                }
//                .environmentObject(routes)
        }.tint(.white)
            .onAppear {
                locationManager.setContext(context)
                       locationManager.startTracking()  // Start tracking the location and beacons
                   }
    }
}

