//
//  AddReminder.swift
//  Vycle
//
//  Created by Clarissa Alverina on 08/10/24.
//

import SwiftUI

struct AddReminderView: View {
    @Binding var reminders: [Reminder]
    @EnvironmentObject var routes: Routes

    var availableSpareparts: [Sparepart] {
        let usedSpareparts = reminders.map { $0.sparepart }
        return Sparepart.allCases.filter { !usedSpareparts.contains($0) }
    }

    @State private var selectedSparepart: Sparepart?
    @Binding var isResetHidden: Bool

    init(reminders: Binding<[Reminder]>, isResetHidden: Binding<Bool> = .constant(true)) {
        self._reminders = reminders
        self._isResetHidden = isResetHidden
    }

    var body: some View {
        AddEditFramework(
            title: "Tambahkan Pengingat",
            reminders: $reminders,
            selectedSparepart: selectedSparepart ?? availableSpareparts.first ?? Sparepart.allCases.first!,
            successNotification: {
                AnyView(AddSuccessNotification(reminders: $reminders))
            },
            isResetHidden: $isResetHidden
        )
        .onAppear {
            if selectedSparepart == nil {
                selectedSparepart = availableSpareparts.first
            }
        }
    }
}

#Preview {
    let reminders: [Reminder] = []
    return AddReminderView(reminders: .constant(reminders), isResetHidden: .constant(true))
        .environmentObject(Routes())
}




//import SwiftUI
//
//struct AddReminderView: View {
//    @Binding var reminders: [SparepartReminder]
//    @EnvironmentObject var routes: Routes
//
//    init(reminders: Binding<[SparepartReminder]>) {
//        self._reminders = reminders
//    }
//
//    var body: some View {
//        AddEditFramework(
//            title: "Tambahkan pengingat",
//            reminders: $reminders,
//            selectedSparepart: .busi 
//        ) {
//            AnyView(AddSuccessNotification(reminders: $reminders))
//        }
//        .onAppear {
//            setupNavigationBarWithoutScroll()
//        }
//    }
//}
//
//#Preview {
//    let reminders: [SparepartReminder] = []
//    return AddReminderView(reminders: .constant(reminders))
//        .environmentObject(Routes())
//}

