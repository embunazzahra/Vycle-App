//
//  LocationManager.swift
//  Vycle
//
//  Created by Vincent Senjaya on 11/10/24.
//


import CoreLocation
import Combine
import SwiftData
import UserNotifications
import UIKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    private var context: ModelContext?
    private var bleManager: BLEManager?
    private var lastSavedLocation: CLLocation?
    @Published var totalDistanceTraveled: Double = 0.0
    
    private let beaconUUID = UUID(uuidString: "2D7A9F0C-E0E8-4CC9-A71B-A21DB2D034A1")!
    private let beaconMajor: CLBeaconMajorValue = 5
    private let beaconMinor: CLBeaconMinorValue = 88
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestNotificationAuthorization()
        locationManager.requestAlwaysAuthorization()
        
    }
    
    func setBLEManager(_ manager: BLEManager) {
        self.bleManager = manager
    }
    
    func setContext(_ context: ModelContext) {
        self.context = context
    }
    
    func startTracking() {
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        startTrackingBeacons()
        
    }
    
    // Start tracking the beacon region
    func startTrackingBeacons() {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            print("monitoring available")
            let beaconRegion = CLBeaconRegion(uuid: beaconUUID, major: beaconMajor, minor: beaconMinor, identifier: "ALOHA")
            if CLLocationManager.isRangingAvailable() {
                print("isranging available")
                locationManager.startMonitoring(for: beaconRegion)
                locationManager.startRangingBeacons(in: beaconRegion)
            }
            self.locationManager.startMonitoring(for: beaconRegion)
        }
    }
    private func startMonitoring() {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            let region = CLBeaconRegion(uuid: beaconUUID, major: beaconMajor, minor: beaconMinor, identifier: "ALOHA")
            self.locationManager.startMonitoring(for: region)
        }
    }
    
    // Location updates from significant changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            self.saveLocationHistory(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    // Detect when entering a beacon region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLBeaconRegion {
            print("Entered beacon region")
            handleBeaconConnection(isConnected: true)
        }
    }
    func startBackgroundTask() {
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "MyTask") {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLBeaconRegion {
            print("Exited beacon region")
            handleBeaconConnection(isConnected: false)
            startBackgroundTask()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            var distance = beacons[0].proximity
            switch distance {
                    case .unknown:
                        print("unknown")
                        handleBeaconConnection(isConnected: false)

                    case .far:
                        print("far")
                        handleBeaconConnection(isConnected: true)
                let newLocation = LocationHistory(latitude: 2, longitude: 2, distanceFromLastLocation: 2, bleStatus: true)
                    context?.insert(newLocation)

                    case .near:
                        print("near")
                        handleBeaconConnection(isConnected: true)
                let newLocation = LocationHistory(latitude: 3, longitude: 3, distanceFromLastLocation: 3, bleStatus: true)
                    context?.insert(newLocation)

                    case .immediate:
                        print("immediate")
                        handleBeaconConnection(isConnected: true)
                let newLocation = LocationHistory(latitude: 4, longitude: 4, distanceFromLastLocation: 4, bleStatus: true)
                    context?.insert(newLocation)
                    }
        } else {
            print("beacons count is 0")
        }
        
        
    }
    
    
    
    // Save location history and handle BLE/beacon status
    func saveLocationHistory(latitude: Double, longitude: Double) {
        guard let context = context else { return }
        
        var distance: Double? = nil
        if let lastLocation = self.lastSavedLocation {
            let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
            distance = currentLocation.distance(from: lastLocation) / 1000
            
            // Accumulate total distance traveled
            self.totalDistanceTraveled += distance ?? 0.0
//            print("Distance traveled since last location: \(distance ?? 0.0) kilometers")
        }
        
        let bleStatus = self.bleManager?.isConnected ?? false
        
        let newLocation = LocationHistory(latitude: latitude, longitude: longitude, distanceFromLastLocation: distance, bleStatus: bleStatus)
        context.insert(newLocation)
        
        do {
            try context.save()
//            print("Location saved: \(newLocation)")
            sendNotification(for: newLocation)
            self.lastSavedLocation = CLLocation(latitude: latitude, longitude: longitude)
        } catch {
            print("Failed to save location: \(error.localizedDescription)")
        }
    }
    
    // Handle beacon connection and disconnection
    func handleBeaconConnection(isConnected: Bool) {
        // Perform async task to get the current location and save it
        print("Beacon connection changed: \(isConnected ? "Connected" : "Disconnected")")
        requestCurrentLocationAndSave()
    }
    
    // Request the current location and save it
    func requestCurrentLocationAndSave() {
        locationManager.requestLocation()  // Request the current location
    }

    
    // Handle location errors
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
    
    // Send notification when beacon status changes
    private func sendNotification(for location: LocationHistory) {
        let content = UNMutableNotificationContent()
        content.title = "Beacon Status Changed"
        content.body = """
                    Location \(location.latitude), \(location.longitude) has been saved.
                """
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            }
        }
    }
    
    private func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
}


