//
//  Sparepart.swift
//  Vycle
//
//  Created by Vincent Senjaya on 17/10/24.
//

enum Sparepart: String, Codable, CaseIterable, Hashable, Identifiable {
    case filterUdara = "Filter udara"
    case oliMesin = "Oli mesin"
    case oliGardan = "Oli gardan"
    case oliTransmisi = "Oli transmisi"
    case filterOli = "Filter oli"
    case busi = "Busi"
    case minyakRem = "Minyak rem"
    case minyakKopling = "Minyak kopling"
    case airCoolant = "Air coolant"
    
    var id: String { self.rawValue }
}

enum VehicleType: String, Codable, CaseIterable {
    case car
    case motorcycle
}

enum VehicleBrand:  Codable, Hashable {
    case car(Car)
    case motorcycle(Motorcycle)
    case custom(String)
    
    // Computed property to get the brand as a string
    var stringValue: String {
        switch self {
        case .car(let brand):
            return brand.rawValue
        case .motorcycle(let brand):
            return brand.rawValue
        case .custom(let brandName):
            return brandName
        }
    }
    
    func intervalForSparepart(_ sparepart: Sparepart) -> Interval? {
            switch self {
            case .car(let brand):
                return brand.intervalForSparepart(sparepart)
            case .motorcycle(let brand):
                return brand.intervalForSparepart(sparepart)
            case .custom(_):
                return nil // atau Anda dapat memberikan logika khusus untuk merek kustom
            }
        }
    
    // Check if it is a custom brand
    var isCustomBrand: Bool {
        if case .custom = self {
            return true
        }
        return false
    }
}

struct Interval {
    let month: Int
    let kilometer: Int
}


enum Car: String, CaseIterable, Codable {
    case honda = "Honda"
    case suzuki = "Suzuki"
    case toyota = "Toyota"
    case daihatsu = "Daihatsu"
    case mitsubishi = "Mitsubishi"
    
    func intervalForSparepart(_ sparepart: Sparepart) -> Interval? {
        switch self {
        case .honda:
            return hondaSparepartIntervals[sparepart]
        case .suzuki:
            return suzukiSparepartIntervals[sparepart]
        case .toyota:
            return toyotaSparepartIntervals[sparepart]
        case .mitsubishi:
            return mitsubishiSparepartIntervals[sparepart]
        case .daihatsu:
            return daihatsuSparepartIntervals[sparepart]
        }
    }
    
    private var hondaSparepartIntervals: [Sparepart: Interval] {
        return [
            .filterUdara: Interval(month: 24, kilometer: 40000),
            .oliMesin: Interval(month: 6, kilometer: 10000),
            .oliGardan: Interval(month: 24, kilometer: 40000),
            .oliTransmisi : Interval(month: 24, kilometer: 40000),
            .filterOli: Interval(month: 6, kilometer: 10000),
            .busi: Interval(month: 12, kilometer: 20000),
            .minyakRem : Interval(month: 24, kilometer: 40000),
            .minyakKopling : Interval(month: 24, kilometer: 40000),
            .airCoolant : Interval(month: 24, kilometer: 40000)
        ]
    }

    private var suzukiSparepartIntervals: [Sparepart: Interval] {
        return [
            .filterUdara: Interval(month: 24, kilometer: 40000),
            .oliMesin: Interval(month: 6, kilometer: 10000),
            .oliGardan: Interval(month: 24, kilometer: 40000),
            .oliTransmisi : Interval(month: 24, kilometer: 40000),
            .filterOli: Interval(month: 6, kilometer: 10000),
            .busi: Interval(month: 12, kilometer: 20000),
            .minyakRem : Interval(month: 24, kilometer: 40000),
            .minyakKopling : Interval(month: 24, kilometer: 40000),
            .airCoolant : Interval(month: 24, kilometer: 40000)
        ]
    }

    private var toyotaSparepartIntervals: [Sparepart: Interval] {
        return [
            .filterUdara: Interval(month: 24, kilometer: 40000),
            .oliMesin: Interval(month: 6, kilometer: 10000),
            .oliGardan: Interval(month: 24, kilometer: 40000),
            .oliTransmisi : Interval(month: 24, kilometer: 40000),
            .filterOli: Interval(month: 6, kilometer: 10000),
            .busi: Interval(month: 12, kilometer: 20000),
            .minyakRem : Interval(month: 24, kilometer: 40000),
            .minyakKopling : Interval(month: 24, kilometer: 40000),
            .airCoolant : Interval(month: 24, kilometer: 40000)
        ]
    }
    
    private var mitsubishiSparepartIntervals: [Sparepart: Interval] {
        return [
            .filterUdara: Interval(month: 24, kilometer: 40000),
            .oliMesin: Interval(month: 6, kilometer: 10000),
            .oliGardan: Interval(month: 24, kilometer: 40000),
            .oliTransmisi : Interval(month: 24, kilometer: 40000),
            .filterOli: Interval(month: 6, kilometer: 10000),
            .busi: Interval(month: 12, kilometer: 20000),
            .minyakRem : Interval(month: 24, kilometer: 40000),
            .minyakKopling : Interval(month: 24, kilometer: 40000),
            .airCoolant : Interval(month: 24, kilometer: 40000)
        ]
    }
    
    private var daihatsuSparepartIntervals: [Sparepart: Interval] {
        return [
            .filterUdara: Interval(month: 24, kilometer: 40000),
            .oliMesin: Interval(month: 6, kilometer: 10000),
            .oliGardan: Interval(month: 24, kilometer: 40000),
            .oliTransmisi : Interval(month: 24, kilometer: 40000),
            .filterOli: Interval(month: 6, kilometer: 10000),
            .busi: Interval(month: 12, kilometer: 20000),
            .minyakRem : Interval(month: 24, kilometer: 40000),
            .minyakKopling : Interval(month: 24, kilometer: 40000),
            .airCoolant : Interval(month: 24, kilometer: 40000)
        ]
    }
}

enum Motorcycle: String, CaseIterable, Codable {
    case honda = "Honda"
    case yamaha = "Yamaha"
    
    func intervalForSparepart(_ sparepart: Sparepart) -> Interval? {
        switch self {
        case .honda:
            return hondaSparepartIntervals[sparepart]
        case .yamaha:
            return yamahaSparepartIntervals[sparepart]
        }
    }
    
    private var hondaSparepartIntervals: [Sparepart: Interval] {
        return [
            .filterUdara: Interval(month: 24, kilometer: 40000),
            .oliMesin: Interval(month: 6, kilometer: 10000),
            .oliGardan: Interval(month: 24, kilometer: 40000),
            .oliTransmisi : Interval(month: 24, kilometer: 40000),
            .filterOli: Interval(month: 6, kilometer: 10000),
            .busi: Interval(month: 12, kilometer: 20000),
            .minyakRem : Interval(month: 24, kilometer: 40000),
            .minyakKopling : Interval(month: 24, kilometer: 40000),
            .airCoolant : Interval(month: 24, kilometer: 40000)
        ]
    }

    private var yamahaSparepartIntervals: [Sparepart: Interval] {
        return [
            .filterUdara: Interval(month: 24, kilometer: 40000),
            .oliMesin: Interval(month: 6, kilometer: 10000),
            .oliGardan: Interval(month: 24, kilometer: 40000),
            .oliTransmisi : Interval(month: 24, kilometer: 40000),
            .filterOli: Interval(month: 6, kilometer: 10000),
            .busi: Interval(month: 12, kilometer: 20000),
            .minyakRem : Interval(month: 24, kilometer: 40000),
            .minyakKopling : Interval(month: 24, kilometer: 40000),
            .airCoolant : Interval(month: 24, kilometer: 40000)
        ]
    }
}



//enum VehicleBrand: Codable, Hashable {
//    case honda
//    case suzuki
//    case toyota
//    case daihatsu
//    case mitsubishi
//    case custom(String)
//    
//    var stringValue: String {
//        switch self {
//        case .honda: return "Honda"
//        case .suzuki: return "Suzuki"
//        case .toyota: return "Toyota"
//        case .daihatsu: return "Daihatsu"
//        case .mitsubishi: return "Mitsubishi"
//        case .custom(let name): return name
//        }
//    }
//    
//    var isCustomBrand: Bool {
//        if case .custom(_) = self {
//            return true
//        }
//        return false
//    }
//}





//enum Sparepart: String, Codable, CaseIterable {
//    case filterUdara = "Filter udara"
//    case oliMesin = "Oli mesin"
//    case oliGardan = "Oli Gardan"
//    case oliTransmisi = "Oli transmisi"
//    case filterOli = "Filter Oli"
//    case busi = "Busi"
//    case minyakRem = "Minyak rem"
//    case minyakKopling = "Minyak Kopling"
//    case coolant = "Coolant"
//}
//
//enum VehicleType: String, Codable, CaseIterable {
//    case car
//    case motorcycle
//}
//
//enum Brand: String, Codable, CaseIterable {
//    case toyota
//    case honda
//    case ford
//    case bmw
//    case yamaha
//    case suzuki
//    case mercedes
//}
