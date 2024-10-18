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
    @Environment(\.modelContext) private var context
    @EnvironmentObject var routes: Routes
    @StateObject var locationManager = LocationManager()
    enum Tab: String {
        case dashboard = "Dashboard"
        case servis = "Servis"
        case pengingat = "Pengingat"
    }
    
    @State private var selectedTab: Tab = .dashboard
    @State private var reminders: [SparepartReminder] = []
    @Query var services : [Servis]
    
    
    init(){
        setupNavigationBarWithoutScroll()
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
                        DashboardView(locationManager: locationManager)
                    case .AddServiceView(let service):
                        AddServiceView(service: service)
                    case .NoServiceView:
                        NoServiceView()
                    case .AllServiceHistoryView:
                        AllServiceHistoryView()
                    case .ServiceDetailView(let service):
                        ServiceDetailView(service: service)
                    case .AddReminderView:
                        AddReminderView(reminders: $reminders)
                    }
                }
                .toolbar {
                    ToolbarItem {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(Color.white)
                                .onTapGesture {
                                    if (selectedTab == .pengingat) {
                                        routes.navigate(to: .AddReminderView)
                                    }
                                    else if (selectedTab == .servis){
                                        routes.navigate(to: .AddServiceView(service: nil))
                                    }
                                }
                                .opacity((selectedTab == .servis && !services.isEmpty) || (selectedTab == .pengingat) ? 1 : 0)
                                .disabled((selectedTab == .servis && !services.isEmpty) || (selectedTab == .pengingat) ? false : true)
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

