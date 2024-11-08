//
//  OdometerKendaraan.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct VehicleOdometerView: View {
    @Binding var odometer: Float?
    @Binding var currentPage: Int
    @Binding var isMovingForward: Bool
    @Binding var keyboardHeight: CGFloat
    
    var isButtonEnabled: Bool {
        odometer != nil
    }
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Berapa angka\nodometermu sekarang?")
                .title1(.emphasized)
                .foregroundStyle(Color.neutral.shade300)
                .padding(.horizontal, 16)
                .padding(.vertical, 24)
            
            ZStack (alignment: .center){
                Image("odometer")
                
                VStack {
                    Text("KM")
                        .font(.custom("Technology-Bold", size: 24))
                    OdometerInput(odometer: $odometer)
                }.padding(.bottom, 36)
                
            }.frame(maxWidth: .infinity, alignment: .center)
            
            if keyboardHeight == 0 {
                Spacer()
            }
            
            CustomButton(
                title: "Lanjutkan",
                iconName: "lanjutkan",
                iconPosition: .right,
                buttonType: isButtonEnabled ? .primary : .disabled,
                verticalPadding: 0
            ) {
                if isButtonEnabled {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    isMovingForward = true
                    currentPage += 1
                }
            }
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .offset (y: -self.keyboardHeight)
        .animation(.smooth, value: keyboardHeight)
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main
            ) { (notification) in
                guard let keyboardFrame = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                withAnimation {
                    self.keyboardHeight = keyboardFrame.height - 40
                }
            }
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillHideNotification,
                object: nil,
                queue: .main
            ) { (notification) in
                self.keyboardHeight = 0
            }
        }
    }
}
