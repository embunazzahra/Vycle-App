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
                        .padding(.vertical,9)
                        .padding(.horizontal,12)
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

                            
                //List
                List {
                    HStack {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 23, height: 23)
                            .foregroundStyle(.persianRed500)
                        Text("Pilih suku cadang")
                            .font(.subheadline)
                    }
                    .listRowBackground(Color.neutral.tint300)
                    Button(action: {
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 23, height: 23)
                                .foregroundStyle(.green)
                            Text("Tambahkan suku cadang lain")
                                .font(.subheadline)
                                .foregroundStyle(.blue)
                        }
                    }.listRowBackground(Color.neutral.tint300)
                }
//                .frame(height: 160)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, -20)
                .padding(.vertical, -35)
            }
            
            //masukkan foto view
            Text("bagian foto view")
            
            
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
