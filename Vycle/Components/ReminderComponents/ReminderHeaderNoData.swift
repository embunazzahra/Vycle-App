//
//  ReminderHeaderNoData.swift
//  ReminderVycle
//
//  Created by Clarissa Alverina on 08/10/24.
//

import SwiftUI

struct ReminderHeaderNoData: View {
    var body: some View {
        VStack (alignment: .center, spacing: 8) {
            Image(systemName: "bell.slash.fill")
                .font(.system(size: 20, weight: .bold))
            
            Text("Belum ada pengingat terdaftar")
                .body(.emphasized)
            
//            Text("Tambahin pengingat dulu yuk!")
//                .caption1(.regular)
        }
        .padding(.top, 24)
        .foregroundColor(Color.neutral.tint300)
        .background(Color.primary.tone100)
    }
}

#Preview {
    ReminderHeaderNoData()
}
