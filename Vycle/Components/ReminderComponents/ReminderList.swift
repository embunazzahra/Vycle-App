//
//  ReminderList.swift
//  Vycle
//
//  Created by Clarissa Alverina on 21/11/24.
//

import SwiftUI

struct ReminderList: View {
    @Binding var isPartChosen: Bool
    @Binding var isMonthYearChosen: Bool
    @Binding var selectedDate: Date
    @Binding var selectedSparepart: Sparepart
    @Binding var isKilometerChosen: Bool
    @Binding var selectedNumber: Int
    @Binding var showSheet: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(12)
                .frame(height: 168)
                .foregroundColor(Color.neutral.tint300)
                .padding(.horizontal, 16)
            
            VStack {
                HStack {
                    Text("Suku Cadang")
                        .foregroundColor(Color.neutral.shade300)
                    Spacer()
                    SparepartWheelPicker(isPartChosen: $isPartChosen, selectedSparepart: $selectedSparepart)
                }
                .padding(.horizontal, 24)
                .frame(height: 40)
                
                Divider()
                    .padding(.horizontal, 24)
                
                HStack {
                    Text("Bulan dan Tahun")
                        .foregroundColor(Color.neutral.shade300)

                    Spacer()
                    DateWheelPicker(selectedDate: $selectedDate, isMonthYearChosen: $isMonthYearChosen)
                }
                .padding(.horizontal, 24)
                .frame(height: 40)

                Divider()
                    .padding(.horizontal, 24)
                
                HStack {
                    Text("Interval Kilometer")
                        .foregroundColor(Color.neutral.shade300)

                    Spacer()
                    KilometerWheelPicker(selectedNumber: $selectedNumber, showSheet: $showSheet, isKilometerChosen: $isKilometerChosen)
                }
                .padding(.horizontal, 24)
                .frame(height: 40)

            }

        }
    }
}


