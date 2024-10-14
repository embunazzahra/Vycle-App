//
//  RepetitiveToggle.swift
//  Vycle
//
//  Created by Clarissa Alverina on 14/10/24.
//

import SwiftUI

struct RepetitiveToggle: View {
    @Binding var isToggleOn: Bool
    @Binding var isKilometerChosen: Bool
    @Binding var isMonthYearChosen: Bool
    @Binding var monthInterval: Int
    @Binding var selectedNumber: Int
    
    
    var body: some View {
        VStack (alignment: .leading) {
            Toggle(isOn: $isToggleOn) {
                Text("Pengingat Repetitif")
                    .font(.headline)
                    .foregroundColor(Color.neutral.shade300)
            }
            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
            .padding(.horizontal)
            
            if isToggleOn {
                HStack {
                    Image(systemName: "info.circle.fill")
                    Text(isKilometerChosen && isMonthYearChosen ? "Pengingat akan dijadwalkan setiap \(monthInterval) bulan atau \(selectedNumber) kilometer sekali" : "Pengingat akan dijadwalkan setiap 0 bulan atau 0 kilometer sekali")
                        .footnote(.regular)
                        .foregroundColor(Color.neutral.shade300)
                    
                    Spacer()
                }
                .padding(.leading, 16)
            }
            
        }
    }
}


