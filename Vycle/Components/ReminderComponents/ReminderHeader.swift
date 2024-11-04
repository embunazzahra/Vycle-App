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
    @AppStorage("hasNewNotification") var hasNewNotification: Bool = false{
        didSet {
            print("notif in reminderheader\(hasNewNotification)")
        }
    }
    

    var body: some View {
        let uniqueReminders = getUniqueRemindersBySparepart(reminders)

        VStack {
            VStack(alignment: .center, spacing: 8) {
//                Image("reminder_icon_blue")
//                    .font(.system(size: 20, weight: .bold))
                NotificationIconView(hasNewNotification: $hasNewNotification, iconName: "reminder_icon_white")
                
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


