//
//  ReminderHeader.swift
//  ReminderVycle
//
//  Created by Clarissa Alverina on 08/10/24.
//

import SwiftUI

struct ReminderHeader: View {
    var body: some View {
        VStack {
            VStack (alignment: .center, spacing: 8){
                Image(systemName: "bell.fill")
                    .font(.system(size: 20, weight: .bold))
                
                HStack {
                    Text("0")
                        .body(.emphasized)
                    
                    Text("pengingat terdaftar")
                        .body(.emphasized)
                }
                
                Text("Tapi jangan khawatir, waktunya masih jauh!")
                    .caption1(.regular)
            }
            
            NavigationLink(destination: AllReminderView()) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.white, lineWidth: 1)
                        .frame(width: 219, height: 32)

                    Text("Cek seluruh pengingat")
                        .subhead(.regular)
                }
                .padding(.top, 8)
            }

        }
        .background(Color.primary.tone100)
        .foregroundColor(Color.neutral.tint300)
    }
}

#Preview {
    ReminderHeader()
}
