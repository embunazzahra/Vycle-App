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
    
    // Computed property for available spare parts, filtering out the ones that are already in reminders
    var availableSpareparts: [Sparepart] {
        let usedSpareparts = reminders.map { $0.sparepart }
        return Sparepart.allCases.filter { !usedSpareparts.contains($0) }
    }

    @State private var selectedSparepart: Sparepart?

    init(reminders: Binding<[Reminder]>) {
        self._reminders = reminders
    }

    var body: some View {
        AddEditFramework(
            title: "Tambahkan Pengingat",
            reminders: $reminders,
            selectedSparepart: selectedSparepart ?? availableSpareparts.first ?? Sparepart.allCases.first!
        ) {
            AnyView(AddSuccessNotification(reminders: $reminders))
        }
        .onAppear {
            if selectedSparepart == nil {
                selectedSparepart = availableSpareparts.first
            }
        }
    }
}

#Preview {
    let reminders: [Reminder] = []
    return AddReminderView(reminders: .constant(reminders))
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

