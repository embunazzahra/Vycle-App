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
        }.toolbar(.hidden)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .fullScreenCover(isPresented: $showConnectingView) {
            ConnectingToBeaconView()
            .onAppear {
                startConfigurationTimer()
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
            configurationFailed = true
        }
    }
}



