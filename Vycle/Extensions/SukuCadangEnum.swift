//
//  SukuCadangEnum.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

enum SukuCadang: String, CaseIterable {
    case filterUdara = "Filter udara"
    case filterOli = "Filter oli"
    case busi = "Busi"
    case minyakRem = "Minyak rem"
    case minyakKopling = "Minyak kopling"
    case airCoolant = "Air coolant"
    case oliMesin = "Oli mesin"
    case oliGardan = "Oli gardan"
    case oliTransmisi = "Oli transmisi"
    
    var id: String { self.rawValue }
}
