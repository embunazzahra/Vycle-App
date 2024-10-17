//
//  AddReminder.swift
//  Vycle
//
//  Created by Clarissa Alverina on 08/10/24.
//

import SwiftUI

struct AddReminderView: View {
    init() {
        setupNavigationBarWithoutScroll()
    }

    var body: some View {
        AddEditFramework(title: "Tambahkan pengingat") {
            AnyView(AddSuccessNotification())
        }
    }
}

#Preview {
    AddReminderView()
}
