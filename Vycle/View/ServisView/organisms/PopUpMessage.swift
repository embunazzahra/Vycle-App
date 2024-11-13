//
//  PopUpMessage.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 13/11/24.
//

import SwiftUI

struct PopUpMessage: View {
    @EnvironmentObject var routes: Routes
    var type: PopUpType = .delete
    @Binding var isShowingPopUp: Bool
    var action: (() -> Void)? = nil
    
    public var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 241, height: 290)
                .cornerRadius(12)
                .foregroundStyle(Color.white)

            VStack(spacing: 4) {
                Image(type.icon())
                    .font(.system(size: 45))
                Text(type.title())
                    .title2(.emphasized)
                    .foregroundColor(type.titleColor())
                Text(type.message())
                    .frame(width: 150)
                    .foregroundColor(Color.neutral.tone100)
                    .multilineTextAlignment(.center)
                
                ZStack {
                    Text(type.buttonText())
                        .subhead(.regular)
                        .padding(.horizontal,12)
                        .padding(.vertical,9)
                        .foregroundColor(Color.neutral.tint300)
                        .background(
                            Color.blue
                                .cornerRadius(12)
                        )
                }
                .padding(.top)
                .onTapGesture {
                    doButtonFunction()
                }
                if type == .delete, let action = action {
                    Text("Lanjutkan menghapus")
                        .subhead(.regular)
                        .foregroundColor(Color.persianRed500)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 9)
                        .onTapGesture {
                            action() // Call the action closure
                        }
                }
                
            }
        }
    }
    
    func doButtonFunction() {
        switch type {
        case .success:
            routes.navigateBack()
        case .delete:
            isShowingPopUp = false
        }
    }
}

enum PopUpType {
    case success
    case delete

    func icon() -> String {
        switch self {
        case .success:
            return "success_icon"
        case .delete:
            return "question_mark_icon"
        }
    }

    func title() -> String {
        switch self {
        case .success:
            return "Berhasil!"
        case .delete:
            return "Yakin, nih?"
        }
    }
    
    func titleColor() -> Color {
        switch self {
        case .success:
            return Color.lima500
        case .delete:
            return Color.neutral.tone300
        }
    }

    func message() -> String {
        switch self {
        case .success:
            return "Pengingat servismu telah diubah"
        case .delete:
            return "Suku cadang yang berasal dari servis ini akan terhapus"
        }
    }

    func buttonText() -> String {
        switch self {
        case .success:
            return "Kembali ke pengingat"
        case .delete:
            return "Tetap menyimpan"
        }
    }
}

#Preview {
    PopUpMessage(type: .success, isShowingPopUp: .constant(true))
    
    // Preview with action provided
    PopUpMessage(type: .delete, isShowingPopUp: .constant(true), action: {
        print("Delete action triggered")
    })
}
