//
//  OnBoardingView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct OnBoardingView: View {
    @State private var currentPage = 1
    @State private var vehicleType: VehicleType? = nil
    @State private var vehicleBrand: VehicleBrand? = nil
    @State private var odometer: Int? = nil
    @State private var serviceHistory: [ServiceHistory] = [ServiceHistory(sparepart: .filterUdara, month: 9, year: 24)]
    
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
        ZStack (alignment: .bottom) {
            Color.primary.tone100.ignoresSafeArea()
            
            VStack {
                ZStack {
                    HStack (alignment: .top) {
                        if currentPage > 1 {
                            Button(action: {
                                currentPage -= 1
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text(backButtonText)
                                        .body(.regular)
                                }.foregroundStyle(Color.neutral.tint300)
                            }
                            .padding()
                        }
                        Spacer()
                    }.padding(.top, -60)
                    
                    StepIndicator(currentStep: $currentPage)
                        .padding(.top, 44)
                        .padding(.bottom, 8)
                }
            
                ZStack (alignment: .bottom){
                    Rectangle()
                        .clipShape(.rect(cornerRadius: 40))
                        .ignoresSafeArea()
                        .frame(height: 660)
                        .foregroundStyle(Color.background)
                    
                    VStack (alignment: .center) {
                        switch currentPage {
                            case 1:
                                VehicleTypeView(vehicleType: $vehicleType)
                            case 2:
                                VehicleBrandView(vehicleType: $vehicleType, vehicleBrand: $vehicleBrand) {
                                    currentPage += 1
                                }
                            case 3:
                                VehicleOdometerView(odometer: $odometer)
                            case 4:
                                VehicleServiceHistoryView(serviceHistory: $serviceHistory)
                            default:
                                EmptyView() // A fallback if no view matches the currentPage
                        }
                        
                        CustomButton(
                            title: currentPage == 4 ? "Selesai" : "Lanjutkan",
                            iconName: currentPage == 4 ? "selesai" : "lanjutkan",
                            iconPosition: .right,
                            buttonType: isButtonEnabled ? .primary : .disabled,
                            verticalPadding: 0
                        ) {
                            if isButtonEnabled {
                                print("vehicle type: \(vehicleType)")
                                print("vehicle brand: \(vehicleBrand)")
                                print("odometer:\(odometer)")
                                print("histori: \(serviceHistory)")
                                if currentPage < 4 {
                                    currentPage += 1
                                } else {
                                    // Save the data
                                }
                            }
                        }.padding(.bottom, 24)
                    }
                }
            }
        }.ignoresSafeArea(.keyboard)
    }
}

#Preview {
    OnBoardingView()
}
