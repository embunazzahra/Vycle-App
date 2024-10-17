//
//  OnBoardingView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var currentPage = 4
    @State private var vehicleType: VehicleType? = nil
    @State private var vehicleBrand: VehicleBrand? = nil
    @State private var otherBrandsList: [String] = []
    @State private var odometer: Float? = nil
    @State private var serviceHistory: [ServiceHistory] = [ServiceHistory(sparepart: .filterUdara, date: Date().startOfMonth())]
    
    @StateObject private var keyboardResponder = KeyboardResponder()
    
    private var backButtonText: String {
        switch currentPage {
        case 2:
            return "Kendaraan"
        case 3:
            return "Merk kendaraan"
        case 4:
            return "Odometer"
        default:
            return "Back"
        }
    }
    
    private var isButtonEnabled: Bool {
        switch currentPage {
        case 1:
            return vehicleType != nil
        case 2:
            return vehicleBrand != nil
        case 3:
            return odometer != nil
        case 4:
            return true
        default:
            return false
        }
    }
    
    var body: some View {
        GeometryReader {
            geometry in
            ZStack {
                Color.primary.tone100.ignoresSafeArea()
                
                VStack {
                    
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
                                currentPage -= 1
                            }
                        }
                        .disabled(currentPage == 1)

                        Spacer()
                    }

                    StepIndicator(currentStep: $currentPage)
                        .padding(.bottom, 8)
                
                    ZStack (alignment: .bottom){
                        Rectangle()
                            .clipShape(.rect(cornerRadius: 40))
                            .ignoresSafeArea()
                            .foregroundStyle(Color.background)
                            .ignoresSafeArea(edges: .bottom)
                        
                        VStack (alignment: .center) {
                            switch currentPage {
                                case 1:
                                    VehicleTypeView(vehicleType: $vehicleType)
                                case 2:
                                    VehicleBrandView(
                                        vehicleType: $vehicleType,
                                        vehicleBrand: $vehicleBrand,
                                        otherBrandsList: $otherBrandsList)
                                    {
                                        currentPage += 1
                                    }
                                case 3:
                                    VehicleOdometerView(odometer: $odometer)
                                case 4:
                                    VehicleServiceHistoryView(serviceHistory: $serviceHistory)
                                default:
                                    EmptyView()
                            }
                            
                            Spacer()
                            
                            CustomButton(
                                title: currentPage == 4 ? "Selesai" : "Lanjutkan",
                                iconName: currentPage == 4 ? "selesai" : "lanjutkan",
                                iconPosition: .right,
                                buttonType: keyboardResponder.isKeyboardVisible ? .clear : (isButtonEnabled ? .primary : .disabled),
                                verticalPadding: 0
                            ) {
                                if isButtonEnabled {
                                    print("vehicle type: \(String(describing: vehicleType))")
                                    print("vehicle brand: \(String(describing: vehicleBrand))")
                                    print("odometer:\(String(describing: odometer))")
                                    print("histori: \(serviceHistory)\n")
                                    
                                    if currentPage < 4 {
                                        currentPage += 1
                                    } else {
                                        // Save the data
                                    }
                                }
                            }
                            .padding(.top, 8)
                            .padding(.bottom, 24)
                        }
                    }.frame(height: 660)
                    
                }
            }
        
        }.ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    OnBoardingView()
}



