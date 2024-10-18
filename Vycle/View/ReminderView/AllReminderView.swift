//
//  AllReminderView.swift
//  Vycle
//
//  Created by Clarissa Alverina on 08/10/24.
//

import SwiftUI
import SwiftData

struct AllReminderView: View {
    let options: [String] = ["September 2025", "Oktober 2025", "November 2025", "Desember 2025"]
    @State private var selectedOption: String
    @Query var reminders: [Reminder]
    @StateObject private var locationManager = LocationManager()

    init() {
        self._selectedOption = State(initialValue: options[0])
        setupNavigationBarWithoutScroll()
    }

    var body: some View {
        VStack {
            CustomScrollPicker(selectedOption: $selectedOption, options: options)
                .padding(.horizontal)
            
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
                    
                    if !reminders.isEmpty {
                        SparepartReminderListView(reminders: reminders)
//                        SparepartReminderListView(reminders: reminders, locationManager: locationManager)
                    } else {
                        Text("No data")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.primary.tone100)
        .navigationTitle("Pengingat terjadwal")
        .navigationBarBackButtonHidden(false)
    }
}



struct CustomScrollPicker: View {
    @Binding var selectedOption: String
    let options: [String]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                ForEach(options, id: \.self) { option in
                    VStack {
                        Text(option)
                            .subhead(.regular)
                        
                        HStack {
                            Text("0")
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
