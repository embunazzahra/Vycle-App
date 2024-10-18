//
//  HistoriServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI

struct ServiceHistoryView: View {
    @EnvironmentObject var routes: Routes
    
    @State private var serviceHistories = [
        Servis(
            date: Date(),
            servicedSparepart: [.minyakRem],
            photo: nil,
            odometer: 78250,
            vehicle: Vehicle(vehicleType: .car, brand: .honda)
        ),
        Servis(
            date: Date(),
            servicedSparepart: [.oliMesin],
            photo: nil,
            odometer: 65100,
            vehicle: Vehicle(vehicleType: .car, brand: .honda)
        ),
        Servis(
            date: Date(),
            servicedSparepart: [.filterUdara],
            photo: nil,
            odometer: 60500,
            vehicle: Vehicle(vehicleType: .car, brand: .honda)
        )
    ]
    
    
    var body: some View {
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
            List {
                ForEach(serviceHistories) { history in
                    ServiceHistoryCard(service: history) {
                        routes.navigate(to: .ServiceDetailView(service: history))
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            deleteHistory(history)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                        
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets()) // Remove default row insets
                    .background(Color.clear) // Set background color to clear
                }
            }
            .listStyle(PlainListStyle()) // Remove default list styling
            .padding(.all, 0) // Remove all padding around the list
            
            
        }
        .padding()
        .navigationTitle("Servis")
    }
    func deleteHistory(_ history: Servis) {
        if let index = serviceHistories.firstIndex(where: { $0.id == history.id }) {
            serviceHistories.remove(at: index)
        }
    }
    
}

#Preview {
    ServiceHistoryView()
}
