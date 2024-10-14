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
                        TabView(selection: $currentPage) {
                            VehicleTypeView(vehicleType: $vehicleType)
                                .tag(1)
                                .gesture(DragGesture())
                            VehicleBrandView(vehicleType: $vehicleType, vehicleBrand: $vehicleBrand) {
                                currentPage += 1
                            }   .tag(2)
                                .gesture(DragGesture())
                            VehicleOdometerView(odometer: $odometer)
                                .tag(3)
                                .gesture(DragGesture())
                            VehicleServiceHistoryView(serviceHistory: $serviceHistory)
                                .tag(4)
                                .gesture(DragGesture())
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        .onAppear {
                              UIScrollView.appearance().isScrollEnabled = false
                        }
                        
                        CustomButton(
                            title: currentPage == 4 ? "Selesai" : "Lanjutkan",
                            iconName: currentPage == 4 ? "selesai" : "lanjutkan",
                            iconPosition: .right,
                            buttonType: isButtonEnabled ? .primary : .disabled,
                            verticalPadding: 0
                        ) {
                            if isButtonEnabled {
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
        }
    }
}

#Preview {
    OnBoardingView()
}
