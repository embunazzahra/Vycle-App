//
//  SparepartReminderCard.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI
import SwiftData

struct SparepartReminderCard: View {
    var reminder: Reminder
    var currentKilometer: Double
    var serviceOdometer: Double

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 80)
                .cornerRadius(8)
                .foregroundColor(Color.background)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                .padding(.horizontal, 16)

            HStack {
                Rectangle()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 8))
                    .foregroundColor(Color.gray)
                    .padding(.leading, 16)

                VStack(alignment: .leading) {
                    Text(reminder.sparepart.rawValue)
                        .subhead(.emphasized)
                        .foregroundColor(Color.neutral.shade300)
                        .padding(.bottom, 8)

                    ProgressBar(
                        currentKilometer: currentKilometer,
                        maxKilometer: serviceOdometer + Double(reminder.kmInterval), serviceOdometer: serviceOdometer
                    )
                    .padding(.bottom, 3)
                }

                Spacer()
            }
        }
        .padding(.bottom, 12)
    }
}


struct SparepartReminderListView: View {
    @Binding var reminders: [Reminder]
    @Environment(\.modelContext) private var context
    @EnvironmentObject var routes: Routes 

    var currentKilometer: Double = 10
    var serviceOdometer: Double = 5

    var body: some View {
        VStack {
            if reminders.isEmpty {
//                Text("No Reminders Available")
//                    .font(.headline)
//                    .foregroundColor(.gray)
                Spacer()
                ReminderContentFar()
                Spacer()
            } else {
                List {
                    ForEach($reminders) { $reminder in
                        SparepartReminderCard(
                            reminder: reminder,
                            currentKilometer: currentKilometer,
                            serviceOdometer: serviceOdometer
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            routes.navigate(to: .EditReminderView(reminder: reminder))
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowSeparator(.hidden)
                        .listSectionSeparator(.hidden)
                    }
                    .onDelete(perform: deleteReminder)
                }
                .listStyle(PlainListStyle())
                .listRowSeparator(.hidden)
                .listSectionSeparator(.hidden)
            }
        }
    }

    private func deleteReminder(at offsets: IndexSet) {
        for index in offsets {
            guard reminders.indices.contains(index) else { continue }
            let reminderToDelete = reminders[index]
            context.delete(reminderToDelete)
        }
        do {
            try context.save()
        } catch {
            print("Failed to delete reminder: \(error.localizedDescription)")
        }
    }
}



    
    
//    import SwiftUI
//    import SwiftData
//
//    struct SparepartReminderCard: View {
//        var reminder: Reminder
//        var currentKilometer: Double
//        var serviceOdometer: Double
//
//        var body: some View {
//            ZStack {
//                Rectangle()
//                    .frame(height: 80)
//                    .cornerRadius(8)
//                    .foregroundColor(Color.background)
//                    .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
//                    .padding(.horizontal, 16)
//
//                HStack {
//                    Rectangle()
//                        .frame(width: 80, height: 80)
//                        .clipShape(RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 8))
//                        .foregroundColor(Color.gray)
//                        .padding(.leading, 16)
//
//                    VStack(alignment: .leading) {
//                        Text(reminder.sparepart.rawValue)
//                            .subhead(.emphasized)
//                            .foregroundColor(Color.neutral.shade300)
//                            .padding(.bottom, 8)
//
//                        ProgressBar(
//                            currentKilometer: currentKilometer,
//                            maxKilometer: serviceOdometer + Double(reminder.targetKM)
//                        )
//                        .padding(.bottom, 3)
//                    }
//
//                    Spacer()
//                }
//            }
//            .padding(.bottom, 12)
//        }
//    }
//
//    struct SparepartReminderListView: View {
//        var reminders: [Reminder]
//        @Environment(\.modelContext) private var context
//        @ObservedObject var locationManager: LocationManager
//        
//        var currentKilometer: Double {
//            locationManager.totalDistanceTraveled
//        }
//        
//        var serviceOdometer: Double = 10
//
//        var body: some View {
//            VStack {
//                if reminders.isEmpty {
//                    Text("No reminders available")
//                        .font(.headline)
//                        .foregroundColor(.gray)
//                } else {
//                    List {
//                        ForEach(reminders) { reminder in
//                            SparepartReminderCard(reminder: reminder, currentKilometer: currentKilometer, serviceOdometer: serviceOdometer)
//                                .listRowInsets(EdgeInsets())
//                        }
//                        .onDelete(perform: deleteReminder)
//                    }
//                    .listStyle(PlainListStyle())
//                    .listRowSeparator(.hidden)
//                }
//            }
//        }
//
//        private func deleteReminder(at offsets: IndexSet) {
//            print("Reminders before deletion: \(reminders)")
//
//            for index in offsets {
//                guard reminders.indices.contains(index) else { continue }
//                
//                let reminderToDelete = reminders[index]
//                print("Deleting reminder: \(reminderToDelete)")
//                context.delete(reminderToDelete)
//            }
//            
//            do {
//                try context.save()
//                print("Successfully deleted reminder(s).")
//            } catch {
//                print("Failed to delete reminder: \(error.localizedDescription)")
//            }
//        }
    
    
//    private func deleteReminder(at offsets: IndexSet) {
//        for index in offsets {
//            guard reminders.indices.contains(index) else { continue }
//
//            let reminderToDelete = reminders[index]
//            print("Deleting reminder: \(reminderToDelete) with vehicle: \(reminderToDelete.vehicle)")
//
//            // Make sure the context is valid and not nil
//            if context.hasChanges {
//                context.delete(reminderToDelete)
//            }
//        }
//        
//        do {
//            try context.save()
//            print("Successfully deleted reminder(s).")
//        } catch {
//            print("Failed to delete reminder: \(error.localizedDescription)")
//        }
//    }





//#Preview {
//    @State var reminders = [
//        SparepartReminder(sparepartName: "Busi", sparepartTargetKilometer: 20000, monthInterval: 6),
//        SparepartReminder(sparepartName: "Oli", sparepartTargetKilometer: 10000, monthInterval: 3),
//        SparepartReminder(sparepartName: "Filter Udara", sparepartTargetKilometer: 15000, monthInterval: 12)
//    ]
//    
//    return SparepartReminderListView(reminders: $reminders)
//}


