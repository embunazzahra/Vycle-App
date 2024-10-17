//
//  LocationHistory.swift
//  Vycle
//
//  Created by Vincent Senjaya on 11/10/24.
//



import Foundation
import SwiftData

//@Model
//class LocationHistory {
//    var latitude: Double
//    var longitude: Double
//    var timestamp: Date
//    var distanceFromLastLocation: Double? 
//    var bleStatus: Bool?
//
//    init(latitude: Double, longitude: Double, timestamp: Date = Date(), distanceFromLastLocation: Double? = nil, bleStatus: Bool? = nil) {
//        self.latitude = latitude
//        self.longitude = longitude
//        self.timestamp = timestamp
//        self.distanceFromLastLocation = distanceFromLastLocation
//        self.bleStatus = bleStatus
//    }
//}

@Model
final class LocationHistory {
    @Attribute(.unique) var locationID: UUID
    var distance: Float
    var latitude: Float
    var longitude: Float
    var time: Date
    @Relationship(deleteRule: .cascade) var vehicle: Vehicle
    @Relationship(deleteRule: .cascade) var trip: Trip
    
    // MARK: - Initialization
    init(locationID: UUID = UUID(), distance: Float, latitude: Float, longitude: Float, time: Date, vehicle: Vehicle, trip: Trip) {
        self.locationID = locationID
        self.distance = distance
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
        self.vehicle = vehicle
        self.trip = trip
    }
}


