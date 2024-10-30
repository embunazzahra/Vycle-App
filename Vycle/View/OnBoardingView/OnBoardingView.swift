//
//  OnBoardingView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct OnBoardingView: View {
    @ObservedObject var locationManager: LocationManager
    @State private var currentPage: Int = 1
    @State private var previousPage: Int = 1
    @State private var previousPreviousPage: Int = 1
    @State private var isMovingForward: Bool = true
    @State private var vehicleType: VehicleType = .car
    @State private var vehicleBrand: VehicleBrand? = nil
    @State private var otherBrandsList: [String] = []
    @Binding var odometer: Float?
    @State private var serviceHistory: [ServiceHistory] = []
    @Binding var vBeaconID: String
    @State private var showGuide: Bool = false
    @Binding var onBoardingDataSaved: Bool
    @State private var isRangingVBeacon: Bool = false
    @State private var keyboardHeight: CGFloat = 0.0
    
    private var backButtonText: String {
        switch currentPage {
        case 2:
            return "Merk"
        case 3:
            return "Odometer"
        case 4:
            return "Histori"
        default:
            return "Back"
        }
    }
    
    var body: some View {
        ZStack {
            Color.primary.tone100.ignoresSafeArea()
            
            VStack {
                
                if !(keyboardHeight != 0 && currentPage == 2) {
                    HStack(alignment: .bottom) {
                        Label {
                            Text(backButtonText)
                                .body(.regular)
                        } icon: {
                            Image(systemName: "chevron.left")
                        }
                        .foregroundStyle(currentPage == 1 ? Color.clear : Color.neutral.tint300)
                        .padding(.horizontal)
                        .onTapGesture {
                            if currentPage > 1 {
                                isMovingForward = false
                                currentPage -= 1
                                isRangingVBeacon = false
                            }
                        }
                        .disabled(currentPage == 1)
                        
                        Spacer()
                    }
                    
                    StepIndicator(currentStep: $currentPage)
                        .padding(.bottom, 8)
                }
            
                ZStack (alignment: .bottom){
                    Rectangle()
                        .clipShape(.rect(cornerRadius: 40))
                        .ignoresSafeArea()
                        .foregroundStyle(Color.background)
                        .ignoresSafeArea(edges: .bottom)
                        .animation(.smooth, value: keyboardHeight)
                    
                    VStack (alignment: .center) {
                        switch currentPage {
                            case 1:
                                VehicleBrandView(
                                    vehicleType: $vehicleType,
                                    vehicleBrand: $vehicleBrand,
                                    otherBrandsList: $otherBrandsList,
                                    currentPage: $currentPage,
                                    isMovingForward: $isMovingForward
                                )
                                .transition(.backslide)
                            case 2:
                                VehicleOdometerView(
                                    odometer: $odometer,
                                    currentPage: $currentPage,
                                    isMovingForward: $isMovingForward,
                                    keyboardHeight: $keyboardHeight
                                )
                                .transition(.backslide)
                            case 3:
                                VehicleServiceHistoryView(
                                    serviceHistory: $serviceHistory,
                                    currentPage: $currentPage,
                                    isMovingForward: $isMovingForward
                                )
                                .transition(.backslide)
                            case 4:
                            if !isRangingVBeacon {
                                ConfigurationView(
                                    locationManager: locationManager,
                                    vBeaconID: $vBeaconID,
                                    showGuide: $showGuide,
                                    isRangingVBeacon: $isRangingVBeacon,
                                    onBoardingDataSaved: $onBoardingDataSaved,
                                    keyboardHeight: $keyboardHeight
                                )
                                .transition(.backslide)
                            } else {
                                RangingVBeaconView(
                                    locationManager: locationManager,
                                    isRangingVBeacon: $isRangingVBeacon,
                                    onBoardingDataSaved: $onBoardingDataSaved
                                )
                                .transition(.backslide)
                            }
                            default:
                                EmptyView()
                        }
                    }
                    .animation(.easeInOut, value: currentPage)
                    .onChange(of: onBoardingDataSaved) {
                        if onBoardingDataSaved {
                            SwiftDataService.shared.insertOnBoarding(
                                vehicleType: vehicleType,
                                vehicleBrand: vehicleBrand ?? .car(.honda),
                                odometer: odometer ?? 0,
                                serviceHistory: serviceHistory
                            )
                        }
                    }
                }
            }
            if showGuide {
                ConfigurationGuide(showGuide: $showGuide)
            }
        }
        .animation(.smooth, value: keyboardHeight)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
