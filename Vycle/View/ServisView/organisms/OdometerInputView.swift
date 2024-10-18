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

    var body: some View {
        VStack(alignment: .leading) {
            Text("Kilometer kendaraan")
                .headline()

            OdometerServisTextField(text: $odometerValue, placeholder: userOdometer.formattedWithSeparator())

            Text("Berdasarkan tracking kilometer dari kendaraanmu")
                .font(.footnote)
                .foregroundStyle(.grayShade100)
        }
    }
}
