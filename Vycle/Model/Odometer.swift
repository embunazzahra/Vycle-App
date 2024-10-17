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
   
    @Attribute(.unique) var recordID: UUID
    var date: Date = Date()
    var currentKM: Float
    @Relationship(deleteRule: .cascade) var vehicle: Vehicle
    
    
    init(recordID: UUID = UUID(), currentKM: Float, vehicle: Vehicle) {
        self.recordID = recordID
        self.currentKM = currentKM
        self.vehicle = vehicle
    }
}
