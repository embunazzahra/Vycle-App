//
//  SukuCadangEnum.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

enum SukuCadang: String, CaseIterable, Hashable, Identifiable {
    case filterUdara = "Filter udara"
    case oliMesin = "Oli mesin"
    case oliGardan = "Oli gardan"
    case oliTransmisi = "Oli transmisi"
    case filterOli = "Filter oli"
    case busi = "Busi"
    case minyakRem = "Minyak rem"
    case minyakKopling = "Minyak kopling"
    case airCoolant = "Air coolant"
    case timingBelt = "Timing belt"
    
    
    var id: String { self.rawValue }
}
