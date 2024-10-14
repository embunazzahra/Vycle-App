//
//  ServiceHistory.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//
import Foundation

struct ServiceHistory: Identifiable {
    let id = UUID() // Unique identifier
    let title: String
    let mileage: Int
    let date: String
    var imageData: Data?
    var spareparts: [SukuCadang] = [.minyakRem,.filterOli]
}
