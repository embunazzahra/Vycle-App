//
//  ServiceDetailView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//

import SwiftUI

struct ServiceDetailView: View {
    @EnvironmentObject var routes: Routes
    
    let service: ServiceHistory
    // For vehicle mileage
    @State private var odometerValue: String = "" // track user input in
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading) {
                    Text("Tanggal servis")
                        .font(.headline)
                    Text(service.date)
                        .padding(.vertical, 9)
                        .padding(.horizontal,12)
                }
                
                OdometerInputView(odometerValue: $odometerValue, userOdometer: service.mileage, enable: false)
                VStack(alignment: .leading) {
                    Text("Nama suku cadang")
                        .font(.headline)
                    WrappingHStack(models: service.spareparts, viewGenerator: { part in
                        Text(part.rawValue)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.grayTint200)
                            )
                    })
                }
                
                if service.imageData != nil {
                    if let imageData = service.imageData, let uiImage = UIImage(data: imageData) {
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
        .safeAreaInset(edge: .bottom, content: {
            CustomButton(title: "Edit servis", iconName: "edit_vector_icon", iconPosition: .left, buttonType: .secondary, horizontalPadding: 0, verticalPadding: 0) {
                routes.navigate(to: .AddServiceView(service: service))
            }
        })
        .navigationTitle("Catatan servis")
        
    }
}

#Preview {
    ServiceDetailView(service: ServiceHistory(title: "Minyak rem", mileage: 78250, date: "01/10/2024", imageData: nil, spareparts: [.minyakRem,.oliMesin]))
}
