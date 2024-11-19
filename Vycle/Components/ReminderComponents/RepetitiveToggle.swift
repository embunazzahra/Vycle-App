//
//  RepetitiveToggle.swift
//  Vycle
//
//  Created by Clarissa Alverina on 14/10/24.
//

import SwiftUI

struct RepetitiveToggle: View {
//    @Binding var isToggleOn: Bool
//    @Binding var isKilometerChosen: Bool
//    @Binding var isMonthYearChosen: Bool
//    @Binding var monthInterval: Int
//    @Binding var selectedNumber: Int
//    
    
    var body: some View {
        VStack {
//            Toggle(isOn: $isToggleOn) {
//                Text("Pengingat berulang")
//                    .font(.headline)
//                    .foregroundColor(Color.neutral.shade300)
//            }
//            .toggleStyle(SwitchToggleStyle(tint: Color.blue))
//            .padding(.horizontal)
            
//            if isToggleOn {
//                HStack {
//                    Image(systemName: "info.circle.fill")
//                    Text(isKilometerChosen && isMonthYearChosen ? "Pengingat akan dijadwalkan setiap \(monthInterval) bulan atau \(selectedNumber) kilometer sekali" : "Pengingat akan dijadwalkan setiap 0 bulan atau 0 kilometer sekali")
//                        .footnote(.regular)
//                        .foregroundColor(Color.neutral.shade300)
//                    
//                    Spacer()
//                }
//                .padding(.leading, 16)
//            }
            
            ZStack {
                Rectangle()
                    .cornerRadius(12)
                    .foregroundColor(Color.primary.tint300)
                    .frame(height: 52)
                    .overlay(
                          RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary.base, lineWidth: 1)
                      )
                    .padding(.horizontal, 16)
                HStack {
                    Spacer()
                    Image("Info_blue")
                        .padding(.bottom, 10)
                    Text("Pengingat yang disediakan merupakan data dari buku manual merk kendaraanmu")
                        .caption1(.regular)
                        .foregroundColor(Color.primary.base)
                    Spacer()
                }
                .padding(.horizontal, 16)
            }

            
            ZStack {
                Rectangle()
                    .cornerRadius(8)
                    .frame(height: 36)
                    .foregroundColor(Color.neutral.tint100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.neutral.tone300, lineWidth: 1)
                    )

                HStack {
                    Image("event")
                    Text("Pengingat berasal dari servis pada 17/08/2024")
                        .caption1(.regular)
                        .foregroundColor(Color.neutral.tone300)
                    Spacer()
                } .padding(.leading, 10)
            }
            .padding(.horizontal, 16)
            
            ZStack {
                Rectangle()
                    .frame(width: 261, height: 300)
                    .cornerRadius(12)
                    .foregroundStyle(Color.neutral.tint300)
                
                VStack {
                    Spacer()
                    Image("cancel icon")
                    Text("Yakin Nih?")
                        .title2(.emphasized)
                        .foregroundColor(Color.neutral.tone300)
                        .padding(.bottom, 2)
                    Text("Pengingat suku cadang ini tidak akan muncul di daftar pengingat lhoo")
                        .callout(.regular)
                        .foregroundColor(Color.neutral.tone100)
                        .frame(width: 200)
                        .multilineTextAlignment(.center)
                      
                    Button(action: {
                        
                    }) {
                        ZStack {
                            Rectangle()
                                .frame(width: 128, height: 40)
                                .cornerRadius(12)
                            Text("Tetap simpan")
                                .body(.regular)
                                .foregroundColor(Color.neutral.tint300)
                        }
                    }
                    .padding(.top, 10)
                    
                    Button(action: {
                        
                    }) {
                       Text("Lanjutkan hapus")
                            .body(.regular)
                            .foregroundColor(Color.persianRed500)
                    }
                    .padding(1)

                    Spacer()
                }
            }
                    
        }
    }
}

#Preview {
    RepetitiveToggle()
}


