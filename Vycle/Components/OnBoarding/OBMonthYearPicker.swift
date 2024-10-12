//
//  MonthYearPicker.swift
//  Vycle
//
//  Created by Clarissa Alverina on 09/10/24.
//
import SwiftUI

struct OBDateWheelPicker: View {
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @State private var showSheet = false
    @Binding var isMonthYearChosen: Bool
    
    var body: some View {
        VStack {
            Button(action: {
                showSheet.toggle()
            }) {
                Text(isMonthYearChosen ? String(format: "%02d/%d", selectedMonth + 1, selectedYear + 2000) : "MM/YYYY")
                    .subhead(.regular)
                    .padding(8)
                    .background(Color.neutral.tint200)
                    .foregroundColor(Color.neutral.shade300)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSheet) {
                DatePickerSheet(selectedMonth: $selectedMonth, selectedYear: $selectedYear, isMonthYearChosen: $isMonthYearChosen)
                    .presentationDetents([.medium])
            }
        }
        .padding()
    }
    
    private var monthSymbols: [String] {
        return Calendar.current.monthSymbols
    }
}

struct DatePickerSheet: View {
    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    @Environment(\.dismiss) var dismiss
    @Binding var isMonthYearChosen: Bool
    
    private let months = Calendar.current.monthSymbols
    private let years = Array(2000...Calendar.current.component(.year, from: Date()))
    
    var body: some View {
        VStack {
            HStack {
                Text("Bulan dan tahun")
                    .title3(.emphasized)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                Spacer()
            }
            
            ZStack {
                HStack {
                    Picker("Bulan", selection: $selectedMonth) {
                        ForEach(0..<months.count, id: \.self) { index in
                            Text(months[index]).tag(index)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(width: 150, height: 254)
                    .clipped()
                    
                    Picker("Tahun", selection: $selectedYear) {
                        ForEach(0..<years.count, id: \.self) { index in
                            Text(String(format: "%d", years[index])).tag(index)
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
                isMonthYearChosen = true
                dismiss()
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
}
