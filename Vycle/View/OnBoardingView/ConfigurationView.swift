//
//  JenisKendaraan.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 10/10/24.
//

import SwiftUI

struct ConfigurationView: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var vBeaconID: String
    @Binding var showGuide: Bool
    @Binding var isRangingVBeacon: Bool
    @Binding var onBoardingDataSaved: Bool
    @Binding var keyboardHeight: CGFloat
    @FocusState private var fieldFocusState: Bool
    @State var incorrectIDFormat: Bool = false
    @State var deviceNotFound: Bool = false
    @State private var isButtonEnabled: Bool = false
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Hubungkan VBeacon")
                    .title1(.emphasized)
                    .foregroundStyle(Color.neutral.shade300)
                    .padding(.horizontal,16)
                    .padding(.vertical, 24)
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showGuide = true
                    }
                }) {
                    Image("help")
                }
                .padding(.horizontal,16)
                .padding(.vertical, 24)
            }
            
            Text("ID Perangkat")
                .headline()
                .foregroundColor(Color.neutral.shade300)
                .padding(.horizontal, 16)
            
            HStack {
                Image("device")
                    .foregroundColor(Color.neutral.tone200)
                TextField("", text: $vBeaconID)
                    .foregroundColor(Color.neutral.shade300)
                    .focused($fieldFocusState)
                    .placeholder(when: vBeaconID.isEmpty) {
                        Text("AA000").foregroundColor(Color.neutral.tone100)
                    }
                    .onChange(of: vBeaconID) {
                        if vBeaconID.count > 4 {
                            vBeaconID = String(vBeaconID.prefix(4))
                        }
                        isButtonEnabled = vBeaconID.count == 4
                    }
                    .onAppear() {
                        isButtonEnabled = vBeaconID.count == 4
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .keyboard) {
                            Spacer()
                            Button("Done") {
                                fieldFocusState = false
                            }.tint(Color.primary.base)
                        }
                    }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(deviceNotFound ? Color.persianRed.red500 : Color.neutral.tone100, lineWidth: 1)
            )
            .padding(.horizontal, 16)
            
            if incorrectIDFormat {
                HStack {
                    Image("warning")
                    Text("ID perangkat harus dua huruf di depan dan tiga huruf di belakang. Contoh: AA000")
                        .footnote(.regular)
                        .foregroundColor(Color.persianRed.red500)
                        .padding(.top, 2)
                }.padding(.horizontal, 16)
            } else {
                if deviceNotFound {
                    HStack {
                        Image("warning")
                        Text("Perangkat tidak ditemukan")
                            .footnote(.regular)
                            .foregroundColor(Color.persianRed.red500)
                            .padding(.top, 2)
                    }.padding(.horizontal, 16)
                } else {
                    Text("Pastikan perangkat sudah menyala")
                        .footnote(.regular)
                        .foregroundColor(Color.neutral.tone100)
                        .padding(.top, 2)
                        .padding(.horizontal, 16)
                }
            }
            
            Spacer()
            
            VStack {
                CustomButton(
                    title: "Cek Perangkat",
                    iconName: "bluetooth_searching",
                    iconPosition: .right,
                    buttonType: isButtonEnabled ? .primary : .disabled,
                    verticalPadding: 0
                ) {
                    if isButtonEnabled {
//                        let pattern = "^[A-Za-z]{2}\\d{3}$"
//                        incorrectIDFormat = !NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: vBeaconID)
                        incorrectIDFormat = false
                        
                        if !incorrectIDFormat {
                            isRangingVBeacon = true
                            locationManager.vBeaconID = vBeaconID
                            locationManager.startTracking()
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
                
                CustomButton(
                    title: "Lewati",
                    buttonType: .tertiary
                ) {
                    onBoardingDataSaved = true
                }
                .padding(.top, -52)
            }
            .offset (y: -self.keyboardHeight)
        }
        .animation(.smooth, value: keyboardHeight)
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: UIResponder.keyboardWillShowNotification,
                object: nil,
                queue: .main
            ) { (notification) in
                guard let keyboardFrame = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
                withAnimation {
                    self.keyboardHeight = keyboardFrame.height - 48
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

