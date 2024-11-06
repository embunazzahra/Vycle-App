
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
    
    var totalDistance: Double {
        let initialOdoValue = initialOdometer.last?.currentKM ?? 0
        if let firstLocation = locationHistory.first {
            return Double(initialOdoValue) + (firstLocation.distance ?? 0)
        } else {
            return Double(initialOdoValue)
        }
    }

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
                        let hasHighKilometerDifference = filteredReminders.contains { reminder in
                            let currentKilometer = Double(totalDistance)
                            let kilometerDifference = getKilometerDifference(currentKilometer: currentKilometer, reminder: reminder)
                            return kilometerDifference <= 500
                        }
                        
                        if hasHighKilometerDifference {
//                            DummyView()
                            ReminderContentNear()
                                .frame(width: 390)
                                .padding(.vertical, 8)
                            SparepartReminderListView(reminders: $filteredReminders, locationManager: locationManager)
                        } else {
                            Spacer()
//                            DummyView()
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
        .onChange(of: Double(totalDistance)) { _ in
            updateFilteredReminders()
        }
    }

    private func updateFilteredReminders() {
        let currentKilometer = Double(totalDistance)
        
        let uniqueReminders = getUniqueReminders(reminders)
        
        filteredReminders = uniqueReminders
            .filter { reminder in
                let kilometerDifference = getKilometerDifference(currentKilometer: currentKilometer, reminder: reminder)
                return kilometerDifference <= 500
            }
            .sorted {
                if $0.isDraft != $1.isDraft {
                    return !$0.isDraft
                } else {
                    return getKilometerDifference(currentKilometer: currentKilometer, reminder: $0) <
                           getKilometerDifference(currentKilometer: currentKilometer, reminder: $1)
                }
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

    private func getKilometerDifference(currentKilometer: Double, reminder: Reminder) -> Double {
        
        if reminder.dueDate <= Date() {
            return 0.0
        } else {
            if reminder.isDraft == true {
                return 0.0
            }
            else {
                return ceil(Double(reminder.kmInterval) - (currentKilometer - Double(reminder.reminderOdo)))
            }
        }
//        if reminder.isDraft == true {
//            return 0.0
//        }
//        
//        return ceil(Double(reminder.kmInterval) - (currentKilometer - Double(reminder.reminderOdo)))
    }
    
//    private func getProgress(currentKilometer: Double, reminder: Reminder) -> Double {
//        if reminder.isDraft {
//            return 0.0
//        }
//        
//        let targetKilometer = reminder.kmInterval
//        guard targetKilometer > 0 else { return 0.0 }
//        
//        let progress = (currentKilometer - Double(reminder.reminderOdo)) / Double(targetKilometer)
//        return min(progress, 1.0)
//    }
    
}


//import SwiftUI
//import SwiftData
//
//struct RoundedCornersShape: Shape {
//    var corners: UIRectCorner
//    var radius: CGFloat
//    
//    func path(in rect: CGRect) -> Path {
//        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
//        return Path(path.cgPath)
//    }
//}
//
//struct PengingatView: View {
//    @Query var reminders: [Reminder]
//    @EnvironmentObject var routes: Routes
//    @ObservedObject var locationManager: LocationManager
//    @State private var filteredReminders: [Reminder] = []
//    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
//    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]
//    
//    var totalDistance: Double {
//        let initialOdoValue = initialOdometer.last?.currentKM ?? 0
//        if let firstLocation = locationHistory.first {
//            return Double(initialOdoValue) + (firstLocation.distance ?? 0)
//        } else {
//            return Double(initialOdoValue)
//        }
//    }
//
//    var body: some View {
//        VStack {
//            VStack {
//                if !reminders.isEmpty {
//                    ReminderHeader(reminders: reminders)
//                } else {
//                    ReminderHeaderNoData()
//                }
//            }
//            .padding(.bottom, 40)
//            .background(Color.primary.tone100)
//
//            ZStack {
//                Rectangle()
//                    .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 20))
//                    .foregroundStyle(.white)
//                    .ignoresSafeArea()
//
//                VStack {
//                    if !reminders.isEmpty {
//                        let hasHighProgress = filteredReminders.contains { reminder in
//                            let currentKilometer = Double(totalDistance)
//                            let progress = getProgress(currentKilometer: currentKilometer, reminder: reminder)
//                            return progress > 0.7
//                        }
//                        
//                        if hasHighProgress {
//                            DummyView()
//                            ReminderContentNear()
//                                .frame(width: 390)
//                                .padding(.vertical, 8)
//                            SparepartReminderListView(reminders: $filteredReminders, locationManager: locationManager)
//                        } else {
//                            Spacer()
//                            DummyView()
//                            ReminderContentFar()
//                            Spacer()
//                        }
//                    } else {
//                        ReminderContentNoData()
//                            .frame(width: 390)
//                            .padding(.vertical, 8)
//                    }
//
//                    Spacer()
//                }
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//        }
//        .background(Color.primary.tone100)
//        .navigationBarBackButtonHidden(true)
//        .navigationTitle("Pengingat")
//        .onAppear {
//            updateFilteredReminders()
//        }
//        .onChange(of: reminders) { _ in
//            updateFilteredReminders()
//        }
//        .onChange(of: Double(totalDistance)) { _ in
//            updateFilteredReminders()
//        }
//    }
//
//    private func updateFilteredReminders() {
//        let currentKilometer = Double(totalDistance)
//        
//        let uniqueReminders = getUniqueReminders(reminders)
//        
//        filteredReminders = uniqueReminders
//            .filter { reminder in
//                let progress = getProgress(currentKilometer: currentKilometer, reminder: reminder)
//                return progress > 0.7
//            }
//            .sorted {
//                getProgress(currentKilometer: currentKilometer, reminder: $0) >
//                getProgress(currentKilometer: currentKilometer, reminder: $1)
//            }
//    }
//
//    private func getUniqueReminders(_ reminders: [Reminder]) -> [Reminder] {
//        var uniqueReminders: [String: Reminder] = [:]
//
//        for reminder in reminders {
//            let sparepartKey = reminder.sparepart.rawValue
//            
//            if let existingReminder = uniqueReminders[sparepartKey] {
//                if reminder.dueDate > existingReminder.dueDate {
//                    uniqueReminders[sparepartKey] = reminder
//                }
//            } else {
//                uniqueReminders[sparepartKey] = reminder
//            }
//        }
//
//        return Array(uniqueReminders.values)
//    }
//
//    private func getProgress(currentKilometer: Double, reminder: Reminder) -> Double {
//        if reminder.isDraft {
//            return 0.0
//        }
//        
//        let targetKilometer = reminder.kmInterval
//        guard targetKilometer > 0 else { return 0.0 }
//        let progress = (currentKilometer - Double(reminder.reminderOdo)) / Double(targetKilometer)
//        return min(progress, 1.0)
//    }
//}
//
