//
//  PengingatView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//
import SwiftUI
import SwiftData

struct RoundedCornersShape: Shape {
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct PengingatView: View {
    @Query var reminders: [Reminder]
    @EnvironmentObject var routes: Routes
    @ObservedObject var locationManager: LocationManager
    @State private var filteredReminders: [Reminder] = []
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]

    var body: some View {
        VStack {
            VStack {
                if !reminders.isEmpty {
                    ReminderHeader(reminders: reminders)
                } else {
                    ReminderHeaderNoData()
                }
            }
            .padding(.bottom, 40)
            .background(Color.primary.tone100)

            ZStack {
                Rectangle()
                    .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
                    .foregroundStyle(.white)
                    .ignoresSafeArea()

                VStack {
                    if !reminders.isEmpty {
                        let hasHighProgress = filteredReminders.contains { reminder in
                            let currentKilometer = Double(initialOdometer.last?.currentKM ?? 0)
                            let progress = getProgress(currentKilometer: currentKilometer, reminder: reminder)
                            return progress > 0.7
                        }
                        
                        if hasHighProgress {
                            DummyView()
                            ReminderContentNear()
                                .frame(width: 390)
                                .padding(.vertical, 8)
                            SparepartReminderListView(reminders: $filteredReminders, locationManager: locationManager)
                        } else {
                            Spacer()
                            DummyView()
                            ReminderContentFar()
                            Spacer()
                        }
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
        .onAppear {
            updateFilteredReminders()
        }
        .onChange(of: reminders) { _ in
            updateFilteredReminders()
        }
        .onChange(of: Double(initialOdometer.last?.currentKM ?? 0)) { _ in
            updateFilteredReminders()
        }
    }

    private func updateFilteredReminders() {
        let currentKilometer = Double(initialOdometer.last?.currentKM ?? 0)
        
        let uniqueReminders = getUniqueReminders(reminders)
        
        filteredReminders = uniqueReminders.filter { reminder in
            let progress = getProgress(currentKilometer: currentKilometer, reminder: reminder)
            return progress > 0.7
        }
    }


    private func getUniqueReminders(_ reminders: [Reminder]) -> [Reminder] {
        var uniqueReminders: [String: Reminder] = [:]

        for reminder in reminders {
            let sparepartKey = reminder.sparepart.rawValue
            
            if let existingReminder = uniqueReminders[sparepartKey] {
                if reminder.dueDate > existingReminder.dueDate {
                    uniqueReminders[sparepartKey] = reminder
                }
            } else {
                uniqueReminders[sparepartKey] = reminder
            }
        }

        return Array(uniqueReminders.values)
    }

    private func getProgress(currentKilometer: Double, reminder: Reminder) -> Double {
        let targetKilometer = reminder.kmInterval
        guard targetKilometer > 0 else { return 0.0 }
        let progress = (currentKilometer - Double(reminder.reminderOdo)) / Double(targetKilometer)
        return min(progress, 1.0)
    }

}



//#Preview {
//    PengingatView()
//        .environmentObject(LocationManager())  // Ensure LocationManager is correctly initialized
//        .environmentObject(Routes())
//}




//#Preview {
//    PengingatView()
//        .environmentObject(Routes())
//}

//struct PengingatView: View {
//    @State var reminders: [SparepartReminder] = []
//    @EnvironmentObject var routes: Routes
//
//    var body: some View {
//        NavigationStack {
//            VStack {
//                VStack {
//                    if !reminders.isEmpty {
//                        ReminderHeader(reminders: $reminders)
//                    } else {
//                        ReminderHeaderNoData()
//                    }
//                }
//                .padding(.bottom, 40)
//                .background(Color.primary.tone100)
//
//                ZStack {
//                    Rectangle()
//                        .frame(width: .infinity, height: .infinity)
//                        .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
//                        .foregroundStyle(.white)
//                        .ignoresSafeArea()
//
//                    VStack {
//                        let filteredReminders = self.filteredReminders
//
//                        if !filteredReminders.isEmpty {
//                            ReminderContentNear()
//                                .frame(width: 390)
//                                .padding(.vertical, 8)
//
//                            SparepartReminderListView(reminders: .constant(filteredReminders))
//                            
////                            SparepartReminderListView(reminders: $reminders)
//                            
//                        } else {
//                            ReminderContentNoData()
//                                .frame(width: 390)
//                                .padding(.vertical, 8)
//                        }
//
//                        Spacer()
//                    }
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//            }
//            .background(Color.primary.tone100)
//            .navigationBarBackButtonHidden(true)
//            .navigationTitle("Pengingat")
//            .toolbar {
//                ToolbarItem {
//                    NavigationLink(destination: AddReminderView(reminders: $reminders)) {
//                        Image(systemName: "plus.square.fill")
//                            .foregroundColor(Color.white)
//                    }
//                }
//            }
//           
////            .onAppear {
////                setupNavigationBarWithoutScroll()
////            }
//        }
//    }
//
//    private var filteredReminders: [SparepartReminder] {
//        return reminders.filter { reminder in
//            let progress = getProgress(currentKilometer: 15000, targetKilometer: reminder.sparepartTargetKilometer)
//            return progress >= 0.66
//        }
//    }
//
//    private func getProgress(currentKilometer: Double, targetKilometer: Double) -> Double {
//        return min(currentKilometer / targetKilometer, 1.0)
//    }
//}
//
//#Preview {
//    PengingatView()
//        .environmentObject(Routes())
//}
