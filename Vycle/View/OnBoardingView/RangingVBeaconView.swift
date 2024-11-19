//
//  RangingVBeaconView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 27/10/24.
//

import SwiftUI

struct RangingVBeaconView: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var isRangingVBeacon: Bool
    @Binding var onBoardingDataSaved: Bool
    @State private var configurationFailed = false
    @State private var showConnectingView = true

    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                if locationManager.isInsideBeaconRegion && !configurationFailed {
                    ConfigurationStatusView(isSuccess: true)
                        .onAppear() {
                            saveConfigurationAndOnBoardingData()
                            showConnectingView = false
                        }
                }
                else if configurationFailed {
                    ConfigurationStatusView(isSuccess: false)
                        .onAppear() {
                            resetConfiguration()
                            showConnectingView = false
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $showConnectingView) {
            ConnectingToBeaconView()
            .onAppear {
                startConfigurationTimer()
            }
        }.fullScreenCover(isPresented: $configurationFailed) {
            ConfigurationStatusView(isSuccess: false)
                .onAppear() {
                    resetConfiguration()
                    showConnectingView = false
                }
        }
        
    }
    
    private func resetConfiguration() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            isRangingVBeacon = false
        }
    }
    
    private func saveConfigurationAndOnBoardingData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            onBoardingDataSaved = true
        }
    }
    
    private func startConfigurationTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            if locationManager.isInsideBeaconRegion {
                configurationFailed = false
            } else {
                configurationFailed = true
            }
        }
    }
}

struct ConfigurationStatusView: View {
    let isSuccess: Bool
    @State var animateCircle1: Bool = false
    @State var animateCircle2: Bool = false
    @State var animateIcon: Bool = false
    @State private var showFull : Bool = false
    
    var body: some View {
        VStack (alignment: .center, spacing: 12) {
            ZStack (alignment: .center) {
                Circle()
                    .fill(isSuccess ? Color.lima.lima500 : Color.persianRed.red500)
                    .opacity(0.1)
                    .frame(width: 132, height: 132)
                    .scaleEffect(animateCircle1 ? 1 : 0)
                    .animation(
                        .bouncy(duration: 1.2)
                        .delay(0.5),
                        value: animateCircle1
                    )
                
                Circle()
                    .fill(isSuccess ? Color.lima.lima500 : Color.persianRed.red500)
                    .opacity(0.1)
                    .frame(width: 116, height: 116)
                    .scaleEffect(animateCircle2 ? 1 : 0)
                    .animation(
                        .bouncy(duration: 1)
                        .delay(0.5),
                        value: animateCircle2
                    )
                
                Image(isSuccess ? "berhasil" : "gagal")
                    .frame(width: 90, height: 90)
                    .scaleEffect(animateCircle2 ? 1 : 0)
                    .animation(
                        .bouncy(duration: 0.8)
                        .delay(0.5),
                        value: animateIcon
                    )
            }
            
            Text(isSuccess ? "Berhasil!" : "Gagal!")
                .title2(.emphasized)
                .foregroundStyle(isSuccess ? Color.lima.lima500 : Color.persianRed.red500)
            
            Text(isSuccess ? "VBeacon berhasil terhubung!" : "VBeacon gagal terhubung!")
                .body(.regular)
                .foregroundStyle(Color.neutral.tone100)
            
            Text(isSuccess ? "" : "Pastikan VBeacon sudah menyala.")
                .body(.regular)
                .foregroundStyle(Color.neutral.tone100)
                .padding(.top, -12)
        }
        .onAppear() {
            animateCircle1 = true
            animateCircle2 = true
            animateIcon = true
        }
    }
}


struct ConnectingToBeaconView: View {
    @State private var animateCircle1: Bool = false
    @State private var animateCircle2: Bool = false
    @State private var animateCircle3: Bool = false
    @State private var showFull : Bool = false
    
    var body: some View {
        ZStack {
            Color.primary.base.ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 180) {
                ZStack(alignment: .center) {
                    Circle()
                        .fill(Color.neutral.tint300)
                        .frame(width: 80, height: 80)
                        .scaleEffect(animateCircle1 ? 4.5 : 1)
                        .opacity(animateCircle1 ? 0 : 0.5)
                    
                    Circle()
                        .fill(Color.neutral.tint300)
                        .frame(width: 80, height: 80)
                        .scaleEffect(animateCircle2 ? 4.5 : 1)
                        .opacity(animateCircle2 ? 0 : 0.5)
                    
                    Circle()
                        .fill(Color.neutral.tint300)
                        .frame(width: 80, height: 80)
                        .scaleEffect(animateCircle3 ? 4.5 : 1)
                        .opacity(animateCircle3 ? 0 : 0.5)
                    
                    Image("bluetooth_searching_blue")
                }
                
                Text("Mencari perangkat di sekitar...")
                    .body(.regular)
                    .foregroundStyle(Color.neutral.tint300)
            }
            .padding()
            .onAppear {
                startAnimationLoop()
            }
        }
    }
    
    private func startAnimationLoop() {
        animateCircle(1, after: 0)
        animateCircle(2, after: 0.5)
        animateCircle(3, after: 1)
    }
    
    private func animateCircle(_ circleNumber: Int, after delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            withAnimation(Animation.easeOut(duration: 2 ).repeatForever(autoreverses: false)) {
                switch circleNumber {
                case 1:
                    animateCircle1.toggle()
                case 2:
                    animateCircle2.toggle()
                case 3:
                    animateCircle3.toggle()
                default:
                    break
                }
            }
        }
    }
}
