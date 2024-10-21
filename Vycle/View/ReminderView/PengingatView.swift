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
    @ObservedObject var locationManager: LocationManager  // Use actual distance from locationManager
    @State private var filteredReminders: [Reminder] = []

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
                            let progress = getProgress(currentKilometer: locationManager.totalDistanceTraveled, targetKilometer: reminder.kmInterval + 5)
                            return progress > 0.7
                        }
                        
                        if hasHighProgress {
                            ReminderContentNear()
                                .frame(width: 390)
                                .padding(.vertical, 8)
                            SparepartReminderListView(reminders: $filteredReminders, locationManager: locationManager)
                        } else {
                            Spacer()
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
            // Use locationManager data instead of hardcoded values
            filteredReminders = reminders.filter { reminder in
                let progress = getProgress(currentKilometer: locationManager.totalDistanceTraveled, targetKilometer: reminder.kmInterval + 5)
                return progress > 0.7
            }
        }
    }

    // Updated to use dynamic currentKilometer from locationManager
    private func getProgress(currentKilometer: Double, targetKilometer: Float) -> Double {
        return min(Double(currentKilometer) / Double(targetKilometer), 1.0)
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
