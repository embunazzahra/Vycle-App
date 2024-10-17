//
//  MonthYearPicker.swift
//  Vycle
//
//  Created by Clarissa Alverina on 09/10/24.
//

import SwiftUI

struct OBDateWheelPicker: View {
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
    
//    private var monthSymbols: [String] {
//        return Calendar.current.monthSymbols
//    }
}

struct DatePickerSheet: View {
    @Binding var selectedDate: Date
    @Environment(\.dismiss) var dismiss
    @Binding var isMonthYearChosen: Bool
    
    private let months = Calendar.current.monthSymbols
    private let years = Array(2000...Calendar.current.component(.year, from: Date()))
    
    @State private var selectedMonth = Calendar.current.component(.month, from: Date())
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
                
                HStack (spacing: 110){
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
                print("Selected Year: \(selectedYear), Selected Month: \(selectedMonth + 1), New Date: \(selectedDate)")
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
            // Return months up to the current month (0-indexed)
            return Array(0..<Calendar.current.component(.month, from: Date()))
        }
        // Return all months if the selected year is not the current year
        return Array(0..<months.count)
    }
    
    private func updateSelectedDate() {
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month], from: selectedDate)
        components.year = selectedYear
        components.month = selectedMonth + 1
        components.day = 2
        selectedDate = calendar.date(from: components) ?? Date().startOfMonth()
    }
}

