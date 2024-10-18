//
//  SparepartPicker.swift
//  Vycle
//
//  Created by Clarissa Alverina on 09/10/24.
//
import SwiftUI
import SwiftData

struct SparepartWheelPicker: View {
    @State private var showSheet = false
    @Binding var isPartChosen: Bool
    @Binding var selectedSparepart: Sparepart
    @Query var reminders: [Reminder]

    var body: some View {
        VStack {
            Button(action: {
                showSheet.toggle()
            }) {
                Text(isPartChosen ? selectedSparepart.rawValue : "Pilih suku cadang")
                    .subhead(.regular)
                    .padding(8)
                    .background(Color.neutral.tint200)
                    .foregroundColor(Color.neutral.shade300)
                    .cornerRadius(10)
            }
            .sheet(isPresented: $showSheet) {
                SparepartPickerSheet(isPartChosen: $isPartChosen, selectedSparepart: $selectedSparepart)
                    .presentationDetents([.medium])
            }
        }
        .padding()
    }
}


struct SparepartPickerSheet: View {
    @Environment(\.dismiss) var dismiss
    @Binding var isPartChosen: Bool
    @Binding var selectedSparepart: Sparepart
    @Query var reminders: [Reminder]

    var body: some View {
        VStack {
            HStack {
                Text("Suku cadang")
                    .title3(.emphasized)
                    .padding(.top, 16)
                    .padding(.leading, 16)
                Spacer()
            }
            
            Picker("Select a spare part", selection: $selectedSparepart) {
                ForEach(Sparepart.allCases.filter { part in
                    !reminders.contains(where: { $0.sparepart == part })
                }) { part in
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
