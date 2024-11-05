//
//  AddEditFramework.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI
import SwiftData

struct AddEditFramework: View {
    @EnvironmentObject var routes: Routes
    @Environment(\.modelContext) private var context
    let swiftDataService = SwiftDataService.shared

    let title: String
    let successNotification: () -> AnyView

    @State private var isPartChosen = false
    @State private var isMonthYearChosen = false
    @State private var isKilometerChosen = false
    @State private var isNotificationShowed = false

    @State private var selectedDate: Date
    @State private var selectedNumber: Int
    @State private var selectedSparepart: Sparepart
    @State private var showSheet = false
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]

    @Binding var reminders: [Reminder]
    
    var reminderToEdit: Reminder?

    var isButtonEnabled: Bool {
        isPartChosen && isMonthYearChosen && isKilometerChosen
    }

    // Calculate total distance based on initial odometer and location history
    var totalDistance: Double {
        let initialOdoValue = initialOdometer.last?.currentKM ?? 0
        if let firstLocation = locationHistory.first {
            return Double(initialOdoValue) + (firstLocation.distance ?? 0)
        } else {
            return Double(initialOdoValue)
        }
    }

    var reminderOdo: Float {
        return Float(totalDistance)
    }
    
    var targetKM: Float {
        return Float(selectedNumber) + Float(totalDistance)
    }

    var monthInterval: Int {
        let calendar = Calendar.current
        let currentDate = Date()
        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
        let currentYear = currentComponents.year ?? 0
        let currentMonth = currentComponents.month ?? 0

        let selectedFullYear = Calendar.current.component(.year, from: selectedDate)
        let selectedFullMonth = Calendar.current.component(.month, from: selectedDate)

        let yearDifference = selectedFullYear - currentYear
        let monthDifference = selectedFullMonth - currentMonth

        return (yearDifference * 12) + monthDifference
    }

    init(title: String, reminders: Binding<[Reminder]>, selectedSparepart: Sparepart,
         selectedDate: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date().startOfMonth()) ?? Date().startOfMonth(),
         selectedNumber: Int = 1000,
         reminderToEdit: Reminder? = nil,
         successNotification: @escaping () -> AnyView) {
        self.title = title
        self._reminders = reminders
        self.reminderToEdit = reminderToEdit

        if let reminder = reminderToEdit {
            self.selectedSparepart = reminder.sparepart
            self.selectedDate = reminder.dueDate
            self.selectedNumber = Int(reminder.kmInterval)
            self.isPartChosen = true
            self.isMonthYearChosen = true
            self.isKilometerChosen = true
        } else {
            self.selectedSparepart = selectedSparepart
            self.selectedDate = selectedDate
            self.selectedNumber = selectedNumber
        }

        self.successNotification = successNotification
    }

    var body: some View {
        ZStack {
            VStack {
                SparepartName(isPartChosen: $isPartChosen, isMonthYearChosen: $isMonthYearChosen, selectedDate: $selectedDate, selectedSparepart: $selectedSparepart)

                NextKilometer(isKilometerChosen: $isKilometerChosen, selectedNumber: $selectedNumber, showSheet: $showSheet)
                
                if reminders.contains(where: { $0.isHelperOn }) {
                    HStack {
                        Spacer()
                        Text("Kilometer di atas berdasarkan buku manual merk kendaraan")
                            .footnote(.regular)
                            .foregroundColor(Color.neutral.tone100)
                        Spacer()
                    }
                    .padding(.trailing, 20)
                }

                Spacer()

                CustomButton(title: reminderToEdit == nil ? "Tambahkan Pengingat" : "Edit Pengingat", iconName: "add_box", iconPosition: .left, buttonType: isButtonEnabled ? .primary : .disabled) {
                    isNotificationShowed = true

                    if let reminderToEdit = reminderToEdit {
                        swiftDataService.editReminder(
                            reminder: reminderToEdit,
                            sparepart: selectedSparepart,
                            reminderOdo: reminderOdo,
                            kmInterval: Float(selectedNumber),
                            dueDate: selectedDate.startOfMonth(),
                            timeInterval: monthInterval,
                            isRepeat: true,
                            isDraft: false
                        )
                    } else {
                        swiftDataService.insertReminder(
                            sparepart: selectedSparepart,
                            reminderOdo: reminderOdo,
                            kmInterval: Float(selectedNumber),
                            dueDate: selectedDate.startOfMonth(),
                            timeInterval: monthInterval,
                            vehicle: SwiftDataService.shared.getCurrentVehicle()!,
                            isRepeat: true,
                            isDraft: false,
                            isHelperOn: false
                        )
                    }
                }
                .padding(.bottom, 16)
            }
            .navigationTitle(title)
            .navigationBarBackButtonHidden(false)
            .navigationBarHidden(isNotificationShowed)

            if isNotificationShowed {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                successNotification()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isNotificationShowed)
    }
}



