//
//  Trip.swift
//  Vycle
//
//  Created by Vincent Senjaya on 17/10/24.
//


import SwiftData
import Foundation

@Model
final class Trip {
    var tripID: Int
    var isFinished: Bool
    
    @Relationship(deleteRule: .cascade, inverse: \LocationHistory.trip) var locationHistories: [LocationHistory] = []
    @Relationship var vehicle: Vehicle
    
    init(tripID: Int, isFinished: Bool, locationHistories: [LocationHistory], vehicle: Vehicle) {
        self.tripID = tripID
        self.isFinished = isFinished
        self.locationHistories = locationHistories
        self.vehicle = vehicle
    }
}
