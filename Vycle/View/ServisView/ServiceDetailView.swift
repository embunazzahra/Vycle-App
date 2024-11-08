//
//  ServiceDetailView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//

import SwiftUI

struct ServiceDetailView: View {
    @EnvironmentObject var routes: Routes
    
    let service: Servis
    // For vehicle mileage
    @State private var odometerValue: String = "" // track user input in
    @State var userOdometer: Int = 0
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Tanggal servis")
                        .font(.headline)
                    Text(service.date.formattedDate())
                        .padding(.vertical, 9)
                        .padding(.horizontal,12)
                }
                
                OdometerInputView(odometerValue: $odometerValue, userOdometer: userOdometer, enable: false)
                VStack(alignment: .leading) {
                    Text("Nama suku cadang")
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
            CustomButton(title: "Edit servis", iconName: "edit_vector_icon", iconPosition: .left, buttonType: .secondary, horizontalPadding: 0, verticalPadding: 0) {
                routes.navigate(to: .AddServiceView(service: service))
            }
        })
        .navigationTitle("Catatan servis")
        
    }
}

#Preview {
    ServiceDetailView(service: Servis(
        date: Date(),
        servicedSparepart: [.minyakRem],
        photo: nil,
        odometer: 78250,
        vehicle: Vehicle(vehicleType: .car, brand: .car(.honda))
    ))
}
