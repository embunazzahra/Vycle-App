//
//  SparepartName.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

struct SparepartName: View {
    @Binding var isPartChosen: Bool
    @Binding var isMonthYearChosen: Bool

    @Binding var selectedMonth: Int
    @Binding var selectedYear: Int
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Nama suku cadang")
                .font(.headline)
                .padding(.horizontal, 16)
                .padding(.bottom, -4)
            
            ZStack {
                Rectangle()
                    .frame(height: 56)
                    .cornerRadius(12)
                    .foregroundColor(Color.neutral.tint300)
                    .padding(.horizontal, 16)
                
                HStack {
                    SparepartWheelPicker(isPartChosen: $isPartChosen)
                    Spacer()
                    
                    DateWheelPicker(selectedMonth: $selectedMonth, selectedYear: $selectedYear, isMonthYearChosen: $isMonthYearChosen)
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.bottom, 8)
        .padding(.top, 24)
    }
}


