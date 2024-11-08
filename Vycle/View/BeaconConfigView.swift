//
//  BeaconConfigView.swift
//  Vycle
//
//  Created by Vincent Senjaya on 02/11/24.
//

import SwiftUI
struct BeaconConfigView: View {
    @AppStorage("vBeaconID") private var vBeaconID: String = ""
    @ObservedObject var locationManager: LocationManager
    @State private var isRangingVBeacon: Bool = false
    @State private var keyboardHeight: CGFloat = 0.0
    @State private var onBoardingDataSaved: Bool = false
    @State private var showGuide: Bool = false
    
    var body: some View {
        if !isRangingVBeacon {
            ZStack {
                VStack(alignment: .center) {
                    ConfigurationView(
                        locationManager: locationManager,
                        vBeaconID: $vBeaconID,
                        showGuide: $showGuide,
                        isRangingVBeacon: $isRangingVBeacon,
                        onBoardingDataSaved: $onBoardingDataSaved,
                        keyboardHeight: $keyboardHeight,
                        hideHeader: true
                    )
                    .transition(.move(edge: .trailing))
                }
                
                // Transparent overlay with ConfigurationGuide
                if showGuide {
                    ConfigurationGuide(showGuide: $showGuide)
                }
            }
            .navigationTitle("Tambahkan Vbeacon")
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        withAnimation {
                            showGuide = true
                        }
                    }) {
                        Image(systemName: "info.square.fill")
                            .foregroundColor(.white)
                    }
                }
            }
        } else {
            RangingConfigView(
                locationManager: locationManager,
                isRangingVBeacon: $isRangingVBeacon,
                onBoardingDataSaved: $onBoardingDataSaved
            )
            .transition(.opacity)
        }
    }
}
