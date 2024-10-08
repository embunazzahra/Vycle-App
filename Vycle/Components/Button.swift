//
//  SwiftUIView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 07/10/24.
//

import SwiftUI

struct CustomButton: View {
    var title: String
    var symbolName: String? = nil // Optional symbol name
    var isEnabled: Bool = true
    var action: () -> Void // Closure as the last parameter
    
    var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            HStack {
                if let symbol = symbolName {
                    Image(systemName: symbol)
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.body)
                    .foregroundColor(isEnabled ? Color.neutral.tint300 : Color.gray)
            }
            .frame(width: 361, height: 60)
            .background(isEnabled ? Color.blue : Color.gray)
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .disabled(!isEnabled) // Disables the button when not enabled
    }
}

struct SwiftUIView: View {
    var body: some View {
        VStack(spacing: 20) {
            // Enabled button with a symbol
            CustomButton(title: "Selesai",  symbolName: "checkmark.circle", isEnabled: true) {
                print("Tes")
            }
        }
    }
}

#Preview {
    SwiftUIView()
}
