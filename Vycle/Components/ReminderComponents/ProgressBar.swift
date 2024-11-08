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
    var sparepart: Sparepart
    @Binding var reminder: Reminder
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]
    
    let swiftDataService = SwiftDataService.shared
    
    var targetKM: Float {
        return Float(reminder.kmInterval)
    }

    var kilometerDifference: Float {
        if reminder.dueDate <= Date() {
            return 0.0
        } else {
            if reminder.isDraft == true {
                return 0.0
            }
            else {
                return ceil(targetKM - (Float(currentKM) - Float(reminder.reminderOdo)))
            }
        }
    }

    var progress: Float {
        if reminder.dueDate <= Date() {
            return 1.0
        } else {
            if reminder.isDraft == true {
                return 0.0
            } else {
                guard targetKM > 0 else { return 0.0 }
                return min((Float(currentKM) - Float(reminder.reminderOdo)) / targetKM, 1.0)
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if reminder.isDraft == false {
                if kilometerDifference <= 500 {
                    Text("Sudah tiba bulannya nih!")
//                    Text("\(Int(kilometerDifference)) Kilometer lagi")
                        .footnote(.emphasized)
                        .foregroundColor(Color.persianRed600)
                } else {
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
                // Display message when the reminder is a draft
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
}


