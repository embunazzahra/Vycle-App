//
//  AddReminder.swift
//  Vycle
//
//  Created by Clarissa Alverina on 08/10/24.
//

import SwiftUI

struct AddReminderView: View {

    var body: some View {
        VStack (alignment: .leading) {
            Text("Nama suku cadang")
                .headline()
                .padding(.horizontal, 16)
                .padding(.bottom, -4)
            
            ZStack {
                Rectangle()
                    .frame(height: 56)
                    .cornerRadius(12)
                    .foregroundColor(Color.neutral.tint300)
                    .padding(.horizontal, 16)
                
                HStack {
                    SparepartWheelPicker()
                    Spacer()
                    DateWheelPicker()
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.bottom, 8)
        
        VStack (alignment: .leading) {
            Text("Kilometer selanjutnya")
                .headline()
                .padding(.horizontal, 16)
                .padding(.bottom, -4)
            
            ZStack {
                Rectangle()
                    .frame(height: 56)
                    .cornerRadius(12)
                    .foregroundColor(Color.neutral.tint300)
                    .padding(.horizontal, 16)
                
                HStack {
                    SparepartWheelPicker()
                    Spacer()
                    DateWheelPicker()
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.bottom, 8)
    }
}


struct SparepartWheelPicker: View {
    @State private var selectedValue = 0
    @State private var showSheet = false
    let values = ["Busi", "Oli Mesin", "Filter Oli", "Minyak Rem", "Filter Udara", "Filter Bensin", "Air Radiator", "Oli Gardan"]
    
    var body: some View {
        VStack {
            Button(action: {
                showSheet.toggle()
            }) {
                Text("Pilih suku cadang")
                    .subhead(.regular)
                    .padding(8)
                    .background(Color.neutral.tint200)
                    .foregroundColor(Color.neutral.shade300)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSheet) {
                SparepartPickerSheet(selectedValue: $selectedValue, values: values)
                    .presentationDetents([.medium])
            }
        }
        .padding()
    }
}

struct SparepartPickerSheet: View {
    @Binding var selectedValue: Int
    let values: [String]
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            HStack {
                Text("Suku cadang")
                    .title3(.emphasized)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                Spacer()
            }
            
            Picker("Select a sparepart", selection: $selectedValue) {
                ForEach(0..<values.count) { index in
                    Text(values[index]).tag(index)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 254)
            .clipped()
            
            CustomButton(title: "Pilih",  symbolName: "", isEnabled: true) {
                dismiss()
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
}

struct DateWheelPicker: View {
    @State private var selectedMonth = 0
    @State private var selectedYear = Calendar.current.component(.year, from: Date()) - 2000
    @State private var showSheet = false
    
    var body: some View {
        VStack {
            Button(action: {
                showSheet.toggle()
            }) {
                Text("MM/YYYY")
                    .subhead(.regular)
                    .padding(8)
                    .background(Color.neutral.tint200)
                    .foregroundColor(Color.neutral.shade300)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSheet) {
                DatePickerSheet(selectedMonth: $selectedMonth, selectedYear: $selectedYear)
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
            
            CustomButton(title: "Pilih", symbolName: "", isEnabled: true) {
                dismiss()
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
}

#Preview {
    AddReminderView()
}
