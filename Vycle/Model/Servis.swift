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
    var servisID: UUID = UUID()
    var date: Date
    var servicedSparepart: [Sparepart]
    var photo: Data?
    var totalPrice: Float

    var odometer: Float?
    @Relationship var vehicle: Vehicle
    @Relationship(deleteRule: .cascade, inverse: \Reminder.service) var reminders: [Reminder] = []
    init(date: Date, servicedSparepart: [Sparepart], photo: Data? = nil, odometer: Float? = nil, vehicle: Vehicle, totalPrice: Float) {
        self.date = date
        self.servicedSparepart = servicedSparepart
        self.photo = photo
        self.odometer = odometer
        self.vehicle = vehicle
        self.totalPrice = totalPrice
    }
}


