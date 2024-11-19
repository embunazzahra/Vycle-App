//
//  DashboardView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import SwiftData

struct DashboardView: View {
    @EnvironmentObject var routes: Routes
    @ObservedObject var locationManager: LocationManager
    @Query var trips: [Trip]
    //    @Query var vehicles : [Vehicle]
    @Binding var tabReminder: Bool
    @State private var showSettingsAlert = false
    @Query var reminders : [Reminder]
    @State private var showingAlert = false
    @State private var showSheet = false
    @State private var showOdoSheet = false
    @State private var showBluetoothSheet = false
    //    @Query var locationHistory : [LocationHistory]
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]
    @State private var odometer: Float?
    @State private var filteredReminders: [Reminder] = []
    
    
    var totalDistance: Double {
        let initialOdoValue = initialOdometer.last?.currentKM ?? 0
        if let firstLocation = locationHistory.first {
            return Double(initialOdoValue) + (firstLocation.distance ?? 0)
        } else {
            return Double(initialOdoValue)
        }
    }
    
    var body: some View {
    
            ScrollView {
                VStack{
                    ZStack {
                        Color.pink
                        if SwiftDataService.shared.fetchServices().isEmpty {
                            Image("dashboard_empty")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                        } else {
                            Image(filteredReminders.isEmpty ? "dashboard_normal" : "dashboard_rusak")
                                .resizable()
                                .scaledToFill()
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .clipped()
                        }
                        VStack{
                            HStack{
                                BTIndicator(locationManager: locationManager).onTapGesture {
                                    //                                BluetoothSheet(showBluetoothSheet: $showBluetoothSheet, locationManager: locationManager)
                                    //                                showBluetoothSheet.toggle()
                                    routes.navigate(to: .BeaconConfigView)
                                }
                                Spacer()
                            }.padding(.leading, 16).padding(.top, 24)
                            Spacer()
                            
                            Spacer()
                        }
                    }.frame(height: 283)
                    
                    VStack{
                        HStack(alignment: .center) {
                            VStack {
                                if SwiftDataService.shared.getCurrentVehicle()?.brand.isCustomBrand == true {
                                    Image("merk_kendaraan")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.orange)
                                        .frame(height: 28)
                                } else {
                                    Image(SwiftDataService.shared.getCurrentVehicle()?.brand.stringValue ?? "?")
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.orange)
                                        .frame(height: 28)
                                }
                                
                                if let year = SwiftDataService.shared.getCurrentVehicle()?.year {
                                    Text(String(year))
                                        .caption2(.regular)
                                        .foregroundStyle(Color.neutral.shade300)
                                }
                            }
                            VStack(alignment: .leading, spacing: 4){
                                Text("Jarak tempuh saat ini").caption1(NonTitleStyle.regular).foregroundStyle(.grayShade300)
                                if !locationHistory.isEmpty {
                                    let totalDistance = calculateTotalDistance() ?? 0
                                    Text("\(Int(totalDistance)) Kilometer")
                                        .headline()
                                        .foregroundStyle(.grayShade300)
                                } else {
                                    Text("\(Int(initialOdometer.last?.currentKM ?? 12)) Kilometer")
                                        .headline()
                                        .foregroundStyle(.grayShade300)
                                }
                                
                                
                            }.padding(.horizontal, 10)
                            
                            Spacer()
                            
                            VStack{
                                Button(action: {
                                    // Action for editing
                                    _ = calculateTotalDistance()
                                    showOdoSheet.toggle()
                                    
                                }) {
                                    Image(systemName: "pencil").foregroundStyle(Color.primary.shade100)
                                }.frame(width: 28, height: 28).background(Color.white).overlay( // Add the border
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.primary.shade100, lineWidth: 1)
                                ).sheet(isPresented: $showOdoSheet) {
                                    OdometerSheet(
                                        showSheet: $showOdoSheet,
                                        odometer: $odometer,
                                        showOdoSheet: $showOdoSheet,
                                        calculateTotalDistance: calculateTotalDistance // Pass the function here
                                    )
                                    
                                }
                                Text("Edit").caption2(.emphasized).foregroundStyle(Color.primary.shade100)
                            }
                        }
                        .padding()
                        .background(Color(.background))
                        .cornerRadius(12)
                        .shadow(radius: 4, y: 2)
                    }.padding(.horizontal, 16).offset(y: -45)
                    
                    VStack {
                        if SwiftDataService.shared.fetchServices().isEmpty{
                            HStack(alignment: .top){
                                VStack(alignment: .leading){
                                    Text("Siap-siap servis berkala di \(getRoundedOdometer())!").headline().foregroundColor(.neutral.shade300)
                                    Text("Jaga performa kendaraan tetap prima!").footnote(.regular).foregroundColor(.neutral.tone300)
                                }
                                Spacer()
                            }.padding(.horizontal, 16).offset(y: -30)
                            ZStack{
                                //                            Color.green
                                Image("dashboard_card").resizable()
                                    .scaledToFill()
                                    .frame(width: 360, height: 200)
                                    .clipped()
                                    .offset(y: -25)
                                HStack{
                                    Text("Lihat suku cadang lebih detail").foregroundStyle(Color.blueLoyaltyTone100)
                                    Image(systemName: "chevron.right").foregroundStyle(Color.blueLoyaltyTone100)
                                }.padding(.horizontal, 16).padding(.vertical, 8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(.blue, lineWidth: 1)
                                    ).offset(y: 40)
                                    .onTapGesture{
                                        routes.navigate(to: .GuideView)
                                    }
                            }
                            
                        } else {
                            if !filteredReminders.isEmpty {
                                VStack {
                                    HStack{
                                        HaveReminderView(tabReminder: $tabReminder).padding(.horizontal, 16)
                                    }
                                    SparepartReminderListView(reminders: $filteredReminders, locationManager: locationManager)
                                    
                                    ForEach(filteredReminders.indices, id: \.self) { index in
                                        SparepartReminderCard(reminder: $filteredReminders[index], currentKM: totalDistance)
                                            .contentShape(Rectangle())
                                    }

                                    
                                    
                                    DataSummaryCardView()
                                        
                                }
                                .offset(y:-30)
                                
                                
                            } else {
                                DataSummaryCardView()
                                    .offset(y: -30)
                                NoReminderView()
                                    .offset(y: -30)
                                
                            }
                            
                        }
                        
                    }
                    
                    
                }
            }
            .onAppear {
                updateFilteredReminders()
                
                if locationManager.checkAuthorizationStatus() != .authorizedAlways {
                    showSettingsAlert = true
                }
            }
            .onChange(of: reminders) { _ in
                updateFilteredReminders()
            }
            .onChange(of: Double(totalDistance)) { _ in
                updateFilteredReminders()
            }
            .alert(isPresented: $showSettingsAlert) {
                Alert(
                    title: Text("Kami tidak memiliki akses ke lokasi Anda saat berada di latar belakang"),
                    message: Text("Buka Pengaturan > Lokasi dan pilih Selalu"),
                    primaryButton: .default(Text("Settings"), action: openAppSettings),
                    secondaryButton: .cancel()
                )
            }
            
        }
    
    //    private func getProgress(currentKilometer: Double, targetKilometer: Float) -> Double {
    //        return min(Double(currentKilometer) / Double(targetKilometer), 1.0)
    //    }
    
    private func getRoundedOdometer() -> Int {
        let totalDistance = calculateTotalDistance() ?? 0
        return roundUpToNextTenThousand(totalDistance)
    }
    func roundUpToNextTenThousand(_ value: Double) -> Int {
        let interval = 10000
        return ((Int(value) + interval - 1) / interval) * interval
    }
    
    private func updateFilteredReminders() {
        let currentKilometer = Double(totalDistance)
        
        let uniqueReminders = getUniqueReminders(reminders)
        
        filteredReminders = Array(uniqueReminders
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
            .prefix(2)
        )
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
    
    func openAppSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
        }
    }
    
    func calculateTotalDistance() -> Double? {
        let initialOdoValue = initialOdometer.last?.currentKM ?? 0
        if let firstLocation = locationHistory.first {
            let totalDistance = Double(initialOdoValue) + (firstLocation.distance ?? 0)
            // Update the odometer state here
            odometer = Float(totalDistance)
            return totalDistance
        } else {
            // If no location history, just return the initial odometer value
            odometer = Float(initialOdoValue)
            return Double(initialOdoValue)
        }
        
    }
    
}

//#Preview {
//    DashboardView(locationManager: LocationManager())
//}


struct NoReminderView : View {
    var body: some View {
        Image("no-service-dashboard")
        Text("Belum ada suku cadang yang mendesak").headline().foregroundColor(.neutral.shade300)
        Text("Saat ini aman, tapi pastikan siap sebelum waktunya tiba").footnote(.regular).foregroundColor(.neutral.tone300)
        
    }
}

struct DataSummaryCardView : View {
    @EnvironmentObject var routes: Routes
    
    var body: some View {
        //Data analytics
        HStack(alignment: .top){
            VStack(alignment: .leading){
                Text("Ada ringkasan data, nih😉").headline().foregroundColor(.neutral.shade300)
                Text("Coba cek seluruh aktivitas kendaraanmu di sini").footnote(.regular).foregroundColor(.neutral.tone300)
            }
            Spacer()
        }
        .padding(.horizontal)
        
        ZStack{
            Image("ringkasan_data_card").resizable()
                .scaledToFill()
                .frame(width: 360, height: 200)
                .clipped()
                .overlay (
                    HStack{
                        Text("Mau lihat ringkasannya").foregroundStyle(Color.blueLoyaltyTone100)
                        Image(systemName: "chevron.right").foregroundStyle(Color.blueLoyaltyTone100)
                    }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.blue, lineWidth: 1)
                        )
                        .offset(y:-12)
                        .onTapGesture{
                            routes.navigate(to: .DataSummaryView)
                        }
                    ,
                    alignment: .bottom
                )
        }
//        .padding(.bottom)
        
    }
}

struct HaveReminderView : View {
    @Binding var tabReminder: Bool
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("Cek Pengingat Yuk!").headline().foregroundColor(.neutral.shade300)
                Text("Ada suku cadang yang harus diganti ").footnote(.regular).foregroundColor(.neutral.tone300)
            }
            Spacer()
            Button(action: {
                tabReminder.toggle()
            }){
                ZStack{
                    Color.primary.base
                    Text("Lihat Semua").foregroundStyle(Color.background)
                }.cornerRadius(14)
            }.frame(width: 120, height: 35)
        }
        
    }
}

struct BluetoothSheet: View {
    @Binding var showBluetoothSheet: Bool
    @AppStorage("vBeaconID") private var vBeaconID: String = ""
    @ObservedObject var locationManager: LocationManager
    @State private var isRangingVBeacon: Bool = false
    @State private var keyboardHeight: CGFloat = 0.0
    @State private var onBoardingDataSaved: Bool = false
    @State private var showGuide: Bool = false
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: {
                        showBluetoothSheet.toggle()
                    }) {
                        Image(systemName: "xmark").foregroundColor(Color.neutral.tint300)
                    }
                    
                    Spacer()
                }.padding(.horizontal, 24).padding(.vertical, 24).background(Color.primary.tone100)
                
                Spacer()
            }
            VStack{
                HStack{
                    Spacer()
                    Text("Ubah VBeacon").title3(.emphasized).foregroundColor(Color.neutral.tint300)
                    
                    Spacer()
                }.padding(.horizontal, 24).padding(.top, 20)
                Spacer()
            }
            VStack(alignment: .center){
                ConfigurationView(
                    locationManager: locationManager,
                    vBeaconID: $vBeaconID,
                    showGuide: $showGuide,
                    isRangingVBeacon: $isRangingVBeacon,
                    onBoardingDataSaved: $onBoardingDataSaved,
                    keyboardHeight: $keyboardHeight,
                    hideHeader: true
                )
                .transition(.move(edge: .trailing))
            }
        }
    }
}
struct OdometerSheet: View {
    @Binding var showSheet: Bool
    @Binding var odometer: Float?
    @Binding var showOdoSheet: Bool
    var calculateTotalDistance: () -> Double?
    var body: some View {
        ZStack{
            VStack{
                HStack{
                    Button(action: {
                        showOdoSheet.toggle()
                    }) {
                        Image(systemName: "xmark").foregroundColor(Color.neutral.tint300)
                    }
                    
                    Spacer()
                }.padding(.horizontal, 24).padding(.vertical, 24).background(Color.primary.tone100)
                
                Spacer()
            }
            VStack{
                HStack{
                    Spacer()
                    Text("Ubah Odometer").title3(.emphasized).foregroundColor(Color.neutral.tint300)
                    
                    Spacer()
                }.padding(.horizontal, 24).padding(.top, 20)
                Spacer()
            }
            VStack(alignment: .center){
                ZStack (alignment: .center){
                    
                    
                    Image("odometer")
                    VStack {
                        Text("KM")
                            .font(.custom("Technology-Bold", size: 24))
                        OdometerInput(odometer: $odometer)
                    }.padding(.bottom, 36)
                }.frame(maxWidth: .infinity, alignment: .center)
            }
            VStack{
                Spacer()
                CustomButton(title: "Simpan Perubahan"){
                    //                    SwiftDataService.shared.insertOnBoarding(
                    //                        vehicleType: .car,
                    //                        vehicleBrand: .car(.honda),
                    //                        odometer: odometer ?? 0,
                    //                        serviceHistory: []
                    //                    )
                    SwiftDataService.shared.insertOdometerData(odometer: odometer ?? 0)
                    SwiftDataService.shared.insertLocationHistory(distance: nil, latitude: 0, longitude: 0, time: Date())
                    showOdoSheet.toggle()
                    _ = calculateTotalDistance()
                }
            }
        }
        
    }
}

