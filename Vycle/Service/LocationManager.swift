
import CoreLocation
import Combine
import SwiftData
import UserNotifications
import UIKit
import MapKit
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    @Published var currentLocation: CLLocationCoordinate2D?
    private var context: ModelContext?
    private var bleManager: BLEManager?
    private var lastSavedLocation: CLLocation?
    @Published var totalDistanceTraveled: Double = 0
    @Published var isInsideBeaconRegion: Bool = false
    private var lastRequestTime: Date?
    //    @Published var locationHistory: [LocationHistory] = []
    @AppStorage("vBeaconID") var vBeaconID: String = ""{
        didSet {
            // Call the method to update the beacon region when vBeaconID changes
            updateBeaconRegion()
        }
    }
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    // ID: 4CC9
    private var beaconUUID: UUID {
        let vBeaconID = vBeaconID.isEmpty ? "0000" : vBeaconID
        return UUID(uuidString: "2D7A9F0C-E0E8-\(vBeaconID)-A71B-A21DB2D034A1") ?? UUID()
    }
    private let beaconMajor: CLBeaconMajorValue = 5
    private let beaconMinor: CLBeaconMinorValue = 88
    private let identifier: String = "ALOHA"
    
    let testTrip = Trip(tripID: 1, isFinished: false, locationHistories: [], vehicle: Vehicle(vehicleType: .car, brand: .car(.toyota), year: 2024))
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestNotificationAuthorization()
        locationManager.requestWhenInUseAuthorization()
//        checkAuthorizationStatus()
    }
    
    func checkAuthorizationStatus() -> CLAuthorizationStatus{
//        switch locationManager.authorizationStatus {
//        case .authorizedAlways:
//            // Authorized for always access
//            return("always bro")
//        case .authorizedWhenInUse, .denied, .restricted, .notDetermined:
//            // Not authorized for always access
//            return("not always bro")
//        @unknown default:
//            return("not always bro")
//
//        }
        return locationManager.authorizationStatus
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorizationStatus()
    }
    
    func setContext(_ context: ModelContext) {
        self.context = context
    }
    
    func startTracking() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        startTrackingBeacons()
    }
    private func createBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(uuid: beaconUUID, major: beaconMajor, minor: beaconMinor, identifier: identifier)
    }
    
    // Update the beacon region when vBeaconID changes
    private func updateBeaconRegion() {
        // Stop tracking the previous region
        let previousRegion = createBeaconRegion() // Create the previous region
        locationManager.stopMonitoring(for: previousRegion)
        locationManager.stopRangingBeacons(in: previousRegion)
        
        // Start tracking the new beacon region
        startTrackingBeacons()
    }
    
    // Start tracking the beacon region
    func startTrackingBeacons() {
        if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
            print("monitoring available")
            let beaconRegion = CLBeaconRegion(uuid: beaconUUID, major: beaconMajor, minor: beaconMinor, identifier: identifier)
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
            let region = CLBeaconRegion(uuid: beaconUUID, major: beaconMajor, minor: beaconMinor, identifier: identifier)
            self.locationManager.startMonitoring(for: region)
        }
    }
    
    // Location updates from significant changes
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        DispatchQueue.main.async {
            self.currentLocation = location.coordinate
            if self.isInsideBeaconRegion {
                self.saveLocationHistory(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
                print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            } else {
                //                print("Significant location change occurred, but outside of beacon region. No data saved.")
            }
            //        }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        // Check if the ranged beacons match the new vBeaconID
        if beacons.count > 0 {
            let foundBeacon = beacons[0]
            let expectedBeaconUUID = beaconUUID
            
            if foundBeacon.uuid == expectedBeaconUUID {
                var distance = foundBeacon.proximity
                print("Distance: \(distance.rawValue)")
                
                // Update connection status based on proximity
                switch distance {
                case .unknown:
                    print("unknown")
                    handleBeaconConnection(isConnected: false)
                case .far:
                    print("far")
                    handleBeaconConnection(isConnected: true)
                case .near:
                    print("near")
                    handleBeaconConnection(isConnected: true)
                    isInsideBeaconRegion = true
                case .immediate:
                    print("immediate")
                    handleBeaconConnection(isConnected: true)
                    isInsideBeaconRegion = true
                }
            } else {
                // The detected beacon is not the expected one
                print("Detected a beacon that does not match the expected UUID.")
                handleBeaconConnection(isConnected: false) // Disconnect if the UUIDs don't match
                isInsideBeaconRegion = false
            }
        } else {
            // No beacons in range
            handleBeaconConnection(isConnected: false)
            isInsideBeaconRegion = false
        }
    }
    
    
    // Detect when entering a beacon region
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if region is CLBeaconRegion {
            isInsideBeaconRegion = true
            print("Entered beacon region")
            self.sendNotification()
            handleBeaconConnection(isConnected: true)
            if let currentLocation = currentLocation {
                self.saveLocationHistory(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if region is CLBeaconRegion {
            print("Exited beacon region")
            isInsideBeaconRegion = false
            handleBeaconConnection(isConnected: false)
            self.sendExitNotification()
            if let currentLocation = currentLocation {
                self.saveLocationHistory(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
            }
            
            startBackgroundTask()
        }
    }
    
    
    // Detect when entering a be
    
    func startBackgroundTask() {
        var backgroundTask: UIBackgroundTaskIdentifier = .invalid
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "MyTask") {
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
        }
    }
    
    //it works for SLC
    
    func calculateRoute(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D, completion: @escaping (Double?) -> Void) {
        // Set a minimum interval between requests
        let minimumInterval: TimeInterval = 5 // seconds

        // Check the last request time
        if let lastTime = lastRequestTime, Date().timeIntervalSince(lastTime) < minimumInterval {
            completion(nil)
            return
        }
        lastRequestTime = Date()

        // Proceed with the request as usual
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: end))
        request.transportType = .automobile

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else {
                print("Error calculating route: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
                return
            }

            let distance = route.distance
            completion(distance)
        }
    }
    
    func saveLocationHistory(latitude: Double, longitude: Double) {
        guard let context = context else {
            print("Context not set")
            return
        }
        
        let currentLocation = CLLocation(latitude: latitude, longitude: longitude)
        
        
        
        let tempDistance = SwiftDataService.shared.fetchLocationHistory().last?.distance ?? 0
        
//        print(SwiftDataService.shared.fetchLocationHistory().last?.distance)
          
        if let lastLocation = lastSavedLocation {
            // MKDirection buat liat jalan antara titik sekarang dan terakhir
            calculateRoute(from: lastLocation.coordinate, to: currentLocation.coordinate) { distance in
                if let distance = distance {
                        self.totalDistanceTraveled += distance / 1000
                    
                    //                    print("Distance traveled along the path: \(distance / 1000) kilometers")
                }
                    self.storeLocation(latitude: latitude, longitude: longitude, distanceFromLastLocation:  self.totalDistanceTraveled)
                
            }
            
        } else {
            storeLocation(latitude: latitude, longitude: longitude, distanceFromLastLocation: tempDistance)
            self.totalDistanceTraveled = tempDistance
            
        }
        
    }
    
    func storeLocation(latitude: Double, longitude: Double, distanceFromLastLocation: Double?) {
        guard let context = context else { return }
        
        do {
            try context.save()
            
            lastSavedLocation = CLLocation(latitude: latitude, longitude: longitude)
//            print("bug in storelocation")
            let newLocation = LocationHistory(distance: distanceFromLastLocation, latitude: latitude, longitude: longitude, time: Date(), trip: Trip(tripID: 1, isFinished: false, locationHistories: [], vehicle: Vehicle(vehicleType: .car, brand: .car(.toyota), year: 2024)))
            SwiftDataService.shared.insertLocationHistory(distance: distanceFromLastLocation, latitude: latitude, longitude: longitude, time: Date())
            
        } catch {
            print("Failed to save location history: \(error.localizedDescription)")
        }
    }
    
    
    // Handle beacon connection and disconnection
    func handleBeaconConnection(isConnected: Bool) {
        // Perform async task to get the current location and save it
        //        print("Beacon connection changed: \(isConnected ? "Connected" : "Disconnected")")
        if isConnected {
            isInsideBeaconRegion = true
        } else {
            isInsideBeaconRegion = false
        }
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
    private func sendNotification() {
        let content = UNMutableNotificationContent()
        content.title = "✨Beep Beep! VBeacon berhasil terhubung"
        content.body = """
                    Perjalanan Anda Kini Tercatat Secara Otomatis dengan IoT!
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
    private func sendExitNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🔌Szzt...! VBeacon terputus!"
        content.body = """
                    Kami mendeteksi bahwa koneksi Anda tidak terhubung
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
