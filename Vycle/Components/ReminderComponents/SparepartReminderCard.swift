//
//  SparepartReminderCard.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

struct SparepartReminderCard: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 80)
                .cornerRadius(8)
                .foregroundColor(Color.background)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                .padding(.horizontal, 16)
            
            HStack {
                Rectangle()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 8))
                    .foregroundColor(Color.gray)
                    .padding(.leading, 16)
                
                VStack (alignment: .leading) {
                    Text("Nama Sparepart")
                        .subhead(.emphasized)
                        .foregroundColor(Color.neutral.shade300)
                        .padding(.bottom, 8)
                    
                    ProgressBar(currentKilometer: 13000, maxKilometer: 20000)
                        .padding(.bottom, 3)
                }
                
                Spacer()
            }
        } .padding(.bottom, 6)
    }
}

#Preview {
    SparepartReminderCard()
}
