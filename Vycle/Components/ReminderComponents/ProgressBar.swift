//
//  ProgressBar.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI
import UserNotifications
import SwiftData

struct ProgressBar: View {
    var currentKM: Double
//    var maxKilometer: Double?
    var sparepart: Sparepart
    @Binding var reminder: Reminder
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]
    
//    @Binding var selectedNumber: Int

    @State private var hasScheduledNotification = false
    
    let swiftDataService = SwiftDataService.shared
    
    var targetKM: Float {
        return Float(reminder.kmInterval)
    }

    private var kilometerDifference: Float {
        return targetKM - (Float(currentKM) - Float(reminder.reminderOdo))
    }

    private var progress: Float {
        guard targetKM > 0 else { return 0.0 }
        return min((Float(currentKM) - Float(reminder.reminderOdo)) / targetKM, 1.0)
    }

    var body: some View {
        VStack(alignment: .leading) {
            if targetKM != nil {
                if kilometerDifference <= 500 {
//                    Text("Sudah tiba bulannya nih!")
                    Text("\(Int(kilometerDifference)) Kilometer lagi")
                        .footnote(.emphasized)
                        .foregroundColor(Color.persianRed600)
                        .onAppear {
                            if !hasScheduledNotification {
//                                scheduleNotificationForSparepart()
                                scheduleNotification(for: sparepart)
                                hasScheduledNotification = true
                                updateReminderDateToNow()
                            }
                        }
                } else {
//                    if progress >= 1.0 {
//                        Text("Sudah tiba bulannya nih!")
//                            .footnote(.emphasized)
//                            .foregroundColor(Color.persianRed600)
//                            .onAppear {
//                                if !hasScheduledNotification {
//    //                                scheduleNotificationForSparepart()
//                                    scheduleNotification(for: sparepart)
//                                    hasScheduledNotification = true
//                                    updateReminderDateToNow()
//                                }
//                            }
//                    } else if progress > 0.7 {
//                        Text("\(Int(kilometerDifference)) Kilometer lagi")
//                            .footnote(.emphasized)
//                            .foregroundColor(Color.persianRed600)
//                    } else
                    if progress > 0.3 {
                        Text("\(Int(kilometerDifference)) Kilometer lagi")
                            .footnote(.emphasized)
                            .foregroundColor(Color.amber600)
                    } else {
                        Text("\(Int(kilometerDifference)) Kilometer lagi")
                            .footnote(.emphasized)
                            .foregroundColor(Color.lima600)
                    }
                }
            } else {
                Text("Belum ada data kilometer")
                    .footnote(.emphasized)
                    .foregroundColor(Color.neutral.tone200)
            }
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 265, height: 8)
                    .cornerRadius(4)
                    .foregroundColor(Color.gray.opacity(0.3))
                
                Rectangle()
                    .frame(width: CGFloat(progress) * 265, height: 8)
                    .cornerRadius(4)
                    .foregroundColor(
                        kilometerDifference <= 500 ? .persianRed600 :
                            (progress > 0.3 ? .amber600 : .lima600)
                    )
                    .animation(.linear, value: progress)
            }
        }
    }
    
    private func updateReminderDateToNow() {
        if kilometerDifference <= 500 {
            swiftDataService.editReminder(
                reminder: reminder,
                sparepart: reminder.sparepart,
                reminderOdo: reminder.reminderOdo,
                kmInterval: reminder.kmInterval,
                dueDate: Date(),
                timeInterval: reminder.timeInterval,
                vehicle: reminder.vehicle!,
                isRepeat: reminder.isRepeat,
                isDraft: reminder.isDraft
            )
        }
    }
    
    func scheduleNotification(for sparepart: Sparepart) {
        let content = UNMutableNotificationContent()
        content.title = "🚗 Honk! Kilometer suku cadang sudah mendekat, siap ganti!"
        content.body = "Waktunya untuk cek dan ganti \(sparepart.rawValue) biar kendaraanmu tetap prima di jalan! 🔧✨"
        content.sound = .default
        
        // Immediate notification for testing (use timeInterval: 1 to trigger after 1 second)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for sparepart: \(sparepart.rawValue)")
            }
        }
    }
}


//#Preview {
//    ProgressBar(currentKilometer: 200, maxKilometer: 200, serviceOdometer: 5, sparepart: Sparepart(rawValue: "Oil Filter")!)
//}




//#Preview {
//    ProgressBar(currentKilometer: 200, maxKilometer: 200, serviceOdometer: 5, sparePartName: "Oil Filter")
//
////    ProgressBar(currentKilometer: 0, maxKilometer: nil, serviceOdometer: 5)
////
////    ProgressBar(currentKilometer: 0, maxKilometer: 15, serviceOdometer: 0)
////    
////    ProgressBar(currentKilometer: 10, maxKilometer: 50, serviceOdometer: 5)
////    
////    ProgressBar(currentKilometer: 50, maxKilometer: 100, serviceOdometer: 10)
////    
////    ProgressBar(currentKilometer: 200, maxKilometer: 200, serviceOdometer: 5)
//}



//import SwiftUI
//
//struct ProgressBar: View {
//    var currentKilometer: Double
//    var maxKilometer: Double
//    var serviceOdometer: Double
//
//    private var kilometerDifference: Double {
//        return maxKilometer - (currentKilometer - serviceOdometer)
//    }
//    
//    private var progress: Double {
//        return min((currentKilometer - serviceOdometer) / maxKilometer, 1.0)
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            if progress >= 1.0 {
//                Text("Sudah tiba bulannya nih!")
//                    .footnote(.emphasized)
//                    .foregroundColor(Color.persianRed600)
//            } else if progress >= 0.66 {
//                Text("\(Int(kilometerDifference)) Kilometer lagi")
//                    .footnote(.emphasized)
//                    .foregroundColor(Color.persianRed600)
//            } else if progress <= 0 {
//                Text("Belum ada data kilometer")
//                    .footnote(.emphasized)
//                    .foregroundColor(Color.neutral.tone200)
//            } else {
//                Text("\(Int(kilometerDifference)) Kilometer lagi")
//                    .footnote(.emphasized)
//                    .foregroundColor(Color.lima600)
//            }
//            
//            ZStack(alignment: .leading) {
//                Rectangle()
//                    .frame(width: 265, height: 8)
//                    .cornerRadius(4)
//                    .foregroundColor(Color.gray.opacity(0.3))
//                
//                Rectangle()
//                    .frame(width: CGFloat(progress) * 265, height: 8)
//                    .cornerRadius(4)
//                    .foregroundColor(progress >= 0.66 ? .persianRed600 : .lima600)
//                    .animation(.linear, value: progress)
//            }
//        }
//    }
//}
//
//#Preview {
//    ProgressBar(currentKilometer: 0, maxKilometer: 15000, serviceOdometer: 0)
//    
//    ProgressBar(currentKilometer: 2000, maxKilometer: 10000, serviceOdometer: 1000)
//    
//    ProgressBar(currentKilometer: 10000, maxKilometer: 10000, serviceOdometer: 1000)
//}
