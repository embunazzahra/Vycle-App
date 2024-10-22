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
    @Environment(\.modelContext) private var modelContext
    
    
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

    // Update deleteHistory to remove from the model context
    func deleteHistory(_ history: Servis) {
//        SwiftDataService.shared.deleteHistory(for: history)
//        print("reminders count is \(reminders.count)")
        modelContext.delete(history)
    }
    
}

#Preview {
    ServiceHistoryView()
}
