//
//  LocationHistory.swift
//  Vycle
//
//  Created by Vincent Senjaya on 11/10/24.
//



import Foundation
import SwiftData

@Model
class LocationHistory {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var distanceFromLastLocation: Double? 
    var bleStatus: Bool?

    init(latitude: Double, longitude: Double, timestamp: Date = Date(), distanceFromLastLocation: Double? = nil, bleStatus: Bool? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.distanceFromLastLocation = distanceFromLastLocation
        self.bleStatus = bleStatus
    }
}


