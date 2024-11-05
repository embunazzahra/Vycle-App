//
//  UserDefaultsManager.swift
//  Vycle
//
//  Created by Vincent Senjaya on 05/11/24.
//


import Foundation
import ActivityKit


struct UserDefaultsManager {
    
    static func saveNewActivity(connectionStatus: String) {
        
        let activity =
        [
            "connectionStatus": connectionStatus
        ]
        
        if var activities: [[String: Any]] = UserDefaults.standard.object(forKey: "live_activities") as? [[String: String]] 
        {
            activities.append(activity)
            UserDefaults.standard.set(activities, forKey: "live_activities")
        } else {
            UserDefaults.standard.set([activity], forKey: "live_activities")
        }
    }
    
    static func fetchActivities() -> [BeaconAttribute.ContentState] {
        
        guard let activities: [[String: String]] = UserDefaults.standard.object(forKey: "live_activities") as? [[String: String]] else {return []}
        
        return activities.compactMap ({
            BeaconAttribute.ContentState(connectionStatus: $0["connectionStatus"] ?? "")
        })
    }
    
    
}
