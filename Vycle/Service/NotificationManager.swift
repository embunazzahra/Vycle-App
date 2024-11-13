//
//  NotificationManager.swift
//  Vycle
//
//  Created by Clarissa Alverina on 25/10/24.
//

import UserNotifications
import SwiftUI

class NotificationManager {
    
    static let shared = NotificationManager()
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error.localizedDescription)")
            } else {
                print("Notification permissions granted: \(granted)")
            }
        }
    }
    
    func scheduleNotification(for reminder: Reminder) {
        let content = UNMutableNotificationContent()
        content.title = "Reminder for \(reminder.sparepart.rawValue)"
        content.body = "It's time to service your \(reminder.sparepart.rawValue) in your vehicle!"
        content.sound = .default
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminder.dueDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false) // One-time trigger for the initial notification
        
        let request = UNNotificationRequest(identifier: reminder.reminderID.uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Initial notification scheduled for reminder: \(reminder.sparepart.rawValue) at \(reminder.dueDate)")
                
                let repeatTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 604800, repeats: true)
                let repeatRequest = UNNotificationRequest(identifier: "\(reminder.reminderID.uuidString)-repeat", content: content, trigger: repeatTrigger)
                
                UNUserNotificationCenter.current().add(repeatRequest) { error in
                    if let error = error {
                        print("Error scheduling repeating notification: \(error.localizedDescription)")
                    } else {
                        print("Repeating notification scheduled for reminder: \(reminder.sparepart.rawValue) every 7 days")
                    }
                }
            }
        }
    }
    
    func cancelNotification(for reminder: Reminder) {
        let notificationID = reminder.reminderID.uuidString
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationID])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(notificationID)-repeat"])
        print("Notification for \(reminder.sparepart.rawValue) cancelled.")
    }
    
}
