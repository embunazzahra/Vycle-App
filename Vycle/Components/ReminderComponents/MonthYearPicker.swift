//
//  MonthYearPicker.swift
//  Vycle
//
//  Created by Clarissa Alverina on 09/10/24.
//
import SwiftUI

struct DateWheelPicker: View {
    @Binding var selectedDate: Date
    @State private var showSheet = false
    @Binding var isMonthYearChosen: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                showSheet.toggle()
            }) {
                Text(isMonthYearChosen ? formattedSelectedDate : "MM/YYYY")
                    .subhead(.regular)
                    .padding(8)
                    .background(Color.neutral.tint200)
                    .foregroundColor(Color.neutral.shade300)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSheet) {
                DatePickerSheet(selectedDate: $selectedDate, isMonthYearChosen: $isMonthYearChosen)
                    .presentationDetents([.medium])
            }
        }
        .padding()
    }
    
    private var formattedSelectedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter.string(from: selectedDate)
    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    @Binding var isMonthYearChosen: Bool
    
    private let months = Calendar.current.monthSymbols
    private var years: [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return Array(currentYear...currentYear + 5)
    }
    
    @State private var selectedMonth = Calendar.current.component(.month, from: Date()) - 1
    @State private var selectedYear = Calendar.current.component(.year, from: Date())
    
    var body: some View {
        VStack {
            HStack {
                Text("Bulan dan tahun")
                    .title3(.emphasized)
                    .padding(.top, 32)
                    .padding(.leading, 16)
                Spacer()
            }
            
            ZStack {
                HStack {
                    Picker("Bulan", selection: $selectedMonth) {
                        ForEach(filteredMonths(), id: \.self) { index in
                            Text(months[index]).tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 254)
                    .clipped()
                    
                    Picker("Tahun", selection: $selectedYear) {
                        ForEach(years, id: \.self) { year in
                            Text(String(year)).tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 254)
                    .clipped()
                }
                .padding(.horizontal)
                
                HStack (spacing: 110) {
                    Rectangle()
                        .foregroundColor(Color.grayTint300)
                        .frame(width: 60, height: 32)
                        .cornerRadius(10)
                    Rectangle()
                        .foregroundColor(Color.grayTint300)
                        .frame(width: 36, height: 32)
                    Rectangle()
                        .foregroundColor(Color.grayTint300)
                        .frame(width: 60, height: 32)
                        .cornerRadius(10)
                }
            }
            
            CustomButton(title: "Pilih", iconPosition: .left, buttonType: .primary) {
                updateSelectedDate()
                isMonthYearChosen = true
                dismiss()
            }
            .padding(.top, 10)
            
            Spacer()
        }
        .onAppear {
            let calendar = Calendar.current
            selectedMonth = calendar.component(.month, from: selectedDate) - 1
            selectedYear = calendar.component(.year, from: selectedDate)
        }
    }
    
    private func filteredMonths() -> [Int] {
        if selectedYear == Calendar.current.component(.year, from: Date()) {
            return Array(Calendar.current.component(.month, from: Date())...11)
        }
        return Array(0..<months.count)
    }
    
    private func updateSelectedDate() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: selectedDate)
        components.year = selectedYear
        components.month = selectedMonth + 1
        components.day = 1
        selectedDate = calendar.date(from: components) ?? Date().startOfMonth()
    }
}

//import SwiftUI
//
//struct DateWheelPicker: View {
//    @Binding var selectedDate: Date
//    @Binding var showSheet: Bool
//    @Binding var isMonthYearChosen: Bool
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                showSheet.toggle()
//            }) {
//                Text(isMonthYearChosen ? formattedSelectedDate : "MM/YYYY")
//                    .subhead(.regular)
//                    .padding(8)
//                    .background(Color.neutral.tint200)
//                    .foregroundColor(Color.neutral.shade300)
//                    .cornerRadius(10)
//            }
//            .sheet(isPresented: $showSheet) {
//                DatePickerSheet(selectedDate: $selectedDate, isMonthYearChosen: $isMonthYearChosen)
//                    .presentationDetents([.medium])
//            }
//        }
//        .padding()
//    }
//
//    private var formattedSelectedDate: String {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "MM/yyyy"
//        return formatter.string(from: selectedDate)
//    }
//}
//
//struct DatePickerSheet: View {
//    @Binding var selectedDate: Date
//    @Environment(\.dismiss) var dismiss
//    @Binding var isMonthYearChosen: Bool
//
//    private let months = Calendar.current.monthSymbols
//    private var years: [Int] {
//        let currentYear = Calendar.current.component(.year, from: Date())
//        return Array(currentYear...currentYear + 5)
//    }
//
//    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date()) - 1
//    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
//
//    var body: some View {
//        VStack {
//            HStack {
//                Text("Bulan dan tahun")
//                    .title3(.emphasized)
//                    .padding(.top, 32)
//                    .padding(.leading, 16)
//                Spacer()
//            }
//
//            HStack {
//                Picker("Bulan", selection: $selectedMonth) {
//                    ForEach(0..<months.count, id: \.self) { index in
//                        Text(months[index]).tag(index)
//                    }
//                }
//                .pickerStyle(.wheel)
//                .frame(width: 150, height: 254)
//                .clipped()
//
//                Picker("Tahun", selection: $selectedYear) {
//                    ForEach(years, id: \.self) { year in
//                        Text(String(year)).tag(year)
//                    }
//                }
//                .pickerStyle(.wheel)
//                .frame(width: 150, height: 254)
//                .clipped()
//            }
//            .padding(.horizontal)
//
//            CustomButton(title: "Pilih", iconPosition: .left, buttonType: .primary) {
//                updateSelectedDate()
//                isMonthYearChosen = true
//                dismiss()
//            }
//            .padding(.top, 10)
//
//            Spacer()
//        }
//        .onAppear {
//            let calendar = Calendar.current
//            selectedMonth = calendar.component(.month, from: selectedDate) - 1 // Set the selected month on appear
//            selectedYear = calendar.component(.year, from: selectedDate) // Set the selected year on appear
//        }
//    }
//
//    private func updateSelectedDate() {
//        let calendar = Calendar.current
//        var components = calendar.dateComponents([.year, .month], from: selectedDate)
//        components.year = selectedYear
//        components.month = selectedMonth + 1 // Adjust for zero-based index
//        components.day = 1 // Set to the first day of the month
//        selectedDate = calendar.date(from: components) ?? Date() // Update the selected date
//    }
//}



