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
    var reminderID: UUID = UUID()
    var date: Date
    var sparepart: Sparepart
    var reminderOdo: Float = 1000 
    var kmInterval: Float = 1000
    var dueDate: Date = Date()
    var timeInterval: Int = 0
    @Relationship var vehicle: Vehicle?
    var isRepeat: Bool
    var isDraft: Bool
    @Relationship var service: Servis?
    var isHelperOn: Bool
    var reminderType: String
    var isEdited: Bool
    var isCustom: Bool
    
    init(date: Date, sparepart: Sparepart, reminderOdo: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool, service: Servis? = nil, isHelperOn: Bool, reminderType: String, isEdited: Bool, isCustom: Bool) {
        self.date = date
        self.sparepart = sparepart
        self.reminderOdo = reminderOdo
        self.kmInterval = kmInterval
        self.dueDate = dueDate
        self.timeInterval = timeInterval
        self.vehicle = vehicle
        self.isRepeat = isRepeat
        self.isDraft = isDraft
        self.service = service
        self.isHelperOn = isHelperOn
        self.reminderType = reminderType
        self.isEdited = isEdited
        self.isCustom = isCustom
    }
}


