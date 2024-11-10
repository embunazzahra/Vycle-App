//
//  SparepartReminderCard.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI
import SwiftData

struct SparepartReminderCard: View {
    @Binding var reminder: Reminder
    var currentKM: Double
    @Environment(\.modelContext) var modelContext
    
    private var imageName: String {
        switch reminder.sparepart.rawValue {
        case "Oli mesin":
            return "Oli Mesin"
            
        case "Busi":
            return "Busi"

        case "Filter oli":
            return "Filter Oli"

        case "Minyak kopling":
            return "Minyak Kopling"

        case "Minyak rem":
            return "Minyak Rem"
            
        case "Oli transmisi":
            return "Oli Transmisi"
            
        case "Air coolant":
            return "Air Coolant"
            
        case "Filter udara":
            return "Filter Udara"
            
        case "Oli gardan":
            return "Oli Gardan"

        default:
            return ""
        }
    }

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 80)
                .cornerRadius(8)
                .foregroundColor(Color.background)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                .padding(.horizontal, 16)

            HStack {
                Image(imageName)
                    .resizable()
                    .frame(width: 80, height: 82)
                    .clipShape(RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 8))
                    .padding(.leading, 16)
                
                VStack(alignment: .leading) {
                    Text(reminder.sparepart.rawValue)
                        .subhead(.emphasized)
                        .foregroundColor(Color.neutral.shade300)
                        .padding(.bottom, 8)

                    ProgressBar(
                        currentKM: currentKM,
//                        maxKilometer: Double(reminder.targetKM) + ,
                        sparepart: reminder.sparepart,
                        reminder: $reminder
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
    @ObservedObject var locationManager: LocationManager
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]
    
    var totalDistance: Double {
        calculateTotalDistance() ?? 0
    }

    var body: some View {
        VStack {
            if reminders.isEmpty {
                Spacer()
                ReminderContentFar()
                Spacer()
            } else {
                List {
                    ForEach($reminders, id: \.self) { $reminder in
                        SparepartReminderCard(
                            reminder: $reminder,
                            currentKM: totalDistance
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
        .onChange(of: totalDistance) { newValue in
            print("Total distance traveled changed: \(newValue)")
        }
    }

    private func deleteReminder(at offsets: IndexSet) {
        guard let index = offsets.first, reminders.indices.contains(index) else {
            print("Invalid index")
            return
        }

        let sparepartToDelete = reminders[index].sparepart.rawValue
        print("Deleting all reminders with sparepart: \(sparepartToDelete)")

        let fetchDescriptor = FetchDescriptor<Reminder>()
        
        do {
            let allReminders = try context.fetch(fetchDescriptor)
            
            let remindersToDelete = allReminders.filter {
                $0.sparepart.rawValue.caseInsensitiveCompare(sparepartToDelete) == .orderedSame
            }
            
            remindersToDelete.forEach { reminder in
                NotificationManager.shared.cancelNotification(for: reminder)
                context.delete(reminder)
            }

            reminders.removeAll {
                $0.sparepart.rawValue.caseInsensitiveCompare(sparepartToDelete) == .orderedSame
            }

            try context.save()
            print("Context successfully saved.")
            
            refreshReminders()

        } catch {
            print("Failed to fetch or save context: \(error.localizedDescription)")
        }
    }
    
    private func refreshReminders() {
        let fetchDescriptor = FetchDescriptor<Reminder>()
        do {
            reminders = try context.fetch(fetchDescriptor)
        } catch {
            print("Failed to fetch reminders: \(error.localizedDescription)")
        }
    }

    private func calculateTotalDistance() -> Double? {
        let initialOdoValue = initialOdometer.last?.currentKM ?? 0
        if let firstLocation = locationHistory.first {
            return Double(initialOdoValue) + (firstLocation.distance ?? 0)
        } else {
            return Double(initialOdoValue)
        }
    }
}



