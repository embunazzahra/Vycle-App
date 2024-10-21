//
//  Notifications.swift
//  Vycle
//
//  Created by Clarissa Alverina on 19/10/24.
//
import CoreLocation
import UserNotifications

class DistanceTracker: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    private var lastLocation: CLLocation?
    private var targetDistance: Double = 1.0
    private var distanceSinceLastNotification: Double = 0.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    // CLLocationManagerDelegate method to track location updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        
        if let lastLocation = lastLocation {
            let distance = newLocation.distance(from: lastLocation) // distance in meters
            updateDistanceTraveled(distance)
        }
        
        // Update lastLocation for the next distance calculation
        lastLocation = newLocation
    }
    
    // Your existing distance tracking method
    func updateDistanceTraveled(_ distance: Double) {
        distanceSinceLastNotification += distance / 1000 // Convert to kilometers
        print("Distance traveled since last notification: \(distanceSinceLastNotification) kilometers")
        
        if distanceSinceLastNotification >= targetDistance {
            print("Target distance of \(targetDistance) km reached.")
            sendTargetDistanceNotification(distance: targetDistance)
            distanceSinceLastNotification = 0.0
        }
    }
    
    private func sendTargetDistanceNotification(distance: Double) {
        let content = UNMutableNotificationContent()
        content.title = "Distance Milestone Reached"
        content.body = "You have traveled another \(distance) kilometer(s). Keep going!"
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
}


//func scheduleNotification(for sparePart: String) {
//    let content = UNMutableNotificationContent()
//    content.title = "Maintenance Reminder"
//    content.body = "Your \(sparePart) has reached its service interval. Please perform maintenance."
//    content.sound = .default
//
//    // Trigger notification after 10 seconds
//    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
//    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
//
//    UNUserNotificationCenter.current().add(request) { error in
//        if let error = error {
//            print("Notification error: \(error.localizedDescription)")
//        }
//    }
//}


