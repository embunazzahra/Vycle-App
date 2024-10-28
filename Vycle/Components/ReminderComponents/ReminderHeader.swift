//
//  ReminderHeader.swift
//  ReminderVycle
//
//  Created by Clarissa Alverina on 08/10/24.
//
import SwiftUI

struct ReminderHeader: View {
    var reminders: [Reminder]
    @EnvironmentObject var routes: Routes

    var body: some View {
        let uniqueReminders = getUniqueRemindersBySparepart(reminders)

        VStack {
            VStack(alignment: .center, spacing: 8) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 20, weight: .bold))
                
                HStack {
                    Text("\(uniqueReminders.count)") 
                        .body(.emphasized)
                    
                    Text("pengingat terdaftar")
                        .body(.emphasized)
                }
                
                Text("Tapi jangan khawatir, waktunya masih jauh!")
                    .caption1(.regular)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(.white, lineWidth: 1)
                    .frame(width: 219, height: 32)

                Text("Cek seluruh pengingat")
                    .subhead(.regular)
            }
            .padding(.top, 8)
            .onTapGesture {
                routes.navigate(to: .AllReminderView)
            }
        }
        .padding(.top, 24)
        .background(Color.primary.tone100)
        .foregroundColor(Color.neutral.tint300)
    }

    private func getUniqueRemindersBySparepart(_ reminders: [Reminder]) -> [Reminder] {
        var uniqueReminders: [String: Reminder] = [:]

        for reminder in reminders {
            let sparepartKey = reminder.sparepart.rawValue
            if uniqueReminders[sparepartKey] == nil {
                uniqueReminders[sparepartKey] = reminder
            }
        }

        return Array(uniqueReminders.values)
    }
}


//#Preview {
//    struct PreviewContainer: View {
//        @State var reminders = [
//            Reminder(date: Date(), sparepart: .oliMesin, targetKM: 5000, kmInterval: 5000, dueDate: Date(), timeInterval: 6, vehicle: Vehicle(vehicleType: .car, brand: .honda), isRepeat: true, isDraft: false),
//            Reminder(date: Date(), sparepart: .filterUdara, targetKM: 15000, kmInterval: 15000, dueDate: Date(), timeInterval: 12, vehicle: Vehicle(vehicleType: .car, brand: .toyota), isRepeat: true, isDraft: false)
//        ]
//        
//        var body: some View {
//            ReminderHeader(reminders: reminders)
//        }
//    }
//    
//    return PreviewContainer()
//}


//import SwiftUI
//
//struct ReminderHeader: View {
//    @Binding var reminders: [SparepartReminder]
//
//    var body: some View {
//        VStack {
//            VStack(alignment: .center, spacing: 8) {
//                Image(systemName: "bell.fill")
//                    .font(.system(size: 20, weight: .bold))
//                
//                HStack {
//                    Text("\(reminders.count)")
//                        .body(.emphasized)
//                    
//                    Text("pengingat terdaftar")
//                        .body(.emphasized)
//                }
//                
//                Text("Tapi jangan khawatir, waktunya masih jauh!")
//                    .caption1(.regular)
//            }
//            
//            NavigationLink(destination: AllReminderView(reminders: $reminders)) {
//                ZStack {
//                    RoundedRectangle(cornerRadius: 12)
//                        .stroke(.white, lineWidth: 1)
//                        .frame(width: 219, height: 32)
//
//                    Text("Cek seluruh pengingat")
//                        .subhead(.regular)
//                }
//                .padding(.top, 8)
//            }
//        }
//        .padding(.top, 24)
//        .background(Color.primary.tone100)
//        .foregroundColor(Color.neutral.tint300)
//    }
//}
//
//#Preview {
//    struct PreviewContainer: View {
//        @State var reminders = [
//            SparepartReminder(sparepartName: "Oli Mesin", sparepartTargetKilometer: 5000, monthInterval: 6),
//            SparepartReminder(sparepartName: "Filter Udara", sparepartTargetKilometer: 15000, monthInterval: 12)
//        ]
//        
//        var body: some View {
//            ReminderHeader(reminders: $reminders)
//        }
//    }
//    
//    return PreviewContainer()
//}


