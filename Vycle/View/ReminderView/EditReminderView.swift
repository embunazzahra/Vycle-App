//
//  EditReminderView.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

struct EditReminderView: View {
    @Binding var reminders: [SparepartReminder]
    @EnvironmentObject var routes: Routes

    init(reminders: Binding<[SparepartReminder]>) {
        self._reminders = reminders
    }

    var body: some View {
        AddEditFramework(
            title: "Edit Pengingat",
            reminders: $reminders,
            selectedSparepart: .busi 
        ) {
            AnyView(AddSuccessNotification(reminders: $reminders))
        }
        .onAppear {
            setupNavigationBarWithoutScroll()
        }
    }
}

#Preview {
    let reminders: [SparepartReminder] = []
    return EditReminderView(reminders: .constant(reminders))
        .environmentObject(Routes())
}

//import SwiftUI
//
//struct EditReminderView: View {
//    init() {
//        setupNavigationBarWithoutScroll()
//    }
//    
//    var body: some View {
//        AddEditFramework(title: "Edit Pengingat") {
//            AnyView(EditSuccessNotification())
//        }
//    }
//}
//
//#Preview {
//    EditReminderView()
//}
