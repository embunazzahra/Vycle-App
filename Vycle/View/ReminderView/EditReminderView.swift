//
//  EditReminderView.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

struct EditReminderView: View {
    init() {
        setupNavigationBarWithoutScroll()
    }
    
    var body: some View {
        AddEditFramework(title: "Edit Pengingat") {
            AnyView(EditSuccessNotification())
        }
    }
}

#Preview {
    EditReminderView()
}
