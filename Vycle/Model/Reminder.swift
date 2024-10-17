//
//  Reminder.swift
//  Vycle
//
//  Created by Vincent Senjaya on 17/10/24.
//


import SwiftData
import Foundation

@Model
class Reminder {
    // MARK: - Attributes
    @Attribute(.unique) var reminderID: UUID
    var date: Date
    var sparepart: Sparepart
    var targetKM: Float = 1000 
    var kmInterval: Float = 1000
    var dueDate: Date = Date()
    var timeInterval: Int = 0
    @Relationship(deleteRule: .cascade) var vehicle: Vehicle
    var isRepeat: Bool
    var isDraft: Bool
    
    // MARK: - Initialization
    init(reminderID: UUID = UUID(), date: Date, sparepart: Sparepart, targetKM: Float = 1000, kmInterval: Float = 1000, dueDate: Date = Date(), timeInterval: Int = 0, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool) {
        self.reminderID = reminderID
        self.date = date
        self.sparepart = sparepart
        self.targetKM = targetKM
        self.kmInterval = kmInterval
        self.dueDate = dueDate
        self.timeInterval = timeInterval
        self.vehicle = vehicle
        self.isRepeat = isRepeat
        self.isDraft = isDraft
    }
}
