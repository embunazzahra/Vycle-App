//
//  HistoriServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI

struct ServiceHistoryView: View {
    @EnvironmentObject var routes: Routes
    
    let serviceHistories = [
        ServiceHistory(title: "Minyak rem", mileage: 78250, date: "01/10/2024", spareparts: [.minyakRem]),
        ServiceHistory(title: "Oli mesin", mileage: 65100, date: "15/09/2024", spareparts: [.oliMesin]),
        ServiceHistory(title: "Filter udara", mileage: 60500, date: "30/08/2024", spareparts: [.filterUdara])
    ]

  
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Histori servis")
                        .font(.headline)
                    Spacer()
                    Text("Lihat selengkapnya")
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                        .onTapGesture {
                            routes.navigate(to: .AllServiceHistoryView)
                        }
                }
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
        .navigationTitle("Servis")
    }
    
}

#Preview {
    ServiceHistoryView()
}
