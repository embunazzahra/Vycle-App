//
//  OdometerKendaraan.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct VehicleOdometerView: View {
    @Binding var odometer: Int?
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Berapa angka\nodometermu sekarang?")
                .title1(.emphasized)
                .foregroundStyle(Color.neutral.shade300)
                .padding(.horizontal, 16)
                .padding(.top, 24)
                .padding(.bottom, 24)
            
            ZStack (alignment: .center){
                Image("odometer")
                VStack {
                    Text("KM")
                        .font(.custom("Technology-Bold", size: 24))
                    OdometerInput(odometer: $odometer)
                }.padding(.bottom, 36)
            }.frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
    }
}
