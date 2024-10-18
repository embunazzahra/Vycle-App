//
//  Routes.swift
//  Vycle
//
//  Created by Vincent Senjaya on 10/10/24.
//


import SwiftUI

@Observable final class Routes: ObservableObject {
    var navPath = NavigationPath()
    

    public enum Destination : Hashable{
        case DashboardView, PengingatView, ServisView, NoServiceView, AllServiceHistoryView, ServiceDetailView(service: UserServiceHistory), AddServiceView(service: UserServiceHistory?), AddReminderView
    }
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }

    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
