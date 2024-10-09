//
//  ReminderContent.swift
//  ReminderVycle
//
//  Created by Clarissa Alverina on 08/10/24.
//

import SwiftUI

struct ReminderContent: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ayo, cek kendaraanmu! 🧐")
                .font(.headline)
                .foregroundColor(Color.neutral.shade300)
            Text("Beberapa servis kilometer dan waktu udah kelewat atau hampir sampai. Yuk, cek biar tetap aman!")
                .foregroundColor(Color.neutral.tone300)
                .font(.footnote)
                .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 12)
    }
}

#Preview {
    ReminderContent()
}
