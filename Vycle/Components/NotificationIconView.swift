//
//  NotificationIconView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 01/11/24.
//

import SwiftUI

struct NotificationIconView: View {
    @Binding var hasNewNotification: Bool
    var iconName: String // Add a variable for the image name

    var body: some View {
        ZStack {
            // Main icon
            Image(iconName)
                .frame(width: 32, height: 32)

            // Notification dot
            if hasNewNotification {
                Circle()
                    .fill(Color.red)
                    .frame(width: 12, height: 12)
                    .offset(x: 8, y: -8)
            }
        }
    }
}


#Preview {
    // For Preview, use a constant binding
    NotificationIconView(hasNewNotification: .constant(true), iconName: "reminder_icon_blue") // Test with notification dot
        .previewDisplayName("With Notification Dot")

    NotificationIconView(hasNewNotification: .constant(true), iconName: "reminder_icon") // Test without notification dot
        .previewDisplayName("Without Notification Dot")
}
