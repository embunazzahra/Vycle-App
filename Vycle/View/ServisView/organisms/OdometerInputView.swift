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

    var body: some View {
        VStack(alignment: .leading) {
            Text("Kilometer kendaraan")
                .font(.headline)

            OdometerServisTextField(text: $odometerValue, placeholder: enable ? "masukkan KM saat servis" : userOdometer.formattedWithSeparator(), enable: enable)

            Text("Berdasarkan tracking kilometer dari kendaraanmu")
                .font(.footnote)
                .foregroundStyle(.grayShade100)
        }
    }
}
