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

    @Relationship var vehicle: Vehicle
    
    init(tripID: Int, isFinished: Bool, vehicle: Vehicle) {
        self.tripID = tripID
        self.isFinished = isFinished
        self.vehicle = vehicle
    }
}
