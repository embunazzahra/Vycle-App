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
    @State private var animateCircle1 = false
    @State private var animateCircle2 = false
    @State private var animateCircle3 = false

    var body: some View {
        VStack(alignment: .center) {
            if locationManager.isInsideBeaconRegion {
                BeaconConnectedView()
                    .onAppear() {
                        print("OnBoarding Value Before Connection: \(onBoardingDataSaved)")
                        print(locationManager.vBeaconID)
                        saveConfigurationAndOnBoardingData()
                    }
            }
            else if configurationFailed {
                ConfigurationFailedView()
                    .onAppear() {
                        resetConfiguration()
                    }
            } else {
                ConnectingToBeaconView(
                    animateCircle1: $animateCircle1,
                    animateCircle2: $animateCircle2,
                    animateCircle3: $animateCircle3
                )
                    .onAppear {
                        startAnimations()
                        startConfigurationTimer()
                    }
            }
        }
    }
    
    private func resetConfiguration() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            isRangingVBeacon = false
        }
    }
    
    private func saveConfigurationAndOnBoardingData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onBoardingDataSaved = true
            print("OnBoarding Value After Connection: \(onBoardingDataSaved)")
        }
    }
    
    private func startAnimations() {
        animateCircle1 = true
        animateCircle2 = true
        animateCircle3 = true
    }
    
    private func startConfigurationTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            configurationFailed = true
        }
    }
}

struct ConfigurationFailedView: View {
    var body: some View {
        Text("Failed Configuration")
            .font(.title)
            .foregroundColor(.red)
    }
}

struct BeaconConnectedView: View {
    var body: some View {
        Text("Beacon Connected!")
            .font(.title)
            .foregroundColor(.green)
    }
}

struct ConnectingToBeaconView: View {
    @Binding var animateCircle1: Bool
    @Binding var animateCircle2: Bool
    @Binding var animateCircle3: Bool
    
    var body: some View {
        VStack(alignment: .center) {
            ZStack(alignment: .center) {
                Circle()
                    .stroke(Color.primary.tint300, lineWidth: 4)
                    .frame(width: 160, height: 160)
                    .opacity(animateCircle1 ? 1 : 0)
                    .animation(
                        .easeOut(duration: 1)
                        .repeatForever(autoreverses: true),
                        value: animateCircle1
                    )
                
                Circle()
                    .stroke(Color.primary.tint200, lineWidth: 3)
                    .frame(width: 240, height: 240)
                    .opacity(animateCircle2 ? 1 : 0)
                    .animation(
                        .easeOut(duration: 1)
                        .repeatForever(autoreverses: true)
                        .delay(0.5),
                        value: animateCircle2
                    )
                
                Circle()
                    .stroke(Color.primary.tint100, lineWidth: 3)
                    .frame(width: 320, height: 320)
                    .opacity(animateCircle3 ? 1 : 0)
                    .animation(
                        .easeOut(duration: 1)
                        .repeatForever(autoreverses: true)
                        .delay(1),
                        value: animateCircle3
                    )
                
                Circle()
                    .fill(Color.primary.tint200)
                    .frame(width: 80, height: 80)
                
                Circle()
                    .fill(Color.background)
                    .frame(width: 32, height: 32)
                
                Circle()
                    .fill(Color.primary.base)
                    .frame(width: 20, height: 20)
            }
            
            Text("Connecting to Beacon...")
                .font(.headline)
                .padding(.top, 8)
            
            Text("Please make sure the device is within range.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .padding(.top, 8)
        }
        .padding()
    }
}
