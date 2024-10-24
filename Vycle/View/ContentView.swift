//
//  ContentView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var context
    @EnvironmentObject var routes: Routes
    @StateObject var locationManager = LocationManager()
    @Query(sort: \Vehicle.vehicleID) var vehicleData: [Vehicle]
    enum Tab: String {
        case dashboard = "Dashboard"
        case servis = "Servis"
        case pengingat = "Pengingat"
    }
    @State private var odometer: Float? = nil
    @State private var isShowSplash = true
    @State private var selectedTab: Tab = .dashboard
    @State private var reminders: [Reminder] = []
    @Query var services : [Servis]
    @Query var fetchedReminders: [Reminder]
    @State private var uniqueSparePartCount: Int = 0
    
    init() {
        setupNavigationBarWithoutScroll()
    }
    
    var body: some View {
        NavigationStack(path: $routes.navPath) {
            if isShowSplash {
                SplashView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            withAnimation {
                                isShowSplash = false
                            }
                        }
                    }
            } else if vehicleData.isEmpty {
                OnBoardingView(odometer: $odometer)
            } else {
                TabView(selection: $selectedTab) {
                    DashboardView(locationManager: locationManager).tabItem {
                        Image(selectedTab == .dashboard ? "dashboard_icon_blue" : "dashboard_icon")
                        Text("Dashboard")
                    }.tag(Tab.dashboard)
                    ServiceView().tabItem {
                        Image(selectedTab == .servis ? "service_icon_blue" : "service_icon")
                        Text("Servis")
                    }.tag(Tab.servis)
                    PengingatView(locationManager: locationManager).tabItem {
                        Image(selectedTab == .pengingat ? "reminder_icon_blue" : "reminder_icon")
                        Text("Pengingat")
                    }.tag(Tab.pengingat)
                    
                    
                }.tint(Color.primary.shade200)
                    .navigationTitle(selectedTab.rawValue)
                    .navigationDestination(for: Routes.Destination.self) { destination in
                        switch destination {
                        case .PengingatView:
                            PengingatView(locationManager: locationManager)
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
                        case .AllReminderView:
                            AllReminderView()
                        case .EditReminderView(let reminder):
                            EditReminderView(reminder: .constant(reminder))
                        case .PhotoReviewView(let imageData):
                            PhotoReviewView(imageData: imageData)
                        }
                    }
                
                    .toolbar {
                        ToolbarItem {
                            Image(systemName: "plus.square.fill")
                                .foregroundColor(.white)
                                .onTapGesture {
                                    if selectedTab == .pengingat {
                                        routes.navigate(to: .AddReminderView)
                                    } else if selectedTab == .servis {
                                        routes.navigate(to: .AddServiceView(service: nil))
                                    }
                                }
                                .opacity((selectedTab == .servis && !services.isEmpty) || (selectedTab == .pengingat && !fetchedReminders.isEmpty && uniqueSparePartCount < 9) ? 1 : 0)
                                .disabled((selectedTab == .servis && !services.isEmpty) || (selectedTab == .pengingat && !fetchedReminders.isEmpty && uniqueSparePartCount < 9) ? false : true)
                        }
                    }
            }
        }
        
        .tint(.white)
        .onAppear {
            locationManager.setContext(context)
            locationManager.startTracking()
            fetchAndCountUniqueSpareParts()
        }
        .onChange(of: fetchedReminders) { _ in
            fetchAndCountUniqueSpareParts()
        }
        /*.environmentObject(locationManager) */ // Provide LocationManager as EnvironmentObject
    }
    
    private func fetchAndCountUniqueSpareParts() {
        var uniqueSpareParts: Set<String> = []
        for reminder in fetchedReminders {
            let sparePartName = reminder.sparepart.rawValue
            uniqueSpareParts.insert(sparePartName)
        }
        uniqueSparePartCount = uniqueSpareParts.count
        
        print(uniqueSparePartCount)
    }

}

