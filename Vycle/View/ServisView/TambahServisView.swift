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
    
    // For spareparts selection
    @State private var selectedParts: Set<SukuCadang> = [] // Track selected parts
    
    
    init() {
        setupNavigationBar()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            tanggalServisView()
            odometerServisView()
            pilihSukuCadangView()
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
            Text("Suku cadang")
                .headline()
            Text("Dapat memilih lebih dari satu suku cadang")
                .font(.footnote)
            WrappingHStack(models: SukuCadang.allCases, viewGenerator: { part in
                Button(action: {
                    // Toggle selection
                    if selectedParts.contains(part) {
                        selectedParts.remove(part) // Deselect if already selected
                    } else {
                        selectedParts.insert(part) // Select the part
                    }
                }) {
                    HStack(spacing:0) {
                        Text(part.rawValue)
                            .padding(.vertical, 12)
                            .foregroundStyle(selectedParts.contains(part) ? .white : Color.primary.shade300) // Change text color based on selection
                        
                        if selectedParts.contains(part) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 17)
                                .foregroundStyle(.white)
                                .padding(.leading,4)
                            
                        }
                    }
                    .padding(.horizontal,8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedParts.contains(part) ? Color.primary.shade200 : Color.clear)                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primary.shade200, lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            },horizontalSpacing: 4, verticalSpacing: 4)
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
