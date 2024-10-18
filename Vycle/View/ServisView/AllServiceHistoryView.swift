//
//  AllServiceHistoryView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//

import SwiftUI

struct AllServiceHistoryView: View {
    @EnvironmentObject var routes: Routes
    
    @State private var serviceHistories = [
        UserServiceHistory(title: "Minyak rem", mileage: 78250, date: "01/10/2024", imageData: nil, spareparts: [.minyakRem]),
        UserServiceHistory(title: "Oli mesin", mileage: 65100, date: "15/09/2024", imageData: nil, spareparts: [.oliMesin]),
        UserServiceHistory(title: "Filter udara", mileage: 60500, date: "30/08/2024", imageData: nil, spareparts: [.filterUdara])
    ]
    
    var body: some View {
        //        ScrollView{
        VStack(alignment: .leading, spacing: 8) {
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
            
            //            }
            
        }
        .navigationTitle("Histori servis")
        .padding()
    }
    
    func deleteHistory(_ history: UserServiceHistory) {
        if let index = serviceHistories.firstIndex(where: { $0.id == history.id }) {
            serviceHistories.remove(at: index)
        }
    }
}

#Preview {
    AllServiceHistoryView()
}



