//
//  TambahServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

import SwiftUI

struct TambahServisView: View {
    
    // For vehicle mileage
    @State private var odometerValue: String = "" // track user input in textfield
    @State private var userOdometer: Int = 78250
    
    // For date selection
    @State private var showDatePicker = false
    @State private var selectedDate = Date() // Default selected part
    
    init() {
        setupNavigationBar()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            tanggalServisView()
            odometerServisView()
            inputFotoView()
        }
        .padding()
        .padding(.top,8)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .navigationTitle("Tambahkan servis")
        .navigationBarBackButtonHidden(false)
    }
    
    func tanggalServisView() -> some View {
        VStack(alignment: .leading) {
            Text("Tanggal servis")
                .headline()
            
            Button(action: {
                showDatePicker = true
            }){
                Text(selectedDate.formattedDate())
                    .padding(.vertical,9)
                    .padding(.horizontal,12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.neutral.shade300,lineWidth: 1)
                    )
                    .foregroundStyle(.grayShade300)
            }
            .sheet(isPresented: $showDatePicker) {
                VStack{
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding()
                    CustomButton(title:"Pilih") {
                        showDatePicker = false
                    }
                }
                .presentationDetents([.height(527)]) // Set the sheet height
                .presentationDragIndicator(.visible) // Adds a drag indicator for the sheet
                .background(Color.background)
            }
        }
    }
    
    
    func odometerServisView() -> some View {
        VStack(alignment: .leading) {
            Text("Kilometer kendaraan")
                .headline()
            
            OdometerServisTextField(text: $odometerValue, placeholder: userOdometer.formattedWithSeparator())
            
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
        HStack {
            Image("photo_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 21, height: 21)
            Text("Masukkan foto bukti pembayaran")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    style: StrokeStyle(
                        lineWidth: 1,
                        dash: [4] // Adjust the dash size
                    )
                )
                .foregroundColor(.grayTone300) // Set the color of the border
        )
        .foregroundColor(.grayTone200) // Text color
        
    }
}

#Preview {
    TambahServisView()
}
