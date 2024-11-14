//
//  ReminderContentNoData.swift
//  ReminderVycle
//
//  Created by Clarissa Alverina on 08/10/24.
//

import SwiftUI

struct ReminderContentNoData: View {
    @EnvironmentObject var routes: Routes
    
    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            Image("empty_state_reminder")
                .font(.system(size: 100))
                .padding(8)
                .foregroundColor(Color.blueLoyaltyTone100)

            HStack {
                Spacer()
                Text("Tambahkan pengingat dengan tombol di bawah ini yuk")
                    .body(.emphasized)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .foregroundColor(Color.neutral.shade300)
                Spacer()
            } .padding(.bottom, -8)
        
            CustomButton(title: "Tambahkan Pengingat", buttonType: .primary) {
                routes.navigate(to: .AddReminderView)
                print ("clicked")
            }
            
            Spacer()
            
        }
    }
}

#Preview {
    ReminderContentNoData()
}
