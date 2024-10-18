//
//  Routes.swift
//  Vycle
//
//  Created by Vincent Senjaya on 10/10/24.
//


import SwiftUI

@Observable final class Routes: ObservableObject {
    var navPath = NavigationPath()
    
    public enum Destination {
        case DashboardView, PengingatView, ServisView, AddServiceView, NoServiceView, AddReminderView, AllReminderView
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
