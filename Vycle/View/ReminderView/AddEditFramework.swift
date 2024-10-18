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
    
    let title: String
    let successNotification: () -> AnyView
    
    @State private var isPartChosen = false
    @State private var isMonthYearChosen = false
    @State private var isKilometerChosen = false
    @State private var isNotificationShowed = false

    @State private var selectedDate: Date = Date().startOfMonth()
    @State private var selectedNumber = 1000
    @State private var selectedSparepart: Sparepart
    @State private var showSheet = false
    
    @State var isToggleOn = false
    @Binding var reminders: [Reminder]

    var isButtonEnabled: Bool {
        isPartChosen && isMonthYearChosen && isKilometerChosen
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

    init(title: String, reminders: Binding<[Reminder]>, selectedSparepart: Sparepart, successNotification: @escaping () -> AnyView) {
        self.title = title
        self._reminders = reminders
        self.selectedSparepart = selectedSparepart
        self.successNotification = successNotification
    }

    var body: some View {
        ZStack {
            VStack {
                SparepartName(isPartChosen: $isPartChosen, isMonthYearChosen: $isMonthYearChosen, selectedDate: $selectedDate, selectedSparepart: $selectedSparepart)
                NextKilometer(isKilometerChosen: $isKilometerChosen, selectedNumber: $selectedNumber, showSheet: $showSheet)
                
                VStack(alignment: .leading) {
                    Toggle(isOn: $isToggleOn) {
                        Text("Pengingat Repetitif")
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
                
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                        .frame(height: 137)
                        .foregroundColor(Color.neutral.tint300)

                    CustomButton(title: "Tambahkan Pengingat", iconName: "", iconPosition: .left, buttonType: isButtonEnabled ? .primary : .disabled) {
                        isNotificationShowed = true

                        let newReminder = Reminder(
                            date: Date(),
                            sparepart: selectedSparepart,
                            targetKM: Float(selectedNumber),
                            kmInterval: Float(selectedNumber),
                            dueDate: Date(),
                            timeInterval: monthInterval,
                            vehicle: Vehicle(vehicleType: .car, brand: .car(.honda)),
                            isRepeat: isToggleOn,
                            isDraft: false
                        )
                        
                        context.insert(newReminder)
                        reminders.append(newReminder)
                        
                        do {
                            try context.save()
                        } catch {
                            print("Failed to save new reminder: \(error.localizedDescription)")
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
            .navigationTitle(title)
            .navigationBarBackButtonHidden(false)
            .navigationBarHidden(isNotificationShowed)

            if isNotificationShowed {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
        
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


