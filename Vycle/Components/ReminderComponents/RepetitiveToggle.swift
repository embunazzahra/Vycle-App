//
//  RepetitiveToggle.swift
//  Vycle
//
//  Created by Clarissa Alverina on 14/10/24.
//

import SwiftUI

struct RepetitiveToggle: View {
//    @Binding var isToggleOn: Bool
//    @Binding var isKilometerChosen: Bool
//    @Binding var isMonthYearChosen: Bool
//    @Binding var monthInterval: Int
//    @Binding var selectedNumber: Int
//    
    
    var body: some View {
        VStack (alignment: .leading) {
//            Toggle(isOn: $isToggleOn) {
//                Text("Pengingat berulang")
//                    .font(.headline)
//                    .foregroundColor(Color.neutral.shade300)
//            }
//            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
//            .padding(.horizontal)
            
//            if isToggleOn {
//                HStack {
//                    Image(systemName: "info.circle.fill")
//                    Text(isKilometerChosen && isMonthYearChosen ? "Pengingat akan dijadwalkan setiap \(monthInterval) bulan atau \(selectedNumber) kilometer sekali" : "Pengingat akan dijadwalkan setiap 0 bulan atau 0 kilometer sekali")
//                        .footnote(.regular)
//                        .foregroundColor(Color.neutral.shade300)
//                    
//                    Spacer()
//                }
//                .padding(.leading, 16)
//            }
            
            ZStack {
                Rectangle()
                    .cornerRadius(12)
                    .foregroundColor(Color.primary.tint300)
                    .frame(height: 52)
                    .overlay(
                          RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary.base, lineWidth: 1)
                      )
                    .padding(.horizontal, 16)
                HStack {
                    Spacer()
                    Image("Info_blue")
                        .padding(.bottom, 10)
                    Text("Pengingat yang disediakan merupakan data dari buku manual merk kendaraanmu")
                        .caption1(.regular)
                        .foregroundColor(Color.primary.base)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }
                    
        }
    }
}

#Preview {
    RepetitiveToggle()
}


