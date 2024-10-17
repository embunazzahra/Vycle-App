//
//  SparepartReminderCard.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

struct SparepartReminder: Identifiable {
    var id = UUID()
    var sparepartName: String
    var sparepartTargetKilometer: Double
    var monthInterval: Int
}

struct SparepartReminderCard: View {
    var reminder: SparepartReminder
    var currentKilometer: Double
    var serviceOdometer: Double

    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 80)
                .cornerRadius(8)
                .foregroundColor(Color.background)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 2, y: 2)
                .padding(.horizontal, 16)
            
            HStack {
                Rectangle()
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedCornersShape(corners: [.topLeft, .bottomLeft], radius: 8))
                    .foregroundColor(Color.gray)
                    .padding(.leading, 16)
                
                VStack(alignment: .leading) {
                    Text(reminder.sparepartName)
                        .subhead(.emphasized)
                        .foregroundColor(Color.neutral.shade300)
                        .padding(.bottom, 8)
    
                    ProgressBar(currentKilometer: currentKilometer,
                                maxKilometer: serviceOdometer + reminder.sparepartTargetKilometer)
                        .padding(.bottom, 3)
                }
                
                Spacer()
            }
        }
        .padding(.bottom, 12)
    }
}

struct SparepartReminderListView: View {
    @Binding var reminders: [SparepartReminder]
    
    var currentKilometer: Double = 15000
    var serviceOdometer: Double = 5000

    var body: some View {
        VStack {
            List {
                ForEach(reminders) { reminder in
                    SparepartReminderCard(reminder: reminder,
                                          currentKilometer: currentKilometer,
                                          serviceOdometer: serviceOdometer)
                        .listRowInsets(EdgeInsets())
                }
                .onDelete(perform: deleteReminder)
            }
            .listStyle(PlainListStyle())
        }
    }
    
    private func deleteReminder(at offsets: IndexSet) {
        reminders.remove(atOffsets: offsets)
    }
}

#Preview {
    @State var reminders = [
        SparepartReminder(sparepartName: "Busi", sparepartTargetKilometer: 20000, monthInterval: 6),
        SparepartReminder(sparepartName: "Oli", sparepartTargetKilometer: 10000, monthInterval: 3),
        SparepartReminder(sparepartName: "Filter Udara", sparepartTargetKilometer: 15000, monthInterval: 12)
    ]
    
    return SparepartReminderListView(reminders: $reminders)
}


