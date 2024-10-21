//
//  NextKilometer.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

struct NextKilometer: View {
    @Binding var isKilometerChosen: Bool
    @Binding var selectedNumber: Int
    @Binding var showSheet: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Interval kilometer")
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
                    KilometerWheelPicker(selectedNumber: $selectedNumber, showSheet: $showSheet, isKilometerChosen: $isKilometerChosen)
                    Spacer()
                    Text("Kilometer")
                        .body(.regular)
                        .foregroundColor(Color.neutral.tone200)
                        .padding(.trailing, 16)
                }
                .padding(.horizontal, 8)
            }
        }
        .padding(.bottom, 8)
    }
}

