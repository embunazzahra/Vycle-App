//
//  ConfigurationGuide.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 25/10/24.
//

import SwiftUI

struct ConfigurationGuide: View {
    @Binding var showGuide: Bool
    @Environment(\.openURL) var openURL
    var body: some View {
        ZStack {
            Color.black.opacity(0.5) // Darkened background
                .edgesIgnoringSafeArea(.all)
                .transition(.opacity)

            VStack(alignment: .leading) {
                Button(action: {
                    withAnimation{
                        showGuide = false
                    }
                }) {
                    Image("close_grey")
                }
                .padding(.bottom, 16)
                
                Text("Panduan Menemukan ID VBeacon")
                    .headline()
                    .foregroundStyle(Color.neutral.shade300)
                
                Image("beacon_guide").resizable()
                    .scaledToFill()
                    .frame(width: 290, height: 200)
                    .clipped()
                
                Text("Panduan Menghubungkan Perangkat ke Mobil")
                    .headline()
                    .foregroundStyle(Color.neutral.shade300)
                    .padding(.top, 16)
                    .padding(.bottom, 8)

                VStack (alignment: .leading) {
                    Text("1.  Cari port USB mobil")
                        .body(.regular)
                        .foregroundStyle(Color.neutral.shade300)
                        .padding(.bottom, 4)
                    Text("2. Masukkan VBeacon ke port USB mobil")
                        .body(.regular)
                        .foregroundStyle(Color.neutral.shade300)
                        .padding(.bottom, 4)
                    Text("3. Hubungkan ID perangkat di smartphonemu")
                        .body(.regular)
                        .foregroundStyle(Color.neutral.shade300)
                }
                .padding(.bottom, 16)
                
                Text("Panduan Membeli VBeacon")
                    .headline()
                    .foregroundStyle(Color.neutral.shade300)
                    .padding(.bottom, 8)

                VStack (alignment: .leading) {
                    HStack(spacing: 0){
                        Text("1.  Kunjungi link formulir ")
                            .body(.regular)
                            .foregroundStyle(Color.neutral.shade300)
                            .padding(.horizontal, 0)
                            .padding(.bottom, 4)
                        Text("berikut ini")
                            .body(.regular)
                            .underline()
                            .foregroundStyle(Color.blueLoyaltyTone100)
                            .padding(.bottom, 4)
                            .padding(.horizontal, 0)
                            .onTapGesture {
                                openURL(URL(string: "https://airtable.com/appAoF5iKsULXOF91/pagQZU8B5QnvyleA6/form")!)
                            }
                    }
                    Text("2. Atau dapat menghubungi email ")
                        .body(.regular)
                        .foregroundStyle(Color.neutral.shade300)
                        .padding(.horizontal, 0)
                        .padding(.bottom, -4)
                    
                    Text(verbatim: "    vycle.help@gmail.com")
                        .body(.regular)
                        .underline()
                        .foregroundStyle(Color.blueLoyaltyTone100)
                        .onTapGesture {
                            openURL(URL(string: "mailto: vycle.help@gmail.com")!)
                        }
                        .padding(.bottom, 8)
                        .padding(.horizontal, 0)
                        
                   
                }
                
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .frame(width: 321)
            .transition(.scale)
            .animation(.smooth, value: showGuide)
        }
    }
}

