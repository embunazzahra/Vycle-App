//
//  Trip.swift
//  Vycle
//
//  Created by Vincent Senjaya on 17/10/24.
//


import SwiftData
import Foundation

@Model
final class Trip {
    // MARK: - Attributes
    var tripID: Int
    var isFinished: Bool
    
    // MARK: - Initialization
    init(tripID: Int, isFinished: Bool = false) {
        self.tripID = tripID
        self.isFinished = isFinished
    }
}
