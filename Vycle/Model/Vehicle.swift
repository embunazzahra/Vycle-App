//
//  Vehicle.swift
//  Vycle
//
//  Created by Vincent Senjaya on 17/10/24.
//


import SwiftData
import Foundation

@Model
class Vehicle {
    @Attribute(.unique) var vehicleID: UUID
    var vehicleType: VehicleType
    var brand: Brand
    @Relationship(deleteRule: .cascade, inverse: \Servis.vehicle) var services: [Servis] = []
    @Relationship(deleteRule: .cascade, inverse: \Reminder.vehicle) var reminders: [Reminder] = []
    @Relationship(deleteRule: .cascade, inverse: \Odometer.vehicle) var odometers: [Odometer] = []
    @Relationship(deleteRule: .cascade, inverse: \Trip.vehicle) var trips: [Trip] = []
    
    init(vehicleID: UUID = UUID(), vehicleType: VehicleType, brand: Brand) {
        self.vehicleID = vehicleID
        self.vehicleType = vehicleType
        self.brand = brand
    }
}
