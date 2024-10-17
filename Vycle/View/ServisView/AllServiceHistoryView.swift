//
//  AllServiceHistoryView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//

import SwiftUI

struct AllServiceHistoryView: View {
    @EnvironmentObject var routes: Routes
    
    let serviceHistories = [
        ServiceHistory(title: "Minyak rem", mileage: 78250, date: "01/10/2024", imageData: nil, spareparts: [.minyakRem]),
        ServiceHistory(title: "Oli mesin", mileage: 65100, date: "15/09/2024", imageData: nil, spareparts: [.oliMesin]),
        ServiceHistory(title: "Filter udara", mileage: 60500, date: "30/08/2024", imageData: nil, spareparts: [.filterUdara])
    ]
    
    var body: some View {
        ScrollView{
            VStack(alignment: .leading, spacing: 8) {
                Text("Tahun ini")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                ForEach(serviceHistories) { history in
                    ServiceHistoryCard(service: history) {
                        routes.navigate(to: .ServiceDetailView(service: history))
                    }
                }
                
            }
            .padding()
        }
        .navigationTitle("Histori servis")
        
    }
}

#Preview {
    AllServiceHistoryView()
}
