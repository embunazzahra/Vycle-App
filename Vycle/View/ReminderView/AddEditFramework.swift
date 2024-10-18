//
//  AddEditFramework.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

struct AddEditFramework: View {
    @EnvironmentObject var routes: Routes
    
    let title: String
    let successNotification: () -> AnyView
    
    @State private var isPartChosen = false
    @State private var isMonthYearChosen = false
    @State private var isKilometerChosen = false
    @State private var isNotificationShowed = false

    @State private var selectedMonth = 0
    @State private var selectedYear = Calendar.current.component(.year, from: Date()) - 2000
    
    @State private var selectedNumber = 1000
    @State private var selectedSparepart: SukuCadang
    @State private var showSheet = false
    
    @State var isToggleOn = false
    @Binding var reminders: [SparepartReminder]

    var isButtonEnabled: Bool {
        isPartChosen && isMonthYearChosen && isKilometerChosen
    }

    var monthInterval: Int {
        let calendar = Calendar.current
        let currentDate = Date()

        let currentComponents = calendar.dateComponents([.year, .month], from: currentDate)
        let currentYear = currentComponents.year ?? 0
        let currentMonth = currentComponents.month ?? 0

        let selectedFullYear = selectedYear + 2000
        let selectedFullMonth = selectedMonth + 1

        let yearDifference = selectedFullYear - currentYear
        let monthDifference = selectedFullMonth - currentMonth

        return (yearDifference * 12) + monthDifference
    }

    init(title: String, reminders: Binding<[SparepartReminder]>, selectedSparepart: SukuCadang, successNotification: @escaping () -> AnyView) {
            self.title = title
            self._reminders = reminders
            self.selectedSparepart = selectedSparepart
            self.successNotification = successNotification
        }

    var body: some View {

        ZStack {
//            NavigationStack {
                VStack {
                    SparepartName(isPartChosen: $isPartChosen, isMonthYearChosen: $isMonthYearChosen, selectedMonth: $selectedMonth, selectedYear: $selectedYear, selectedSparepart: $selectedSparepart, reminders: reminders)

                    NextKilometer(isKilometerChosen: $isKilometerChosen, selectedNumber: $selectedNumber, showSheet: $showSheet)
                    
                    VStack (alignment: .leading) {
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

                            let newReminder = SparepartReminder(
                                sparepartName: selectedSparepart.rawValue,
                                sparepartTargetKilometer: Double(selectedNumber),
                                monthInterval: monthInterval
                            )
                            reminders.append(newReminder)
                        }
                        .padding(.bottom, 16)
                    }
                }
                .navigationTitle(title)
                .navigationBarBackButtonHidden(false)
                .navigationBarHidden(isNotificationShowed)
//            }

            if isNotificationShowed {
                Color.black.opacity(0.6)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                successNotification()
            }
        }
    }
}

#Preview {
    let reminders: [SparepartReminder] = [] // Empty array of reminders
    return AddReminderView(reminders: .constant(reminders))
        .environmentObject(Routes())
}


