//
//  HistoriServisKendaraan.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct VehicleServiceHistoryView: View {
    @Binding var serviceHistory: [ServiceHistory]
    @Binding var currentPage: Int
    @Binding var isMovingForward: Bool
    
    var isButtonEnabled: Bool {
        serviceHistory.allSatisfy { $0.isPartChosen && $0.isMonthYearChosen }
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Masukkan data servis terakhirmu disini")
                .title1(.emphasized)
                .foregroundStyle(Color.neutral.shade300)
                .padding(.horizontal,16)
                .padding(.top, 24)
                .padding(.bottom, 4)
            Text("Jika tidak ada, maka silahkan lanjut")
                .subhead(.regular)
                .foregroundStyle(Color.neutral.tone100)
                .padding(.horizontal, 16)
            ServiceHistoryList(items: $serviceHistory)
                .padding(.top, -8)
            
            Spacer()
            
            CustomButton(
                title: "Lanjutkan",
                iconName: "lanjutkan",
                iconPosition: .right,
                buttonType: isButtonEnabled ? .primary : .disabled,
                verticalPadding: 0
            ) {
                if isButtonEnabled {
                    isMovingForward = true
                    currentPage += 1
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
    }
}

//#Preview {
//    OnBoardingServiceHistoryView()
//}
