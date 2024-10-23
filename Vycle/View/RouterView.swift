////
////  RouterView.swift
////  Vycle
////
////  Created by Vincent Senjaya on 24/10/24.
////
//
//import SwiftUI
//
//struct RouterView: View {
//    @EnvironmentObject var routes: Routes
//    @Binding var odometer: Float?
//    var body: some View {
//        NavigationStack(path: $routes.navPath) { // Bind the navigation path here
//            DashboardView(locationManager: LocationManager()) // Initial view of the stack
//                .navigationDestination(for: Routes.Destination.self) { destination in
//                    // Handle navigation destinations here
//                    switch destination {
//                    case .DashboardView:
//                        DashboardView(locationManager: LocationManager(), odometer: $odometer)
//                    case .PengingatView:
//                        PengingatView(locationManager: LocationManager())
//                    case .ServisView:
//                        ServiceView()
//                    case .NoServiceView:
//                        NoServiceView()
//                    case .AllServiceHistoryView:
//                        AllServiceHistoryView()
//                    case .ServiceDetailView(let service):
//                        ServiceDetailView(service: s)
//                    case .AddServiceView(let service):
//                        AddServiceView(service: service)
//                    case .AddReminderView:
//                        AddReminderView(reminders: .constant([]))
//                    case .AllReminderView:
//                        AllReminderView()
//                    case .EditReminderView(let reminder):
//                        EditReminderView(reminder: .constant(reminder))
//                    case .PhotoReviewView(let imageData):
//                        PhotoReviewView(imageData: imageData)
//                    }
//                }
//        }
//    }
//}
