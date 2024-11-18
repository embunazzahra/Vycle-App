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
    @StateObject var locationManager = LocationManager() // @StateObject for lifecycle management
    @State private var isShowSplash = true
    enum Tab: String {
        case dashboard = "Dashboard"
        case servis = "Servis"
        case pengingat = "Pengingat"
    }
    @State private var selectedTab: Tab = .dashboard
    @Query(sort: \Vehicle.vehicleID) var vehicleData: [Vehicle]
    @State private var odometer: Float? = nil
    @State private var reminders: [Reminder] = []
    @Query var services : [Servis]
    @Query var fetchedReminders: [Reminder]
    @State private var uniqueSparePartCount: Int = 0
    @State private var vBeaconID: String = ""
    @AppStorage("hasNewNotification") var hasNewNotification: Bool = false{
        didSet {
            print("notif in contentview\(hasNewNotification)")
        }
    }
    @AppStorage("onBoardingDataSaved") private var onBoardingDataSaved: Bool = false
    @State private var tabReminder : Bool = false
    
    init() {
        setupNavigationBarWithoutScroll()
        setupTabBarBorderLine()
    }
    
    var body: some View {
        NavigationStack(path: $routes.navPath) {
            if isShowSplash {
                SplashView(isShowSplash: $isShowSplash)
            } else {
                if !onBoardingDataSaved {
                    OnBoardingView(
                        locationManager: locationManager,
                        odometer: $odometer,
                        vBeaconID: $vBeaconID,
                        onBoardingDataSaved: $onBoardingDataSaved
                    )
                    .onAppear(){
                        selectedTab = .servis
                    }
                } else {
                    TabView(selection: $selectedTab) {
                        DashboardView(locationManager: locationManager, tabReminder: $tabReminder).tabItem {
                            Image(selectedTab == .dashboard ? "dashboard_icon_blue" : "dashboard_icon")
                            Text("Dashboard")
                        }.tag(Tab.dashboard)
                        ServiceView().tabItem {
                            Image(selectedTab == .servis ? "service_icon_blue" : "service_icon")
                            Text("Servis")
                        }.tag(Tab.servis)
                        ReminderView(locationManager: locationManager).tabItem {
                            Image(
                                selectedTab == .pengingat
                                ? (hasNewNotification ? "reminder_icon_blue_notif" : "reminder_icon_blue")
                                : (hasNewNotification ? "reminder_icon_notif" : "reminder_icon")
                            )
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
                                DashboardView(locationManager: locationManager, tabReminder: $tabReminder)
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
                                case .BeaconConfigView:
                                    BeaconConfigView(locationManager: locationManager)
                                case .GuideView:
                                    GuideView()
                                case .ReminderView:
                                    ReminderView(locationManager: locationManager)
                                case .DataSummaryView:
                                    DataSummaryView()
                                case .ShareSummaryView(let totalMileage,
                                                   let uniqueSpareParts,
                                                   let totalCost, let dateRange):
                                    ShareSummaryView(totalMileage: totalMileage,
                                                 uniqueSpareParts: uniqueSpareParts,
                                                     totalCost: totalCost, dateRange: dateRange)
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
        }
        .transition(.backslide)
        .animation(.easeInOut, value: onBoardingDataSaved)
        .tint(.white)
        .onAppear {
            locationManager.setContext(context)
            locationManager.startTracking()
            fetchAndCountUniqueSpareParts()
            
        }
        .onChange(of: tabReminder){
            selectedTab = .pengingat
        }
        .onChange(of: fetchedReminders) {
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
    
    private func setupTabBarBorderLine() {
        let image = UIImage.gradientImageWithBounds(
            bounds: CGRect( x: 0, y: 0, width: UIScreen.main.scale, height:3),
            colors: [
                UIColor.clear.cgColor,
                UIColor.black.withAlphaComponent(0.2).cgColor
            ]
        )

        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = UIColor.systemGray6
                
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = image

        UITabBar.appearance().standardAppearance = appearance
    }
    
    
}

