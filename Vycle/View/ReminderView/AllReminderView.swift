//
//  AllReminderView.swift
//  Vycle
//
//  Created by Clarissa Alverina on 08/10/24.
//
import SwiftUI
import SwiftData

struct AllReminderView: View {
    @Query private var reminders: [Reminder]
    @State private var selectedOption: String = ""
    @State private var availableOptions: [String] = []
    @State private var remindersCountByOption: [String: Int] = [:]

    @ObservedObject private var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if !availableOptions.isEmpty {
                CustomScrollPicker(
                    selectedOption: $selectedOption,
                    options: availableOptions,
                    reminderCounts: remindersCountByOption
                )
                .padding(.horizontal)
            }

            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
                    .ignoresSafeArea()

                VStack {
                    VStack(alignment: .leading) {
                        Text("Suku cadang sudah menanti di \(selectedOption)! 🗓️")
                            .subhead(.emphasized)
                            .foregroundColor(Color.neutral.shade300)
                        Text("Jangan Lupa! Pengingat suku cadang sudah ada")
                            .foregroundColor(Color.neutral.tone300)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)

                    let uniqueReminders = latestReminders(from: reminders)
                    let filteredReminders = remindersForSelectedMonthAndYear(from: uniqueReminders)

                    if !filteredReminders.isEmpty {
                        SparepartReminderListView(reminders: Binding(
                            get: { filteredReminders },
                            set: { newValue in }
                        ), locationManager: locationManager)
                    } else {
                        Text("No reminders available.")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }

                    Spacer()
                }
            }
        }
        .onAppear {
            loadAvailableOptionsAndCounts()
            selectedOption = availableOptions.first ?? ""
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.tone100)
        .navigationTitle("Pengingat terjadwal")
        .navigationBarBackButtonHidden(false)
    }

    // Update this function to take reminders as input
    private func remindersForSelectedMonthAndYear(from uniqueReminders: [Reminder]) -> [Reminder] {
        guard let selectedDate = getDateFrom(option: selectedOption) else {
            return []
        }
        let calendar = Calendar.current
        let filtered = uniqueReminders.filter {
            calendar.isDate($0.dueDate, equalTo: selectedDate, toGranularity: .month)
        }
//        print("Filtered reminders for \(selectedOption): \(filtered.hashValue)")
        return filtered
    }

    // Filter out duplicates first
    private func latestReminders(from reminders: [Reminder]) -> [Reminder] {
        var latestReminders: [String: Reminder] = [:]  // Key: sparepart name, Value: Reminder

        for reminder in reminders {
            let sparepartKey = reminder.sparepart.rawValue  
            
            if let existingReminder = latestReminders[sparepartKey] {
                if reminder.dueDate > existingReminder.dueDate {
//                    NotificationManager.shared.cancelNotification(for: existingReminder)
//                    print("Cancelled notification for existing reminder with sparepart: \(existingReminder.sparepart.rawValue), due: \(existingReminder.dueDate)")
//
//                    NotificationManager.shared.scheduleNotification(for: reminder)
//                    print("notif created for \(reminder.sparepart.rawValue), due\(reminder.dueDate)")
                    
                    latestReminders[sparepartKey] = reminder
                    print("Updated dictionary with new latest reminder for \(sparepartKey)")
                }
            } else {
                latestReminders[sparepartKey] = reminder
//                print("Added new reminder for \(sparepartKey) to dictionary")
            }
        }

        return Array(latestReminders.values)  // Return the unique reminders
    }

    private func loadAvailableOptionsAndCounts() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        
        let uniqueReminders = latestReminders(from: reminders)  // Get unique reminders
        let sortedReminders = uniqueReminders.sorted { $0.dueDate < $1.dueDate }
        
        var optionCountMap: [String: Int] = [:]
        
        for reminder in sortedReminders {
            let option = formatter.string(from: reminder.dueDate)
            optionCountMap[option, default: 0] += 1
        }
        
        availableOptions = Array(optionCountMap.keys).sorted {
            getDateFrom(option: $0)! < getDateFrom(option: $1)!
        }
        remindersCountByOption = optionCountMap
    }

    private func getDateFrom(option: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.date(from: option)
    }
}

struct CustomScrollPicker: View {
    @Binding var selectedOption: String
    let options: [String]
    let reminderCounts: [String: Int]  // New parameter to hold the reminder counts

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(options, id: \.self) { option in
                    VStack {
                        Text(option)
                            .subhead(.regular)
                        
                        HStack {
                            Text("\(reminderCounts[option] ?? 0)")
                                .subhead(.emphasized)
                            Text("pengingat")
                                .subhead(.emphasized)
                        }
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 5)
                    .foregroundColor(selectedOption == option ? .white : .white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(selectedOption == option ? Color.primary.shade200 : Color.clear)
                            .frame(width: 132, height: 52)
                    )
                    .onTapGesture {
                        withAnimation {
                            selectedOption = option
                        }
                    }
                }
            }
            .padding()
        }
    }
}


//#Preview {
//    @State var dummyReminders = [
//        Reminder(date: Date(), sparepart: .oliMesin, targetKM: 10000, kmInterval: 1000, dueDate: Date(), timeInterval: 3, vehicle: Vehicle(vehicleType: .car, brand: .honda), isRepeat: true, isDraft: false),
//        Reminder(date: Date(), sparepart: .filterUdara, targetKM: 15000, kmInterval: 1500, dueDate: Date(), timeInterval: 6, vehicle: Vehicle(vehicleType: .car, brand: .toyota), isRepeat: true, isDraft: false)
//    ]
//
//    AllReminderView(reminders: $dummyReminders) // No need to explicitly 'return' the view
//}







//import SwiftUI
//
//struct AllReminderView: View {
//    let options: [String] = ["September 2025", "Oktober 2025", "November 2025", "Desember 2025"]
//    @State private var selectedOption: String
//    @Binding var reminders: [SparepartReminder]
//
//    init(reminders: Binding<[SparepartReminder]>) {
//        self._reminders = reminders
//        self._selectedOption = State(initialValue: options[0])
//        setupNavigationBarWithoutScroll()
//    }
//    
//    var body: some View {
//        VStack {
//            CustomScrollPicker(selectedOption: $selectedOption, options: options)
//                .padding(.horizontal)
//            
//            ZStack {
//                Rectangle()
//                    .foregroundColor(.white)
//                    .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
//                    .ignoresSafeArea()
//                
//                VStack {
//                    VStack(alignment: .leading) {
//                        Text("Suku cadang sudah menanti di \(selectedOption)! 🗓️")
//                            .subhead(.emphasized)                            .foregroundColor(Color.neutral.shade300)
//                        Text("Jangan Lupa! Pengingat suku cadang sudah ada")
//                            .foregroundColor(Color.neutral.tone300)
//                            .font(.footnote)
//                            .multilineTextAlignment(.leading)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//                    .padding(16)
//                    
//                    if !reminders.isEmpty {
//                        SparepartReminderListView(reminders: $reminders)
//                    } else {
//                        Text("No data")
//                            .font(.headline)
//                            .foregroundColor(.gray)
//                    }
//                    
//                    Spacer()
//                }
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.primary.tone100)
//        .navigationTitle("Pengingat terjadwal")
//        .navigationBarBackButtonHidden(false)
//    }
//}
//
//struct CustomScrollPicker: View {
//    @Binding var selectedOption: String
//    let options: [String]
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 20) {
//                ForEach(options, id: \.self) { option in
//                    VStack {
//                        Text(option)
//                            .subhead(.regular)
//                        
//                        HStack {
//                            Text("0")
//                                .subhead(.emphasized)
//                            Text("pengingat")
//                                .subhead(.emphasized)
//                        }
//                    }
//                    .padding(.vertical, 10)
//                    .padding(.horizontal, 5)
//                    .foregroundColor(selectedOption == option ? .white : .white)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(selectedOption == option ? Color.primary.shade200 : Color.clear)
//                            .frame(width: 132, height: 52)
//                    )
//                    .onTapGesture {
//                        withAnimation {
//                            selectedOption = option
//                        }
//                    }
//                }
//            }
//            .padding()
//        }
//    }
//}
//
//#Preview {
//    let dummyReminders = [
//        SparepartReminder(sparepartName: "Oli", sparepartTargetKilometer: 10000, monthInterval: 3),
//        SparepartReminder(sparepartName: "Filter Udara", sparepartTargetKilometer: 15000, monthInterval: 6)
//    ]
//    
//    return AllReminderView(reminders: .constant(dummyReminders))
//}
