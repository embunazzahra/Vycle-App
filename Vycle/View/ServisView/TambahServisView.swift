//
//  TambahServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

import SwiftUI

struct TambahServisView: View {
    @State private var odometerValue: String = ""
    @State private var choosenSpart: [String] = []
    @State private var isPickerPresented: Bool = false
    @State private var selectedSparePart: SukuCadang = .filterOli // Default selected part
    
    init() {
        setupNavigationBar()
    }
    
    var body: some View {
        Form {
            Section{
                tanggalServisView()
                    .listRowInsets(.init(top: 8,
                                         leading: 0,
                                         bottom: 16,
                                         trailing: 0))
            }
            Section{
                odometerServisView()
                    .listRowInsets(.init(top: 0,
                                         leading: 0,
                                         bottom: 1,
                                         trailing: 0))
            }
            
            Section{
                Text("Nama suku cadang")
                    .headline()
                    .listRowInsets(.init(top: 0,
                                         leading: 0,
                                         bottom: 0,
                                         trailing: 0))
            }
            
            Section{
                if (choosenSpart.isEmpty){
                    SukuCadangCard(title: "Pilih suku cadang")
                }
                else{
                    ForEach(choosenSpart, id: \.self) { spart in
                        SukuCadangCard(title: spart)
                    }
                }
                
                Button(action: {
                    isPickerPresented = true // Show picker when button is clicked
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
                }
            }
            .listRowBackground(Color.neutral.tint300)
            
            Section{
                inputFotoView()
            }
            
        }
        .scrollContentBackground(.hidden) //hapus warna background
        .listSectionSpacing(0) //spacing antar section
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Tambahkan servis")
        .navigationBarBackButtonHidden(false)
    }
    
    func tanggalServisView() -> some View {
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
    }
    
    
    func odometerServisView() -> some View {
        VStack(alignment: .leading) {
            Text("Kilometer kendaraan")
                .headline()
            
            OdometerServisTextField(text: $odometerValue, placeholder: "78.250")
            
            Text("Berdasarkan tracking kilometer dari kendaraanmu")
                .font(.footnote)
                .foregroundStyle(.grayShade100)
        }
    }
    
    func pilihSukuCadangView() -> some View {
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
            .frame(height: 160)
            .scrollContentBackground(.hidden)
            .padding(.horizontal, -20)
            .padding(.vertical, -35)
        }
    }
    
    func inputFotoView() -> some View {
        Text("bagian foto view")
    }
}

#Preview {
    TambahServisView()
}
