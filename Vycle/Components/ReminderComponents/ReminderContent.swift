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
            ReminderContentNear()
                .padding(.bottom, 12)
            ReminderContentFar()
                .padding(.bottom, 12)
            ReminderContentDraft()
        }
    }
}

struct ReminderContentNear: View {
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

struct ReminderContentFar: View {
    var body: some View {
        VStack(alignment: .center) {
            Text("Kendaraan siap jalan! 🚗")
                .font(.headline)
                .foregroundColor(Color.neutral.shade300)
            Text("Semua suku cadang dalam keadaan baik. Cek nanti untuk pemantauan berikutnya!")
                .foregroundColor(Color.neutral.tone300)
                .font(.footnote)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 12)
    }
}

struct ReminderContentDraft: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ayo, cek kendaraanmu! 🧐")
                .font(.headline)
                .foregroundColor(Color.neutral.shade300)
            Text("Beberapa suku cadang masih belum memiliki kilometer dan waktunya nih. Yuk, diubah supaya bisa ditrack!")
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
