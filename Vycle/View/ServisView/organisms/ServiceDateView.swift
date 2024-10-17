//
//  ServiceDateView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 11/10/24.
//

import SwiftUI

struct ServiceDateView: View {
    @Binding var selectedDate: Date
    @Binding var showDatePicker: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text("Tanggal servis")
                .font(.headline)
            
            Button(action: {
                showDatePicker = true
            }){
                Text(selectedDate.formattedDate())
                    .padding(.vertical, 9)
                    .padding(.horizontal, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.neutral.shade300, lineWidth: 1)
                    )
                    .foregroundStyle(.grayShade300)
            }
            .sheet(isPresented: $showDatePicker) {
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        in: ...Date(),
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    CustomButton(title: "Pilih") {
                        showDatePicker = false
                    }
                }
                .presentationDetents([.height(527)])
                .presentationDragIndicator(.visible)
//                .background(Color.background)
            }
        }
        .tint(.accentColor)
    }
}
