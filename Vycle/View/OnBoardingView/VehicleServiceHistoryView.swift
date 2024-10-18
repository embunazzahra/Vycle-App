//
//  HistoriServisKendaraan.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct VehicleServiceHistoryView: View {
    @Binding var serviceHistory: [ServiceHistory]
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Masukkan data servis terakhirmu disini")
                .title1(.emphasized)
                .foregroundStyle(Color.neutral.shade300)
                .padding(.horizontal,16)
                .padding(.top, 24)
                .padding(.bottom, 4)
            Text("Jika tidak ada, maka pilih selesai")
                .subhead(.regular)
                .foregroundStyle(Color.neutral.tone100)
                .padding(.horizontal, 16)
            ServiceHistoryList(items: $serviceHistory)
                .padding(.top, -8)
            Spacer()
        }
    }
}

//#Preview {
//    OnBoardingServiceHistoryView()
//}
