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
    @State private var isToggleOn = false
    @State private var showSheet = false
//    @State private var serviceOdometer: Float = 0 // Assuming you'll fetch this value
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]


    @Binding var reminders: [Reminder]
    var reminderToEdit: Reminder?

    var isButtonEnabled: Bool {
        isPartChosen && isMonthYearChosen && isKilometerChosen
    }

    var reminderOdo: Float {
        return Float(initialOdometer.last?.currentKM ?? 0)
    }
    
    var targetKM: Float {
        return Float(selectedNumber) + Float(initialOdometer.last?.currentKM ?? 0)
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
         selectedNumber: Int = 1,
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
            self.isToggleOn = reminder.isRepeat
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

                VStack(alignment: .leading) {
                    Toggle(isOn: $isToggleOn) {
                        Text("Pengingat berulang")
                            .font(.headline)
                            .foregroundColor(Color.neutral.shade300)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                    .padding(.horizontal)

                    if isToggleOn {
                        HStack {
                            Image(systemName: "info.circle.fill")
                            Text(isKilometerChosen && isMonthYearChosen ? "Pengingat akan dijadwalkan setiap \(monthInterval) bulan atau \(selectedNumber) kilometer sekali" : "Pengingat akan dijadwalkan setiap 0 bulan atau 0 kilometer sekali")
                                .footnote(.regular)
                                .foregroundColor(Color.neutral.shade300)
                            
                            Spacer()
                        }
                        .padding(.leading, 16)
                    }
                }

                Spacer()

                CustomButton(title: reminderToEdit == nil ? "Tambahkan Pengingat" : "Edit Pengingat", iconName: "", iconPosition: .left, buttonType: isButtonEnabled ? .primary : .disabled) {
                    isNotificationShowed = true

                    if let reminderToEdit = reminderToEdit {
                        swiftDataService.editReminder(
                            reminder: reminderToEdit,
                            sparepart: selectedSparepart,
                            reminderOdo: reminderOdo,
                            kmInterval: Float(selectedNumber),
                            dueDate: selectedDate.startOfMonth(),
                            timeInterval: monthInterval,
                            vehicle: SwiftDataService.shared.getCurrentVehicle()!,
                            isRepeat: isToggleOn,
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
                            isRepeat: isToggleOn,
                            isDraft: false
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




//#Preview {
//    let reminders: [Reminder] = [] // Empty array of reminders
//    return AddEditFramework(title: "Add/Edit Reminder", reminders: .constant(reminders), selectedSparepart: .oliMesin) // Adjust the selected spare part as needed
//        .environmentObject(Routes())
//}


//import SwiftUI
//
//struct AddEditFramework: View {
//    @EnvironmentObject var routes: Routes
//    
//    let title: String
//    let successNotification: () -> AnyView
//    
//    @State private var isPartChosen = false
//    @State private var isMonthYearChosen = false
//    @State private var isKilometerChosen = false
//    @State private var isNotificationShowed = false
//
//    @State private var selectedDate: Date = Date().startOfMonth()
//    
//    @State private var selectedNumber = 1000
//    @State private var selectedSparepart: Sparepart
//    @State private var showSheet = false
//    
//    @State var isToggleOn = false
//    @Binding var reminders: [SparepartReminder]
//
//    var isButtonEnabled: Bool {
//        isPartChosen && isMonthYearChosen && isKilometerChosen
//    }
//
//    var monthInterval: Int {
//        let calendar = Calendar.current
//        let currentDate = Date()
//
//        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
//        let currentYear = currentComponents.year ?? 0
//        let currentMonth = currentComponents.month ?? 0
//
//        let selectedFullYear = Calendar.current.component(.year, from: selectedDate)
//        let selectedFullMonth = Calendar.current.component(.month, from: selectedDate)
//
//        let yearDifference = selectedFullYear - currentYear
//        let monthDifference = selectedFullMonth - currentMonth
//
//        return (yearDifference * 12) + monthDifference
//    }
//
//    init(title: String, reminders: Binding<[SparepartReminder]>, selectedSparepart: Sparepart, successNotification: @escaping () -> AnyView) {
//            self.title = title
//            self._reminders = reminders
//            self.selectedSparepart = selectedSparepart
//            self.successNotification = successNotification
//        }
//
//    var body: some View {
//
//        ZStack {
////            NavigationStack {
//                VStack {
//                    SparepartName(isPartChosen: $isPartChosen, isMonthYearChosen: $isMonthYearChosen, selectedDate: $selectedDate, selectedSparepart: $selectedSparepart, reminders: reminders)
//                    NextKilometer(isKilometerChosen: $isKilometerChosen, selectedNumber: $selectedNumber, showSheet: $showSheet)
//                    
//                    VStack (alignment: .leading) {
//                        Toggle(isOn: $isToggleOn) {
//                            Text("Pengingat Repetitif")
//                                .font(.headline)
//                                .foregroundColor(Color.neutral.shade300)
//                        }
//                        .toggleStyle(SwitchToggleStyle(tint: Color.blue))
//                        .padding(.horizontal)
//                        
//                        if isToggleOn {
//                            HStack {
//                                Image(systemName: "info.circle.fill")
//                                Text(isKilometerChosen && isMonthYearChosen ? "Pengingat akan dijadwalkan setiap \(monthInterval) bulan atau \(selectedNumber) kilometer sekali" : "Pengingat akan dijadwalkan setiap 0 bulan atau 0 kilometer sekali")
//                                    .footnote(.regular)
//                                    .foregroundColor(Color.neutral.shade300)
//                                
//                                Spacer()
//                            }
//                            .padding(.leading, 16)
//                        }
//                        
//                    }
//                    
//                    Spacer()
//                    
//                    ZStack {
//                        Rectangle()
//                            .ignoresSafeArea()
//                            .frame(height: 137)
//                            .foregroundColor(Color.neutral.tint300)
//
//                        CustomButton(title: "Tambahkan Pengingat", iconName: "", iconPosition: .left, buttonType: isButtonEnabled ? .primary : .disabled) {
//                            isNotificationShowed = true
//
//                            let newReminder = SparepartReminder(
//                                sparepartName: selectedSparepart.rawValue,
//                                sparepartTargetKilometer: Double(selectedNumber),
//                                monthInterval: monthInterval
//                            )
//                            reminders.append(newReminder)
//                        }
//                        .padding(.bottom, 16)
//                    }
//                }
//                .navigationTitle(title)
//                .navigationBarBackButtonHidden(false)
//                .navigationBarHidden(isNotificationShowed)
////            }
//
//            if isNotificationShowed {
//                Color.black.opacity(0.6)
//                    .edgesIgnoringSafeArea(.all)
//                    .transition(.opacity)
//                successNotification()
//            }
//        }
//    }
//}
//
//#Preview {
//    let reminders: [SparepartReminder] = [] // Empty array of reminders
//    return AddReminderView(reminders: .constant(reminders))
//        .environmentObject(Routes())
//}


