//
//  DataContentView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 15/11/24.
//


import SwiftUI
import SwiftData

struct DataContentView: View {
    var services: [Servis]
    var odometer: Float
    
    var totalCost: Float {
        services.reduce(0) { $0 + $1.totalPrice }
    }
    
    var uniqueSpareParts: Set<SparepartCount> {
        let sparePartCounts = services.flatMap { $0.servicedSparepart }
            .reduce(into: [:]) { counts, sparePart in
                counts[sparePart, default: 0] += 1
            }
        
        return Set(sparePartCounts.map { SparepartCount.part($0.key, count: $0.value) })
    }
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12){
                TotalMileageView(totalMileage: odometer)
                SparepartDataView(uniqueSpareParts: uniqueSpareParts)
                TotalCostView(totalCost: totalCost)
                CustomButton(title: "Bagikan",  iconName: "share_icon", iconPosition: .left, buttonType: .primary,horizontalPadding: 0, verticalPadding: 0) {
                    print("Tes")
                }
            }
        }
        .padding(.vertical)
        
        
    }
}