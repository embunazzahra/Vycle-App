//
//  PengingatView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI

struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct PengingatView: View {
    @State var reminders: [SparepartReminder] = []
    @EnvironmentObject var routes: Routes

    var body: some View {
//        NavigationStack {
            VStack {
                VStack {
                    if !reminders.isEmpty {
                        ReminderHeader(reminders: $reminders)
                    } else {
                        ReminderHeaderNoData()
                    }
                }
                .padding(.bottom, 40)
                .background(Color.primary.tone100)

                ZStack {
                    Rectangle()
                        .frame(width: .infinity, height: .infinity)
                        .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
                        .foregroundStyle(.white)
                        .ignoresSafeArea()

                    VStack {
                        let filteredReminders = self.filteredReminders

                        if !filteredReminders.isEmpty {
                            ReminderContentNear()
                                .frame(width: 390)
                                .padding(.vertical, 8)

                            SparepartReminderListView(reminders: .constant(filteredReminders))
                            
//                            SparepartReminderListView(reminders: $reminders)
                            
                        } else {
                            ReminderContentNoData()
                                .frame(width: 390)
                                .padding(.vertical, 8)
                        }

                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.primary.tone100)
            .navigationBarBackButtonHidden(true)
            .navigationTitle("Pengingat")
           
//            .onAppear {
//                setupNavigationBarWithoutScroll()
//            }
//        }
    }

    private var filteredReminders: [SparepartReminder] {
        return reminders.filter { reminder in
            let progress = getProgress(currentKilometer: 15000, targetKilometer: reminder.sparepartTargetKilometer)
            return progress >= 0.66
        }
    }

    private func getProgress(currentKilometer: Double, targetKilometer: Double) -> Double {
        return min(currentKilometer / targetKilometer, 1.0)
    }
}

#Preview {
    PengingatView()
        .environmentObject(Routes())
}
