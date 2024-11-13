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
    @State var hideHeader: Bool = false
    @State private var tempVBeaconID: String = ""
    var body: some View {
        VStack (alignment: .leading) {
            if !hideHeader{
                HStack {
                    Text("Hubungkan VBeacon")
                        .title1(.emphasized)
                        .foregroundStyle(Color.neutral.shade300)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            showGuide = true
                        }
                    }) {
                        Image("help")
                    }
                }
                .padding(.horizontal,16)
                .padding(.top, 24)
            }
            
            Text("ID Perangkat")
                .headline()
                .foregroundColor(Color.neutral.shade300)
                .padding(.horizontal,16)
                .padding(.top, hideHeader ? 16 : 0)
            
            HStack {
                Image("device")
                    .foregroundColor(Color.neutral.tone200)
                TextField("", text: $tempVBeaconID)
                    .foregroundColor(Color.neutral.shade300)
                    .focused($fieldFocusState)
                    .placeholder(when: tempVBeaconID.isEmpty) {
                        Text("XXXX").foregroundColor(Color.neutral.tone100)
                    }
                    .onChange(of: tempVBeaconID) {
                        if tempVBeaconID.count > 4 {
                            tempVBeaconID = String(tempVBeaconID.prefix(4))
                        }
                        isButtonEnabled = tempVBeaconID.count == 4
                    }
                    .onAppear() {
                        tempVBeaconID = vBeaconID
                        isButtonEnabled = tempVBeaconID.count == 4
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
                    Text("ID perangkat tidak ditemukan")
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
                        title: "Hubungkan Perangkat",
                        iconName: "bluetooth_searching",
                        iconPosition: .right,
                        buttonType: isButtonEnabled ? .primary : .disabled,
                        verticalPadding: 0
                    ) {
                        if isButtonEnabled {
                            let pattern = "^[A-Fa-f0-9]{4}$"
                            incorrectIDFormat = !NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: tempVBeaconID)
                            
                            if !incorrectIDFormat {
                                vBeaconID = tempVBeaconID
                                isRangingVBeacon = true
                                locationManager.vBeaconID = tempVBeaconID
                                locationManager.startTracking()
                            }
                        }
                    }
                }
                .padding(.top, 8)
                .padding(.bottom, 24)
                
                if !hideHeader {
                    CustomButton(
                        title: "Lewati",
                        buttonType: .tertiary
                    ) {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        onBoardingDataSaved = true
                    }
                    .padding(.top, -52)
                    .padding(.bottom, keyboardHeight/2 + 10)
                }
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

