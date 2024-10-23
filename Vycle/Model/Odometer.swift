//
//  Odometer.swift
//  Vycle
//
//  Created by Vincent Senjaya on 17/10/24.
//


import SwiftData
import Foundation

@Model
final class Odometer {
    
    var date: Date = Date()
    var currentKM: Float
    @Relationship var vehicle: Vehicle
    init(date: Date, currentKM: Float, vehicle: Vehicle) {
        self.date = date
        self.currentKM = currentKM
        self.vehicle = vehicle
    }
}
