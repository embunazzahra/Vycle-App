//
//  DummyModel.swift
//  Vycle
//
//  Created by Clarissa Alverina on 25/10/24.
//
import SwiftUI
import SwiftData
import Foundation 

struct DummyView: View {
    var body: some View {
        VStack {
            Button("Schedule Test Notification") {
                scheduleTestNotification()
            }
        }
    }

    private func scheduleTestNotification() {
        
        // Create a test Reminder object
        let testReminder = Reminder(
            date: Date(),
            sparepart: .filterUdara,
            reminderOdo: 100.0,
            kmInterval: 200.0,
            dueDate: Date().addingTimeInterval(2 * 60),
            timeInterval: 7,
            vehicle: Vehicle(vehicleType: .car, brand: .car(.honda)),
            isRepeat: true,
            isDraft: false
        )

        NotificationManager.shared.testScheduleNotification(for: testReminder)
    }
}
