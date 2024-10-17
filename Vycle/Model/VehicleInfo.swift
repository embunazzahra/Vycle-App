//
//  Sparepart.swift
//  Vycle
//
//  Created by Vincent Senjaya on 17/10/24.
//


enum Sparepart: String, Codable, CaseIterable {
    case filterUdara = "Filter udara"
    case oliMesin = "Oli mesin"
    case oliGardan = "Oli Gardan"
    case oliTransmisi = "Oli transmisi"
    case filterOli = "Filter Oli"
    case busi = "Busi"
    case minyakRem = "Minyak rem"
    case minyakKopling = "Minyak Kopling"
    case coolant = "Coolant"
}

enum VehicleType: String, Codable, CaseIterable {
    case car
    case motorcycle
    case bicycle
    case truck
    case bus
}

enum Brand: String, Codable, CaseIterable {
    case toyota
    case honda
    case ford
    case bmw
    case yamaha
    case suzuki
    case mercedes
}
