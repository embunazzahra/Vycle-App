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
    
    @AppStorage("hasNewNotification") var hasNewNotification: Bool = false {
        didSet {
            print("notif in allreminderview\(hasNewNotification)")
        }
    }
    
    var sortedReminders: [Reminder] {
        let filteredReminders = remindersForSelectedMonthAndYear(from: latestReminders(from: reminders))
        return filteredReminders.sorted { $0.date < $1.date }
    }

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
                    .padding(.horizontal, 16)
                    .padding(.top, 24)
                    .padding(.bottom, 8)

                    if !sortedReminders.isEmpty {
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
            return []
        }
        let calendar = Calendar.current
        return uniqueReminders.filter {
            calendar.isDate($0.dueDate, equalTo: selectedDate, toGranularity: .month)
        }
    }

    private func latestReminders(from reminders: [Reminder]) -> [Reminder] {
        var latestReminders: [String: Reminder] = [:]

        for reminder in reminders {
            let sparepartKey = reminder.sparepart.rawValue
            if let existingReminder = latestReminders[sparepartKey], reminder.dueDate > existingReminder.dueDate {
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
        formatter.locale = Locale(identifier: "id_ID")
        return formatter.date(from: option)
    }
}


struct CustomScrollPicker: View {
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

