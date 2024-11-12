//
//  EditReminderView.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

struct EditReminderView: View {
    @Binding var reminder: Reminder
    @EnvironmentObject var routes: Routes
    @State private var isNotificationShowed = false
    @State private var isResetHidden: Bool = false

    var body: some View {
        AddEditFramework(
            title: "Edit Pengingat",
            reminders: .constant([reminder]),
            selectedSparepart: reminder.sparepart,
            selectedDate: reminder.dueDate,
            selectedNumber: Int(reminder.reminderOdo),
            reminderToEdit: reminder,
            successNotification: {
                AnyView(EditSuccessNotification(reminders: .constant([reminder])))
            },
            isResetHidden: $isResetHidden
        )
        .onAppear {
            setupNavigationBarWithoutScroll()
        }
    }
}


//struct EditReminderView: View {
//    @Binding var reminders: [Reminder]
//    @EnvironmentObject var routes: Routes
//
//    init(reminders: Binding<[Reminder]>) {
//        self._reminders = reminders
//    }
//
//    var body: some View {
//        AddEditFramework(
//            title: "Tambahkan pengingat",
//            reminders: $reminders,
//            selectedSparepart: .busi
//        ) {
//            AnyView(EditReminderView(reminders: $reminders))
//        }
//        .onAppear {
//            setupNavigationBarWithoutScroll()
//        }
//    }
//}

//#Preview {
//    let reminders: [Reminder] = []
//    return EditReminderView(reminders: .constant(reminders))
//        .environmentObject(Routes())
//}

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
