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
    @State private var isCancelShowed = false

    
    @State private var selectedDate: Date
    @State private var selectedNumber: Int
    @State private var selectedSparepart: Sparepart
    @State private var showSheet = false
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]
    

    @Binding var reminders: [Reminder]
    var reminderToEdit: Reminder?
    
    var isAddReminderView: Bool = false

    @Binding var isResetHidden: Bool
    
    @State private var isDataUsed: Bool

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
        } else if let reminder = reminderToEdit, reminder.isDraft {
            self._selectedDate = State(initialValue: selectedDate)
            self._selectedNumber = State(initialValue: selectedNumber)
            self._selectedSparepart = State(initialValue: reminder.sparepart)
            self.isPartChosen = true
        } else {
            self._selectedDate = State(initialValue: selectedDate)
            self._selectedNumber = State(initialValue: selectedNumber)
            self._selectedSparepart = State(initialValue: selectedSparepart)
        }

        self.isDataUsed = false
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                checkIfDataIsUsed()
            }
            
            print("Reset to default: isDataUsed:", isDataUsed)
        }
    }
    
//    func getReminderData(vehicle: Vehicle, sparepart: Sparepart) -> (interval: Interval, dueDate: Date)? {
//        guard let interval = vehicle.brand.intervalForSparepart(sparepart) else {
//            return nil
//        }
//        
//        let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: Date()) ?? Date()
//        
//        return (interval, dueDate)
//    }
    
//    func getReminderData(vehicle: Vehicle, sparepart: Sparepart) -> (interval: Interval, dueDate: Date)? {
//        guard let interval = vehicle.brand.intervalForSparepart(sparepart) else {
//            return nil
//        }
//        
//        let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: Date()) ?? Date()
//        
//        return (interval, dueDate)
//    }
    
    func getReminderData(vehicle: Vehicle, sparepart: Sparepart) -> (interval: Interval, dueDate: Date)? {
        guard let interval = vehicle.brand.intervalForSparepart(sparepart) else {
            return nil
        }
        
        let reminder = reminderToEdit?.date ?? Date()
        let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: reminder) ?? Date()
        
        return (interval, dueDate)
    }

    var body: some View {
        ZStack {
            VStack {
                if isDataUsed == true {
                    ZStack {
                        Rectangle()
                            .cornerRadius(12)
                            .foregroundColor(Color.primary.tint300)
                            .frame(height: 52)
                            .overlay(
                                  RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primary.base, lineWidth: 1)
                              )
                        HStack {
                            Image("Info_blue")
                                .padding(.bottom, 10)
                            Text("Pengingat yang disediakan merupakan data dari buku manual merk kendaraanmu")
                                .caption1(.regular)
                                .foregroundColor(Color.primary.base)
                            Spacer()
                        } .padding(.leading, 10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, -16)
                }
                
                if let reminderToEdit = reminderToEdit {
                    ZStack {
                        Rectangle()
                            .cornerRadius(8)
                            .frame(height: 36)
                            .foregroundColor(Color.neutral.tint100)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.neutral.tone300, lineWidth: 1)
                            )
                        
                        HStack {
                            Image("event")
                            
                            let dateFormatter: DateFormatter = {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MM/dd/yyyy"
                                return formatter
                            }()
                            
                            if reminderToEdit.reminderType == "Service Reminder" || reminderToEdit.reminderType == "Draft Reminder" {
                                Text("Pengingat berasal dari servis pada \(dateFormatter.string(from: reminderToEdit.date))")
                                    .caption1(.regular)
                                    .foregroundColor(Color.neutral.tone300)
                            } else if reminderToEdit.reminderType == "Manual Reminder" || reminderToEdit.reminderType == "Edited Reminder" {
                                Text("Pengingat dibuat secara manual pada \(dateFormatter.string(from: reminderToEdit.date))")
                                    .caption1(.regular)
                                    .foregroundColor(Color.neutral.tone300)
                            }
                            
                            Spacer()
                        }
                        .padding(.leading, 10)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, -16)
                }

                SparepartName(isPartChosen: $isPartChosen, isMonthYearChosen: $isMonthYearChosen, selectedDate: $selectedDate, selectedSparepart: $selectedSparepart)

                NextKilometer(isKilometerChosen: $isKilometerChosen, selectedNumber: $selectedNumber, showSheet: $showSheet)
                
                HStack {
                    (Text("Catatan: ").bold() +
                     Text(isKilometerChosen && isMonthYearChosen ?
                          "Pengingat akan dijadwalkan setiap \(monthInterval) bulan atau \(selectedNumber) kilometer sekali" :
                          "Pengingat akan dijadwalkan setiap 0 bulan atau 0 kilometer sekali"))
                        .footnote(.regular)
                        .foregroundColor(Color.neutral.shade300)

                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                if let reminderToEdit = reminderToEdit {
                    if reminderToEdit.isDraft == false {
                        if isDataUsed == false {
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
                            .padding(.top, 12)
                        }
                    }
                }
                
                Spacer()
                
                CustomButton(title: reminderToEdit == nil ? "Tambahkan Pengingat" : "Simpan Perubahan", iconName: "add_box", iconPosition: .left, buttonType: isButtonEnabled ? .primary : .disabled) {
                    isNotificationShowed = true

                    if let reminderToEdit = reminderToEdit {
                        if reminderToEdit.isDraft == true {
                            swiftDataService.editDraft(
                                reminder: reminderToEdit,
                                sparepart: selectedSparepart,
                                reminderOdo: reminderOdo,
                                kmInterval: Float(selectedNumber),
                                dueDate: selectedDate.startOfMonth(),
                                timeInterval: monthInterval,
                                isRepeat: true,
                                isDraft: false,
                                isHelperOn: true,
                                reminderType: "Edited Reminder",
                                isEdited: true,
                                date: Date()
                                )
                        } else {
                            swiftDataService.editReminder(
                                reminder: reminderToEdit,
                                sparepart: selectedSparepart,
                                kmInterval: Float(selectedNumber),
                                dueDate: selectedDate.startOfMonth(),
                                timeInterval: monthInterval,
                                isRepeat: true,
                                isDraft: false,
                                isHelperOn: false,
                                reminderType: "Edited Reminder",
                                isEdited: true
                                )
                        }

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
                            isEdited: false
                        )
                    }
                }
                
                if !isResetHidden {
                    Button(action: {
                        isCancelShowed = true
                        if let reminderToEdit = reminderToEdit {
                            deleteReminder(reminder: reminderToEdit)
                        }
                    }) {
                        HStack {
                            Image("delete")
                            Text("Hapus Pengingat")
                                .foregroundColor(Color.persianRed500)
                                .body(.regular)
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle(title)
            .navigationBarBackButtonHidden(false)
            .navigationBarHidden(isNotificationShowed || isCancelShowed)
            .id(resetTrigger)

            if isNotificationShowed {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                successNotification()
                    .transition(.opacity)
            }
            
            if isCancelShowed {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    Rectangle()
                        .frame(width: 261, height: 300)
                        .cornerRadius(12)
                        .foregroundStyle(Color.neutral.tint300)
                    
                    VStack {
                        Spacer()
                        Image("cancel icon")
                        Text("Yakin Nih?")
                            .title2(.emphasized)
                            .foregroundColor(Color.neutral.tone300)
                            .padding(.bottom, 2)
                        Text("Pengingat suku cadang ini tidak akan muncul di daftar pengingat lhoo")
                            .callout(.regular)
                            .foregroundColor(Color.neutral.tone100)
                            .frame(width: 200)
                            .multilineTextAlignment(.center)
                          
                        Button(action: {
                            isCancelShowed = false
                        }) {
                            ZStack {
                                Rectangle()
                                    .frame(width: 128, height: 40)
                                    .cornerRadius(12)
                                    .foregroundColor(Color.blueLoyaltyTone100)
                                Text("Tetap simpan")
                                    .body(.regular)
                                    .foregroundColor(Color.neutral.tint300)
                            }
                        }
                        .padding(.top, 10)
                        
                        Button(action: {
                            
                            if let reminderToEdit = reminderToEdit {
                                deleteReminder(reminder: reminderToEdit)
                            }
                            routes.navigateBack()
                        }) {
                           Text("Lanjutkan hapus")
                                .body(.regular)
                                .foregroundColor(Color.persianRed500)
                        }
                        .padding(1)

                        Spacer()
                    }
                } .transition(.opacity)
            }
            
        }
        .animation(.easeInOut, value: isNotificationShowed)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                checkIfDataIsUsed()
            }
        }

        .onChange(of: selectedDate) { _ in checkIfDataIsUsed() }
        .onChange(of: selectedSparepart) { _ in checkIfDataIsUsed() }
        .onChange(of: selectedNumber) { _ in checkIfDataIsUsed() }
    }
    
    private func deleteReminder(reminder: Reminder?) {
        guard let reminder = reminder else { return }

        let sparepartToDelete = reminder.sparepart.rawValue
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

        isDataUsed = (Calendar.current.isDate(selectedDate, equalTo: expectedDate, toGranularity: .month) &&
                      selectedNumber == expectedKilometer &&
                      selectedSparepart == expectedSparepart)

        
        print("tanggal reminder dibuat: \(reminderToEdit?.date)")
        print("isDataUsed: \(isDataUsed)")
        
        print("expectedDate: \(expectedDate)")
        print("selectedDate: \(selectedDate)")
        print("expectedKilometer: \(expectedKilometer)")
        print("selectedKilometer: \(selectedNumber )")
        print("expectedSparepart: \(expectedSparepart)")
        print("selectedSparepart: \(selectedSparepart)")
        
        
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



