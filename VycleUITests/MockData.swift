//
//  MockData.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 20/11/24.
//

import Foundation
@testable import Vycle

// Mock Data for Sparepart
struct MockSparepart {
    static let spareparts: [Sparepart] = [
        .filterUdara,
        .oliMesin,
        .filterOli
    ]
}

// Mock Data for Vehicle
struct MockVehicle {
    static let vehicle: Vehicle = Vehicle(
        vehicleType: .car,
        brand: .car(.toyota),
        year: 2020
    )
}

// Mock Data for Servis
struct MockServis {
    static let services: [Servis] = [
        Servis(
            date: Date(),
            servicedSparepart: [MockSparepart.spareparts[0], MockSparepart.spareparts[2]],
            photo: nil,
            odometer: 15000.0,
            vehicle: MockVehicle.vehicle,
            totalPrice: 200.0
        ),
        Servis(
            date: Calendar.current.date(byAdding: .month, value: -6, to: Date())!,
            servicedSparepart: [MockSparepart.spareparts[1]],
            photo: nil,
            odometer: 10000.0,
            vehicle: MockVehicle.vehicle,
            totalPrice: 50.0
        ),
        Servis(
            date: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
            servicedSparepart: MockSparepart.spareparts,
            photo: nil,
            odometer: 5000.0,
            vehicle: MockVehicle.vehicle,
            totalPrice: 300.0
        )
    ]
}

