//
//  LiveActivityManager.swift
//  Vycle
//
//  Created by Vincent Senjaya on 05/11/24.
//
import Foundation
import ActivityKit

class LiveActivityManager {
    
    @discardableResult
    static func startActivity(connectionStatus: String) throws -> String {
       
        var activity: Activity<BeaconAttribute>?
        let initialState =  BeaconAttribute.ContentState(connectionStatus: "True")
        
        do {
            activity = try Activity.request(attributes: BeaconAttribute(), contentState: initialState, pushType: nil)
            
            guard let id = activity?.id else { throw
                LiveActivityErrorType.failedToGetID }
            return id
        } catch {
            throw error
        }
    }
        
    static func listAllActivities() -> [[String:String]] {
        let sortedActivities = Activity<BeaconAttribute>.activities.sorted{ $0.id > $1.id }
        
        return sortedActivities.map {
            [
                "connectionStatus": $0.contentState.connectionStatus
            ]
        }
    }
    
    static func endAllActivities() async {
        for activity in Activity<BeaconAttribute>.activities {
            await activity.end(dismissalPolicy: .immediate)
        }
    }
    
    static func endActivity(_ id: String) async {
        await Activity<BeaconAttribute>.activities.first(where: {
            $0.id == id
        })?.end(dismissalPolicy: .immediate)
    }
    
    static func updateActivity(id: String, arrivalTime: String, phoneNumber: String, restaurantName: String, customerAddress: String, remainingDistnace: String) async {
        
        let updatedContentState = BeaconAttribute.ContentState(connectionStatus: "True")
        
        let activity = Activity<BeaconAttribute>.activities.first(where: { $0.id == id })
        
        await activity?.update(using: updatedContentState)
    }
    
}

enum LiveActivityErrorType: Error {
    case failedToGetID
}
