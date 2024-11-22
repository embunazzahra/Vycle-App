//
//  ServiceDetailView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//

import SwiftUI
import SwiftData

struct ServiceDetailView: View {
    @EnvironmentObject var routes: Routes
    @State var isShowingPopUp: Bool = false
    @EnvironmentObject var popUpHelper: PopUpHelper
    
    let service: Servis
    // For vehicle mileage
    @State private var odometerValue: String = "" // track user input in
    @State var userOdometer: Int = 0
    @Query var serviceHistories : [Servis]
    @AppStorage("hasNewNotification") var hasNewNotification: Bool = false
    
    var body: some View {
        ZStack {
                ScrollView (showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tanggal Servis")
                                .font(.headline)
                            Text(service.date.formattedDate())
                                .padding(.vertical, 4)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Kilometer Kendaraan")
                                .font(.headline)
                            Text("\(Int(service.odometer ?? 0).formattedWithSeparator()) Kilometer")
                                .padding(.vertical, 4)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Suku Cadang")
                                .font(.headline)
                            WrappingHStack(models: service.servicedSparepart, viewGenerator: { part in
                                Text(part.rawValue)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(Color.grayTint200)
                                    )
                            }, horizontalSpacing: 4, verticalSpacing: 4)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Total Biaya Servis")
                                .font(.headline)
                            Text("Rp \(service.totalPrice.formatted())")
                                .padding(.vertical, 4)
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bukti Pembayaran")
                                .font(.headline)
                            if service.photo != nil {
                                if let imageData = service.photo, let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(maxWidth: .infinity, maxHeight: 142)
                                        .clipped()
                                        .contentShape(Rectangle())
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .overlay( // Add the border
                                            RoundedRectangle(cornerRadius: 12)
                                                .stroke(Color.grayShade300, lineWidth: 0.5)
                                        )
                                        .onTapGesture {
                                            routes.navigate(to: .PhotoReviewView(imageData: imageData))
                                        }
                                }
                            } else {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(Color.neutral.shade100)
                                        .frame(maxWidth: .infinity, minHeight: 142)
                                    Image("image_icon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 36, height: 36)
                                        .cornerRadius(8)
                                }
                            }
                            
                        }
                    }
                    .padding(.horizontal,16)
                    .padding(.vertical,24)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .onAppear{
                    let odometers = SwiftDataService.shared.fetchOdometers()
                    
                    if let latestOdometer = odometers.last {
                        self.userOdometer = Int(latestOdometer.currentKM)
                    }
                    
                    self.odometerValue = "\(Int(service.odometer ?? 0))"
                }
                .safeAreaInset(edge: .bottom, content: {
                    VStack {
                        CustomButton(title: "Edit servis", iconName: "edit_vector_icon", iconPosition: .left, buttonType: .primary, verticalPadding: 0) {
                            routes.navigate(to: .AddServiceView(service: service))
                        }
                        CustomButton(title: "Hapus Servis", iconName: "trash_icon", iconPosition: .left, buttonType: .destructive,  verticalPadding: 0) {
                            popUpHelper.popUpType = .delete
                            popUpHelper.popUpAction = {
                                deleteHistory(service)
                                routes.navigateBack()
                                popUpHelper.showPopUp = false
                            }
                            popUpHelper.showPopUp = true
                        }
                    }
                    .padding(.top,20)
                    .frame(maxWidth: .infinity)
                    .background(.white)
                })
                .navigationBarBackButtonHidden(isShowingPopUp)
                .navigationTitle("Catatan servis")

        }
        
        
        
        
        
    }
    
    func deleteHistory(_ history: Servis) {
        SwiftDataService.shared.deleteHistory(for: history)
        if !serviceHistories.isEmpty {
            hasNewNotification = true
        } else {
            hasNewNotification = false
        }
    }
}

#Preview {
    ServiceDetailView(service: Servis(
        date: Date(),
        servicedSparepart: [.minyakRem],
        photo: nil,
        odometer: 78250,
        vehicle: Vehicle(vehicleType: .car, brand: .car(.honda), year: 2024),
        totalPrice: 10000
    ))
}
