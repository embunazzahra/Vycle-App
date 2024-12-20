//
//  LocationHistory.swift
//  Vycle
//
//  Created by Vincent Senjaya on 11/10/24.
//



import Foundation
import SwiftData

@Model
final class LocationHistory {
    var distance: Double?
    var latitude: Double
    var longitude: Double
    var time: Date
    @Relationship var trip: Trip
    
    init(distance: Double? = nil, latitude: Double, longitude: Double, time: Date, trip: Trip) {
        self.distance = distance
        self.latitude = latitude
        self.longitude = longitude
        self.time = time
        self.trip = trip
    }
}


