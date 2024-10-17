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
    // MARK: - Attributes
    @Attribute(.unique) var vehicleID: UUID
    var vehicleType: VehicleType
    var brand: Brand
    @Relationship(inverse: \Servis.vehicle) var services: [Servis] = []
    
    // MARK: - Initialization
    init(vehicleID: UUID = UUID(), vehicleType: VehicleType, brand: Brand) {
        self.vehicleID = vehicleID
        self.vehicleType = vehicleType
        self.brand = brand
    }
}
