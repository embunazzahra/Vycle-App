//
//  SparepartPicker.swift
//  Vycle
//
//  Created by Clarissa Alverina on 09/10/24.
//
import SwiftUI

struct OBSparepartWheelPicker: View {
    @Binding var selectedValue: Sparepart
    @State private var showSheet = false
    @Binding var isPartChosen: Bool
    var availableParts: [Sparepart]
    
    var body: some View {
        VStack {
            Button(action: {
                showSheet.toggle()
            }) {
                Text(isPartChosen ? selectedValue.rawValue : "Pilih suku cadang")
                    .subhead(.regular)
                    .padding(8)
                    .background(Color.neutral.tint200)
                    .foregroundColor(Color.neutral.shade300)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSheet) {
                OBSparepartPickerSheet(selectedValue: $selectedValue, isPartChosen: $isPartChosen, availableParts: availableParts)
                    .presentationDetents([.medium])
            }
        }
        .padding()
    }
}

struct OBSparepartPickerSheet: View {
    @Binding var selectedValue: Sparepart
    @Environment(\.dismiss) var dismiss
    @Binding var isPartChosen: Bool
    var availableParts: [Sparepart]
    
    var body: some View {
        VStack {
            HStack {
                Text("Suku cadang")
                    .title3(.emphasized)
                    .padding(.top, 32)
                    .padding(.leading, 16)
                Spacer()
            }
            
            Picker("Select a spare part", selection: $selectedValue) {
                ForEach(availableParts, id: \.self) { part in
                    Text(part.rawValue).tag(part)
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 254)
            .clipped()
            
            CustomButton(title: "Pilih", iconPosition: .left, buttonType: .primary) {
                isPartChosen = true
                dismiss()
            }
            .padding(.top, 10)
            
            Spacer()
        }
    }
}
