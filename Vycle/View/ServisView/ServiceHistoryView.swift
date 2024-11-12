//
//  HistoriServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import SwiftData

struct ServiceHistoryView: View {
    @EnvironmentObject var routes: Routes
    @Query var serviceHistories : [Servis]
    @AppStorage("hasNewNotification") var hasNewNotification: Bool = false
    
    var currentYearServiceHistories: [Servis] {
        let currentYear = Calendar.current.component(.year, from: Date())
        return serviceHistories
            .filter { Calendar.current.component(.year, from: $0.date) == currentYear } // Filter for current year
            .sorted(by: { $0.date > $1.date }) // Sort by date in descending order
    }
    
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
                ForEach(currentYearServiceHistories) { history in
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
            .scrollIndicators(.hidden)
            
            
        }
        .padding()
        .navigationTitle("Servis")
    }

    // Update deleteHistory to remove from the model context
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
    ServiceHistoryView()
}
