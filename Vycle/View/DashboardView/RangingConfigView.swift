//
//  RangingVBeaconView.swift
//  Vycle
//
//  Created by Vincent Senjaya on 02/11/24.
//


import SwiftUI

struct RangingConfigView: View {
    @ObservedObject var locationManager: LocationManager
    @Binding var isRangingVBeacon: Bool
    @Binding var onBoardingDataSaved: Bool
    @State private var configurationFailed = false
    @State private var showConnectingView = true
    @State private var beaconDetected = false
    @AppStorage("vBeaconID") private var vBeaconID: String = ""
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                if locationManager.isInsideBeaconRegion && beaconDetected {
                        ConfigurationStatusView(isSuccess: true)
                            .onAppear() {
                                resetConfiguration()
                                showConnectingView = false
                            }
                    
                }
                else if configurationFailed{
                    ConfigurationStatusView(isSuccess: false)
                        .onAppear() {
                            vBeaconID = ""
                            resetConfiguration()
                            showConnectingView = false
                        }
                }
            }
        }.toolbar(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $showConnectingView) {
            ConnectingToBeaconView()
            .onAppear {
                startConfigurationTimer()
                startDetectionTimer()
            }
        }
    }
    
    private func resetConfiguration() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            isRangingVBeacon = false
        }
    }
    
    
    private func startConfigurationTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            configurationFailed = true
        }
    }
    
    private func startDetectionTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            beaconDetected = true
        }
    }
}



