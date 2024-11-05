//
//  AllServiceHistoryView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//

import SwiftUI
import SwiftData

struct AllServiceHistoryView: View {
    @EnvironmentObject var routes: Routes
    @Query var serviceHistories : [Servis]
    @Environment(\.modelContext) private var modelContext
    @AppStorage("hasNewNotification") var hasNewNotification: Bool = false
    {
        didSet {
            print("notif in all service:\(hasNewNotification)")
        }
    }
    
    var groupedServiceHistories: [Int: [Servis]] {
        Dictionary(grouping: serviceHistories) { service in
            Calendar.current.component(.year, from: service.date)
        }
    }
    
    
    var body: some View {
        List {
            ForEach(Array(groupedServiceHistories.keys.sorted(by: >)), id: \.self) { year in
                // Display the year header
                Text(year == Calendar.current.component(.year, from: Date()) ? "Tahun Ini" : String(year))
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .padding(.top, 8)
                    .listRowInsets(EdgeInsets())
                
                // Display each card under the corresponding year
                ForEach(groupedServiceHistories[year] ?? []) { history in
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
            .listRowSeparator(.hidden)
            .listSectionSeparator(.hidden)
        }
        .listStyle(PlainListStyle()) // Remove default list styling
        .padding(.all, 0) // Remove all padding around the list
        .scrollIndicators(.hidden)
        .navigationTitle("Histori servis")
        .padding(.horizontal)
    }
    
    // Update deleteHistory to remove from the model context
    func deleteHistory(_ history: Servis) {
        modelContext.delete(history) // Deletes the history from the context
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
        
        if !serviceHistories.isEmpty {
            hasNewNotification = true
            print("service count: \(serviceHistories.count)")
        } else {
            hasNewNotification = false
            print("service hostory is empty")
        }
    }
}

#Preview {
    AllServiceHistoryView()
}



