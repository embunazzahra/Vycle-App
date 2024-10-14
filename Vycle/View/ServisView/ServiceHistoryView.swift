//
//  HistoriServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI

struct ServiceHistoryView: View {
    let serviceHistories = [
        ServiceHistory(title: "Minyak rem", mileage: "78.250", date: "01/10/2024"),
        ServiceHistory(title: "Oli mesin", mileage: "65.100", date: "15/09/2024"),
        ServiceHistory(title: "Filter udara", mileage: "60.500", date: "30/08/2024")
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
                }
                Text("Tahun ini")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                ForEach(serviceHistories) { history in
                    ServiceHistoryCard(service: history)
                }
                
            }
        }
        .padding()
        .navigationTitle("Servis")
    }
    
}

#Preview {
    ServiceHistoryView()
}
