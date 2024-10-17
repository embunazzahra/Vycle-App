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
    @State private var otherBrandsList: [String] = []
    @State private var odometer: Int? = nil
    @State private var serviceHistory: [ServiceHistory] = [ServiceHistory(sparepart: .filterUdara, month: 9, year: 24)]
    
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
                        .ignoresSafeArea(edges: .bottom)
                    
                    VStack (alignment: .center) {
//                        Rectangle()
//                            .background(.clear)
//                            .frame(height: keyboardResponder.isKeyboardVisible ? 50 : 0)
                        
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
                                EmptyView() // A fallback if no view matches the currentPage
                        }
                        
                        CustomButton(
                            title: currentPage == 4 ? "Selesai" : "Lanjutkan",
                            iconName: currentPage == 4 ? "selesai" : "lanjutkan",
                            iconPosition: .right,
                            buttonType: keyboardResponder.isKeyboardVisible ? .clear : (isButtonEnabled ? .primary : .disabled),
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
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    OnBoardingView()
}

import Combine
import SwiftUI

class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible = false
    @Published var keyboardHeight: CGFloat = 0.0
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { [weak self] notification in
                if notification.name == UIResponder.keyboardWillShowNotification {
                    self?.isKeyboardVisible = true
                    if let userInfo = notification.userInfo,
                       let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                        self?.keyboardHeight = frame.cgRectValue.height
                    }
                } else {
                    self?.isKeyboardVisible = false
                    self?.keyboardHeight = 0
                }
            }
    }
}
