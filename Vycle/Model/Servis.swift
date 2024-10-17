//
//  LocationHistory.swift
//  Vycle
//
//  Created by Vincent Senjaya on 11/10/24.
//



import Foundation
import SwiftData

@Model
class Servis {
    @Attribute(.unique) var serviceID: UUID
    var date: Date
    var servicedSparepart: Sparepart
    var photo: Data?
    var odometer: Float
    @Relationship(deleteRule: .cascade) var vehicle: Vehicle
    init(serviceID: UUID, date: Date, servicedSparepart: Sparepart, photo: Data? = nil, odometer: Float, vehicle: Vehicle) {
        self.serviceID = serviceID
        self.date = date
        self.servicedSparepart = servicedSparepart
        self.photo = photo
        self.odometer = odometer
        self.vehicle = vehicle
    }
}


