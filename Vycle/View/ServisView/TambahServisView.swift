//
//  TambahServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

import SwiftUI

struct TambahServisView: View {
    @State private var odometerValue: String = ""
    
    init() {
        setupNavigationBar()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            //tanggal servis view
            VStack(alignment: .leading) {
                Text("Tanggal servis")
                    .headline()
                
                Button(action: {}){
                    Text("23 September 2024")
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.neutral.shade300,lineWidth: 1)
                        )
                        .foregroundStyle(.grayShade300)
                }
            }
            
            
            //odometer servis view
            VStack(alignment: .leading) {
                Text("Kilometer kendaraan")
                    .headline()
                
                OdometerServisTextField(text: $odometerValue, placeholder: "78.250")
                
                Text("Berdasarkan tracking kilometer dari kendaraanmu")
                    .font(.footnote)
                    .foregroundStyle(.grayShade100)
                
            }
            
            //pilih suku cadang view
            VStack(alignment: .leading) {
                Text("Nama suku cadang")
                    .headline()
                Text("Berdasarkan tracking kilometer dari kendaraanmu")
                    .font(.footnote)
                    .foregroundStyle(.grayShade100)
                
            }
            
            //masukkan foto view
            
            
        }
        .padding()
        .padding(.top,8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Tambahkan servis")
        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    TambahServisView()
}
