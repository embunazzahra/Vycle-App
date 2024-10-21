//
//  ProgressBar.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI
import UserNotifications

struct ProgressBar: View {
    var currentKilometer: Double
    var maxKilometer: Double?
    var serviceOdometer: Double
    var sparepart: Sparepart
    
    @State private var hasScheduledNotification = false

    private var kilometerDifference: Double {
        return (maxKilometer ?? 0.0) - currentKilometer 
    }
    
    private var progress: Double {
        guard let maxKM = maxKilometer, maxKM > 0 else { return 0.0 }
        return min(currentKilometer / maxKM, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if maxKilometer != nil {
                if progress >= 1.0 {
                    Text("Sudah tiba bulannya nih!")
                        .footnote(.emphasized)
                        .foregroundColor(Color.persianRed600)
                        .onAppear {
                            if !hasScheduledNotification {
                                scheduleNotificationForSparepart()
                                hasScheduledNotification = true
                            }
                        }
                } else if progress > 0.7 {
                    Text("\(Int(kilometerDifference)) Kilometer lagi")
                        .footnote(.emphasized)
                        .foregroundColor(Color.persianRed600)
                } else if progress > 0.3 {
                    Text("\(Int(kilometerDifference)) Kilometer lagi")
                        .footnote(.emphasized)
                        .foregroundColor(Color.amber600)
                } else {
                    Text("\(Int(kilometerDifference)) Kilometer lagi")
                        .footnote(.emphasized)
                        .foregroundColor(Color.lima600)
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
                        progress > 0.7 ? .persianRed600 :
                        (progress > 0.3 ? .amber600 : .lima600)
                    )
                    .animation(.linear, value: progress)
            }
        }
    }
    
    func scheduleNotificationForSparepart() {
        let content = UNMutableNotificationContent()
        content.title = "🚗 Honk! Kilometer \(sparepart.rawValue) sudah mendekat, siap ganti!"
        content.body = "Waktunya untuk cek dan ganti \(sparepart.rawValue) biar kendaraanmu tetap prima di jalan! 🔧✨"
        content.sound = .default

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
//    ProgressBar(currentKilometer: 200, maxKilometer: 200, serviceOdometer: 5, sparepart: Sparepart(rawValue: "Oil Filter"))
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
