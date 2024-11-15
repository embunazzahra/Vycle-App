//
//  ReminderView.swift
//  Vycle
//
//  Created by Clarissa Alverina on 07/11/24.
//

import SwiftUI
import SwiftData

struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ReminderView: View {
    @Query var reminders: [Reminder]
    @EnvironmentObject var routes: Routes
    @ObservedObject var locationManager: LocationManager
    @State private var filteredReminders: [Reminder] = []
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]
    
    var totalDistance: Double {
        let initialOdoValue = initialOdometer.last?.currentKM ?? 0
        if let firstLocation = locationHistory.first {
            return Double(initialOdoValue) + (firstLocation.distance ?? 0)
        } else {
            return Double(initialOdoValue)
        }
    }
    
    @State private var selectedOption: String = ""
    @State private var availableOptions: [String] = []
    @State private var remindersCountByOption: [String: Int] = [:]
    
    @AppStorage("hasNewNotification") var hasNewNotification: Bool = false {
        didSet {
            print("notif in allreminderview\(hasNewNotification)")
        }
    }
    
    var sortedReminders: [Reminder] {
        let filteredReminders = remindersForSelectedMonthAndYear(from: latestReminders(from: reminders))
        
        return filteredReminders.sorted {
            let kmDifference1 = getKilometerDifference(currentKilometer: totalDistance, reminder: $0)
            let kmDifference2 = getKilometerDifference(currentKilometer: totalDistance, reminder: $1)
            
            if kmDifference1 == kmDifference2 {
                return $0.sparepart.rawValue < $1.sparepart.rawValue
            } else {
                return kmDifference1 < kmDifference2
            }
        }
    }

    var body: some View {
        VStack {
            VStack {
                if !reminders.isEmpty {
                    ReminderHeader(reminders: reminders)
                    if !availableOptions.isEmpty {
                        CustomScrollPickerWithDraft(
                            selectedOption: $selectedOption,
                            options: availableOptions,
                            reminderCounts: remindersCountByOption
                        )
                        .padding(.horizontal)
                        .padding(.bottom, -52)
                        .padding(.top, -16)
                    }
                } else {
                    ReminderHeaderNoData()
                }
            }
            .padding(.bottom, 40)
            .background(Color.primary.tone100)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.white)
                    .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
                    .ignoresSafeArea()
                
                VStack {
                    if !reminders.isEmpty {
                        if !sortedReminders.isEmpty {
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
                            .padding(.horizontal, 16)
                            .padding(.top, 24)
                            .padding(.bottom, 8)
                            
                            SparepartReminderListView(reminders: Binding(
                                get: { sortedReminders },
                                set: { _ in }
                            ), locationManager: locationManager)
                        } else {
                            Spacer()
                            Text("Tidak ada pengingat.")
                                .font(.headline)
                                .foregroundColor(.gray)
                            Spacer()
                        }
                    } else {
                        Spacer()
                        ReminderContentNoData()
                            .frame(width: 390)
                            .padding(.vertical, 8)
                        Spacer()
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            loadAvailableOptionsAndCounts()
            selectedOption = availableOptions.first ?? ""
            hasNewNotification = false
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.tone100)
        .navigationTitle("Pengingat terjadwal")
        .navigationBarBackButtonHidden(false)

    }
    
    private func remindersForSelectedMonthAndYear(from uniqueReminders: [Reminder]) -> [Reminder] {
        guard let selectedDate = getDateFrom(option: selectedOption) else {
            return uniqueReminders.filter { $0.isDraft }
        }
        
        let calendar = Calendar.current
        return uniqueReminders.filter {
            calendar.isDate($0.dueDate, equalTo: selectedDate, toGranularity: .month) && !$0.isDraft
        }
    }
    
    private func latestReminders(from reminders: [Reminder]) -> [Reminder] {
        var latestReminders: [String: Reminder] = [:]
        
        for reminder in reminders {
            let sparepartKey = reminder.sparepart.rawValue
            if let existingReminder = latestReminders[sparepartKey], reminder.date > existingReminder.date {
                latestReminders[sparepartKey] = reminder
            } else if latestReminders[sparepartKey] == nil {
                latestReminders[sparepartKey] = reminder
            }
        }
        
        return Array(latestReminders.values)
    }
    
    private func loadAvailableOptionsAndCounts() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        
        let uniqueReminders = latestReminders(from: reminders)
        let sortedReminders = uniqueReminders.filter { !$0.isDraft }.sorted { $0.dueDate < $1.dueDate }
        
        var optionCountMap: [String: Int] = [:]
        
        for reminder in sortedReminders {
            let option = formatter.string(from: reminder.dueDate)
            optionCountMap[option, default: 0] += 1
        }
        
        let draftCount = uniqueReminders.filter { $0.isDraft }.count
        if draftCount > 0 {
            optionCountMap["Drafts"] = draftCount
        }
        
        availableOptions = optionCountMap.keys.sorted {
            if $0 == "Drafts" { return true }
            if $1 == "Drafts" { return false }
            return getDateFrom(option: $0) ?? Date.distantPast < getDateFrom(option: $1) ?? Date.distantPast
        }
        remindersCountByOption = optionCountMap
    }



    private func getDateFrom(option: String) -> Date? {
        if option == "Drafts" {
            return nil
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.date(from: option)
    }

    
    private func getKilometerDifference(currentKilometer: Double, reminder: Reminder) -> Double {
        
        if reminder.dueDate <= Date() {
            return 0.0
        } else {
            if reminder.isDraft == true {
                return 0.0
            }
            else {
                return ceil(Double(reminder.kmInterval) - (currentKilometer - Double(reminder.reminderOdo)))
            }
        }
    }
}

struct CustomScrollPickerWithDraft: View {
    @Binding var selectedOption: String
    let options: [String]
    let reminderCounts: [String: Int]

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





