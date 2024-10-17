//
//  ReminderContentNoData.swift
//  ReminderVycle
//
//  Created by Clarissa Alverina on 08/10/24.
//

import SwiftUI

struct ReminderContentNoData: View {
    var body: some View {
        VStack (alignment: .center) {
            Spacer()
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 100))
                .padding(8)
                .foregroundColor(Color.blue)
            
            HStack {
                Spacer()
                Text("Tambahkan pengingat dengan tombol di bawah ini yuk")
                    .body(.emphasized)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .foregroundColor(Color.neutral.shade300)
                Spacer()
            } .padding(.bottom, -8)
        
            CustomButton(title: "Tambahkan Pengingat", iconName: "", iconPosition: .left, buttonType: .primary) {
                NavigationLink(destination: AddReminderView()) {
                    Text("")
                }
            }
            
            Spacer()
            
//            CustomButton(title: "Tambahkan Pengingat",  symbolName: "folder.badge.plus", isEnabled: true) {
//                print("Tes")
//            }
            
//            Button {
//
//            } label: {
//                HStack {
//                    Spacer()
//                    Image(systemName: "folder.badge.plus")
//                    Text("Tambahkan pengingat")
//                    Spacer()
//                }
//                .padding(.vertical, 26)
//                .foregroundColor(Color.white)
//            }
//            .background(Color.blue)
//            .cornerRadius(12)
//            .padding(.horizontal, 24)
            
        }
    }
}

#Preview {
    ReminderContentNoData()
}
