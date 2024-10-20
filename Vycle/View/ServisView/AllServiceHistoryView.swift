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
    
    // Update deleteHistory to remove from the model context
    func deleteHistory(_ history: Servis) {
        modelContext.delete(history) // Deletes the history from the context
    }
}

#Preview {
    AllServiceHistoryView()
}



