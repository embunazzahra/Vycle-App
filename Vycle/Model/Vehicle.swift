//
//  Vehicle.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import Foundation
import SwiftData

@Model
final class Vehicle {
    var id: UUID
 
    
    init() {
        self.id = UUID()
    }
}
