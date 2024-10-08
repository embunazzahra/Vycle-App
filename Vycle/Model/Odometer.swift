//
//  Odometer.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import Foundation
import SwiftData

@Model
final class Odometer {
    var id: UUID
    var timestamp: Date
    var value: Int
    
    init(timestamp: Date, value: Int) {
        self.id = UUID()
        self.timestamp = timestamp
        self.value = value
    }
}
