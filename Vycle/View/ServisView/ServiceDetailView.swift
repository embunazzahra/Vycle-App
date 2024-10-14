//
//  ServiceDetailView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//

import SwiftUI

struct ServiceDetailView: View {
    let service: ServiceHistory
    // For vehicle mileage
    @State private var odometerValue: String = "" // track user input in
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Tanggal servis")
                    .headline()
                Text(service.date)
                OdometerInputView(odometerValue: $odometerValue, userOdometer: service.mileage, enable: false)
                Text("Nama suku cadang")
                    .headline()
                //                ChooseSparepartView(selectedParts: $selectedParts)
                WrappingHStack(models: service.spareparts, viewGenerator: { part in
                    Text(part.rawValue)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.grayTint200)
                        )
                })
                if service.imageData != nil {
                    if let imageData = service.imageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 120)
                            .clipped()
                            .contentShape(Rectangle())
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay( // Add the border
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.grayShade300, lineWidth: 0.5)
                            )
                    }
                }
            }
            .padding(.horizontal,16)
            .padding(.vertical,24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationTitle("Catatan servis")
        
    }
}

#Preview {
    ServiceDetailView(service: ServiceHistory(title: "Minyak rem", mileage: 78250, date: "01/10/2024", imageData: nil))
}
