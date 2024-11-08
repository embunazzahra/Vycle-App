//
//  SwiftUIView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 07/10/24.
//

import SwiftUI

enum ButtonStyleType {
    case primary
    case secondary
    case tertiary
    case disabled
    case clear
    
    func backgroundColor() -> Color {
        switch self {
        case .primary:
            return Color.primary.base
        case .secondary:
            return Color.clear
        case .tertiary:
            return Color.clear
        case .disabled:
            return Color.neutral.base
        case .clear:
            return Color.clear
        }
        
    }
    
    func foregroundColor() -> Color {
        switch self {
        case .primary, .disabled:
            return Color.neutral.tint300
        case .secondary, .tertiary:
            return Color.primary.base
        case .clear:
            return Color.clear
        }
    }
    
    func isDisabled() -> Bool {
        return self == .disabled
    }
}

enum IconPosition {
    case left, right
}

struct CustomButton: View {
    
    var title: String
    var iconName: String? = nil
    var iconPosition: IconPosition = .right
    var buttonType: ButtonStyleType = .primary
    var horizontalPadding: CGFloat = 16
    var verticalPadding: CGFloat = 24
//    var isNavigating: Bool
    @EnvironmentObject var routes: Routes
//    var destination: Routes.Destination
    var action: () -> Void
    
    var body: some View {
        Button(action: {
            if !buttonType.isDisabled() {
                action()
            }
//            routes.navigate(to: destination)
        }) {
            HStack {
                if let symbol = iconName, iconPosition == .left {
                    Image(symbol)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(buttonType.foregroundColor())
                }
                
                Text(title)
                    .body(.regular)
                    .foregroundColor(buttonType.foregroundColor())
                
                if let symbol = iconName, iconPosition == .right {
                    Image(symbol)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 24, height: 24)
                        .foregroundColor(buttonType.foregroundColor())
                }
            }
            .frame(width: 361, height: 60)
            .background(buttonType.backgroundColor())
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(buttonType == .secondary ? Color.primary.base : Color.clear, lineWidth: 1)
            )
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .disabled(buttonType.isDisabled())
    }
}

struct CustomButtonExample: View {
    var body: some View {
        ZStack {
            VStack {
                CustomButton(title: "Primary",  iconName: "selesai", buttonType: .primary) {
                    print("Tes")
                }
                CustomButton(title: "Disabled",  iconName: "lanjutkan", buttonType: .disabled) {
                    print("Tes")
                }
                CustomButton(title: "Secondary", iconName: "tambahkan", iconPosition: .left, buttonType: .secondary) {
                    print("Tes")
                }
            }
        }
    }
}

#Preview {
    CustomButtonExample()
}
