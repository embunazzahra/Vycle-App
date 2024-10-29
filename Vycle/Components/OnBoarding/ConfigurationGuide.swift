//
//  ConfigurationGuide.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 25/10/24.
//

import SwiftUI

struct ConfigurationGuide: View {
    @Binding var showGuide: Bool
    
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
                    Image("close")
                }
                .padding(.bottom, 16)
                
                Text("Panduan Menemukan ID VBeacon")
                    .headline()
                    .foregroundStyle(Color.neutral.shade300)
                
                Image("VBeacon")
                
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
            }
            .padding(16)
            .background(Color.white)
            .cornerRadius(12)
            .frame(width: 321, height: 520)
            .transition(.scale)
            .animation(.smooth, value: showGuide)
        }
    }
}

