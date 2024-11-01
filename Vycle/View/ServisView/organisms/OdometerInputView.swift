//
//  OdometerInputView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 11/10/24.
//

import SwiftUI

struct OdometerInputView: View {
    @Binding var odometerValue: String
    var userOdometer: Int
    var enable: Bool = true
    @State private var isOverLimit: Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Kilometer kendaraan")
                .font(.headline)
            
            OdometerServisTextField(text: $odometerValue, placeholder: userOdometer.formattedWithSeparator(), enable: enable, isOverLimit: $isOverLimit)
                .onChange(of: odometerValue) { // Use the new `onChange` syntax
                    isOverLimit = (Int(odometerValue) ?? 0 > userOdometer)
                }
            if isOverLimit {
                HStack(spacing: 0) {
                    Image("warning")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 17, height: 14)
                    Text("Data kilometer melebihi odometer dashboard kendaraan")
                        .font(.footnote)
                        .foregroundColor(Color.persianRed500)
                }
            } else {
                Text("Kilometer maksimal \(userOdometer.formattedWithSeparator()) berdasarkan odometer di dashboard")
                    .font(.footnote)
                    .foregroundStyle(Color.neutral.tone100)
            }
        }
    }
}
