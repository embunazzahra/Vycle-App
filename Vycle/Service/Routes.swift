//
//  Routes.swift
//  Vycle
//
//  Created by Vincent Senjaya on 10/10/24.
//


import SwiftUI

@Observable final class Routes: ObservableObject {
    var navPath = NavigationPath()
    
    
    public enum Destination: Hashable {
        case DashboardView
        case PengingatView
        case ServisView
        case NoServiceView
        case AllServiceHistoryView
        case ServiceDetailView(service: Servis)
        case AddServiceView(service: Servis?)
        case AddReminderView
        case AllReminderView
        case EditReminderView(reminder: Reminder)
        case PhotoReviewView(imageData: Data)
        case BeaconConfigView
        case GuideView
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
