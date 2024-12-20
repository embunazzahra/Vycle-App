//
//  JenisKendaraan.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 10/10/24.
//

import SwiftUI

struct VehicleTypeView: View {
    @Binding var vehicleType: VehicleType?
    
    var body: some View {
        
        VStack (alignment: .leading) {
            Text("Pilih jenis kendaraan pribadimu")
                .title1(.emphasized)
                .foregroundStyle(Color.neutral.shade300)
                .padding(.horizontal,16)
                .padding(.vertical, 24)
            
            VehicleTypeButton(
                vehicleType: .motorcycle,
                isSelected: vehicleType == .motorcycle,
               height: 94
            ) {
                vehicleType = .motorcycle
            }

            VehicleTypeButton(
               vehicleType: .car,
               isSelected: vehicleType == .car,
               height: 86
            ) {
               vehicleType = .car
            }
            
            Spacer()
        }
    }
}

