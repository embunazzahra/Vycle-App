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

    private var initialSelectedDate: Date
    private var initialSelectedNumber: Int
    private var initialSelectedSparepart: Sparepart
    
    var isAddReminderView: Bool = false

    @Binding var isResetHidden: Bool
    
    @State private var isDataUsed = false

    var isButtonEnabled: Bool {
        isPartChosen && isMonthYearChosen && isKilometerChosen
    }

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
         successNotification: @escaping () -> AnyView,
         isResetHidden: Binding<Bool>) {

        self.title = title
        self.successNotification = successNotification
        self._reminders = reminders
        self.reminderToEdit = reminderToEdit
        self._isResetHidden = isResetHidden

        if let reminder = reminderToEdit, !reminder.isDraft {
            self._selectedDate = State(initialValue: reminder.dueDate)
            self._selectedNumber = State(initialValue: Int(reminder.kmInterval))
            self._selectedSparepart = State(initialValue: reminder.sparepart)
            self.isPartChosen = true
            self.isMonthYearChosen = true
            self.isKilometerChosen = true
        } else {
            self._selectedDate = State(initialValue: selectedDate)
            self._selectedNumber = State(initialValue: selectedNumber)
            self._selectedSparepart = State(initialValue: selectedSparepart)
        }

        self.initialSelectedDate = self._selectedDate.wrappedValue
        self.initialSelectedNumber = self._selectedNumber.wrappedValue
        self.initialSelectedSparepart = self._selectedSparepart.wrappedValue
        
    }

    @State private var resetTrigger = false

    func resetToDefault() {
        if let savedReminder = reminderToEdit {
            selectedDate = savedReminder.dueDate
            selectedNumber = Int(savedReminder.kmInterval)
            selectedSparepart = savedReminder.sparepart
            isPartChosen = true
            isMonthYearChosen = true
            isKilometerChosen = true
            resetTrigger.toggle()
            
            // Delayed re-evaluation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                checkIfDataIsUsed()
            }
            
            print("Reset to default: isDataUsed:", isDataUsed)
        }
    }

    
    func getReminderData(vehicle: Vehicle, sparepart: Sparepart) -> (interval: Interval, dueDate: Date)? {
        guard let interval = vehicle.brand.intervalForSparepart(sparepart) else {
            return nil
        }
        
        let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: Date()) ?? Date()
        
        return (interval, dueDate)
    }


    var body: some View {
        ZStack {
            VStack {
                if isDataUsed == true || (reminders.contains(where: { $0.isUsingData == true }) && reminders.contains(where: { $0.isHelperOn })){
                    ZStack {
                        Rectangle()
                            .cornerRadius(12)
                            .foregroundColor(Color.primary.tint300)
                            .frame(height: 52)
                            .overlay(
                                  RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primary.base, lineWidth: 1)
                              )
                            .padding(.horizontal, 16)
                        HStack {
                            Spacer()
                            Image("Info_blue")
                                .padding(.bottom, 10)
                            Text("Pengingat yang disediakan merupakan data dari buku manual merk kendaraanmu")
                                .caption1(.regular)
                                .foregroundColor(Color.primary.base)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                    }
                    .padding(.top, 16)
                    .padding(.bottom, -16)
                }
                
                SparepartName(isPartChosen: $isPartChosen, isMonthYearChosen: $isMonthYearChosen, selectedDate: $selectedDate, selectedSparepart: $selectedSparepart)

                NextKilometer(isKilometerChosen: $isKilometerChosen, selectedNumber: $selectedNumber, showSheet: $showSheet)
                
                HStack {
                    Image(systemName: "info.circle.fill")
                        .padding(.bottom, 10)

                    Text(isKilometerChosen && isMonthYearChosen ? "Pengingat akan dijadwalkan setiap \(monthInterval) bulan atau \(selectedNumber) kilometer sekali" : "Pengingat akan dijadwalkan setiap 0 bulan atau 0 kilometer sekali")
                        .footnote(.regular)
                        .foregroundColor(Color.neutral.shade300)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                if !isResetHidden {
                    if selectedDate != initialSelectedDate || selectedNumber != initialSelectedNumber || selectedSparepart != initialSelectedSparepart || reminders.contains(where: { $0.reminderType != "Service Reminder" }) {
                        VStack(alignment: .leading) {
                            Text("Setelan awal")
                                .font(.headline)
                                .padding(.horizontal, 16)
                                .padding(.bottom, -4)
                            
                            ZStack {
                                Rectangle()
                                    .frame(height: 56)
                                    .cornerRadius(12)
                                    .foregroundColor(Color.neutral.tint300)
                                    .padding(.horizontal, 16)
                                
                                HStack {
                                    HStack {
                                        Image("question_mark")
                                            .padding(.bottom, 12)
                                        Text("Ingin mengikuti rekomendasi pengingat suku cadang?")
                                            .caption1(.regular)
                                    }
                                    .padding(.leading, 24)
                                    Spacer()
                                    
                                    Button(action: {
                                        if reminders.contains(where: {$0.isDraft == true}) {
                                            resetToDefault()
                                        } else {
                                            resetToData()
                                        }
                                    }) {
                                        HStack {
                                            Image("reset")
                                            Text("Atur ulang")
                                        }
                                        .foregroundColor(Color.primary.base)
                                        .padding(.trailing, 24)
                                    }
                                }
                                .padding(.horizontal, 8)
                            }
                        }
                        .padding(.bottom, 8)
                        .padding(.top, 24)
                    }
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
                            isDraft: false,
                            isHelperOn: false,
                            reminderType: "Edited Reminder",
                            isUsingData: false
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
                            isHelperOn: false,
                            reminderType: "Manual Reminder",
                            isUsingData: false
                        )
                    }
                }
                .padding(.bottom, 16)
            }
            .navigationTitle(title)
            .navigationBarBackButtonHidden(false)
            .navigationBarHidden(isNotificationShowed)
            .id(resetTrigger)

            if isNotificationShowed {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                successNotification()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut, value: isNotificationShowed)
//        .onAppear{
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                checkIfDataIsUsed()
//            }
//        }
        .onChange(of: selectedDate) { _ in checkIfDataIsUsed() }
        .onChange(of: selectedSparepart) { _ in checkIfDataIsUsed() }
        .onChange(of: selectedNumber) { _ in checkIfDataIsUsed() }
    }
    
        
    private func checkIfDataIsUsed() {
        guard let savedReminder = reminderToEdit,
              let vehicle = SwiftDataService.shared.getCurrentVehicle(),
              let reminderData = getReminderData(vehicle: vehicle, sparepart: savedReminder.sparepart) else {
            isDataUsed = false
            return
        }

        let expectedDate = reminderData.dueDate
        let expectedKilometer = Int(reminderData.interval.kilometer)
        let expectedSparepart = savedReminder.sparepart

        isDataUsed = (Calendar.current.isDate(selectedDate, equalTo: expectedDate, toGranularity: .day) &&
                      selectedNumber == expectedKilometer &&
                      selectedSparepart == expectedSparepart)

        print("isDataUsed: \(isDataUsed)")
    }

    func resetToData() {
        guard let vehicle = SwiftDataService.shared.getCurrentVehicle() else {
            print("No current vehicle found.")
            return
        }

        if let savedReminder = reminderToEdit, let reminderData = getReminderData(vehicle: vehicle, sparepart: savedReminder.sparepart) {
            let interval = reminderData.interval
            let dueDate = reminderData.dueDate

            selectedDate = dueDate
            selectedNumber = Int(interval.kilometer)
            selectedSparepart = savedReminder.sparepart
            isPartChosen = true
            isMonthYearChosen = true
            isKilometerChosen = true

            resetTrigger.toggle()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                checkIfDataIsUsed()
            }
            print("Reset to data: isDataUsed:", isDataUsed)
        } else {
            print("No valid reminder data found for the selected sparepart and vehicle.")
        }
    }
}



