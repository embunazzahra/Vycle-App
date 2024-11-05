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
    @Query var vehicles : [Vehicle]
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
    var body: some View {
        NavigationView {
            VStack{
                ZStack {
                    Color.pink
                    Image(filteredReminders.isEmpty ? "dashboard_normal" : "dashboard_rusak")
                        .resizable() // Makes the image resizable
                        .scaledToFill() // Scales the image to fill the available space
                        .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures it stretches to fill the frame
                        .clipped() // Clips any overflowing parts of the image
                    VStack{
                        HStack{
                            BTIndicator(locationManager: locationManager).onTapGesture {
//                                BluetoothSheet(showBluetoothSheet: $showBluetoothSheet, locationManager: locationManager)
//                                showBluetoothSheet.toggle()
                                routes.navigate(to: .BeaconConfigView)
                            }
                            Spacer()
                        }.padding(.leading, 16).padding(.top, 16)
                        Spacer()
                        
                        Spacer()
                    }
                }.frame(height: 283)
                VStack{
                    HStack(alignment: .center) {
                        Image(systemName: "car.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.orange)
                            .frame(height: 40)
                        VStack(alignment: .leading, spacing: 4){
                            Text("Jarak tempuh saat ini").caption1(NonTitleStyle.regular).foregroundStyle(.grayShade300)
                            if !locationHistory.isEmpty {
                                let totalDistance = calculateTotalDistance() ?? 0
                                Text("\(Int(totalDistance)) Kilometer")
                                    .headline()
                                    .foregroundStyle(.grayShade300)
                                
                                    List(locationHistory.sorted(by: { $0.time > $1.time }).prefix(5), id: \.self) { location in
                                        if location.distance == 0 {
                                            Text("Time: \(location.time), Distance is 0: \(location.distance)")
                                        } else {
                                            Text("Time: \(location.time), Distance: \(location.distance)")
                                        }
                                        
                                    }
                               
                                
//
                                
                            } else {
                                Text("\(Int(initialOdometer.first?.currentKM ?? 12)) Kilometer")
                                    .headline()
                                    .foregroundStyle(.grayShade300)
                            }
                            
                            
                        }.padding(.horizontal, 10)
                        Spacer()
                        
                        Button(action: {
                            // Action for editing
                            _ = calculateTotalDistance()
                            showOdoSheet.toggle()
                            
                        }) {
                            Image(systemName: "pencil").foregroundStyle(Color.white)
                        }.frame(width: 28, height: 28).background(Color.blue).cornerRadius(8).sheet(isPresented: $showOdoSheet) {
                            
                            OdometerSheet(
                                showSheet: $showOdoSheet,
                                odometer: $odometer,
                                showOdoSheet: $showOdoSheet,
                                calculateTotalDistance: calculateTotalDistance // Pass the function here
                            )
                            
                        }
                    }
                    .padding()
                    .background(Color(.background))
                    .cornerRadius(12)
                    .shadow(radius: 4, y: 2)
                }.padding(.horizontal, 16).offset(y: -45)

                VStack {
                    if !filteredReminders.isEmpty {
                        HStack{
                            HaveReminderView().padding(.horizontal, 16)
                        }
                        ForEach($filteredReminders, id: \.self) { $reminder in
                            let totalDistance = calculateTotalDistance() ?? 0
                            SparepartReminderCard(
                                reminder: $reminder,
                                currentKM: totalDistance
                            )
                            .contentShape(Rectangle())
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                            .listSectionSeparator(.hidden)
                        }
                        //                                MapView(locations: locationHistory).frame(height: 300)
                    } else {
                        
//                                                        Spacer()
//                                                        Text("last location: \(locationHistory.first?.distance)")
//                                                        Text("last location: \(locationHistory.first?.time)")
//                                                        ForEach(locationHistory){location in
//                                                            Text("Time: \(location.time) Longitude: \(location.longitude) Latitude: \(location.latitude) Distance: \(location.distance)")
//                        
//                                                        }
                        NoReminderView()
        
                    }
                    
                }
                Spacer()
            }.onAppear {
                // Use locationManager data instead of hardcoded values
//                SwiftDataService.shared.insertOdometerData(odometer: odometer ?? 0)
//                calculateTotalDistance()
                filteredReminders = Array(reminders.filter { reminder in
                    let progress = getProgress(currentKilometer: calculateTotalDistance() ?? 0, targetKilometer: reminder.kmInterval)
                    return progress > 0.7
                }.prefix(2))
//                SwiftDataService.shared.insertOdometerData(odometer: Float(calculateTotalDistance() ?? 0))
                if locationManager.checkAuthorizationStatus() != .authorizedAlways {
                    showSettingsAlert = true
                }
                
                
            }.alert(isPresented: $showSettingsAlert) {
                Alert(
                    title: Text("We does not Have the Access to Your Location While in the Background"),
                    message: Text("Tap Settings > Location and Select Always"),
                    primaryButton: .default(Text("Settings"), action: openAppSettings),
                    secondaryButton: .cancel()
                )
            }
            
        }}
    
    private func getProgress(currentKilometer: Double, targetKilometer: Float) -> Double {
        return min(Double(currentKilometer) / Double(targetKilometer), 1.0)
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


struct NoReminderView : View {
    var body: some View {
        Image("no-service-dashboard")
        Text("Belum ada suku cadang yang mendesak").headline().foregroundColor(.neutral.shade300)
        Text("Saat ini aman, tapi pastikan siap sebelum waktunya tiba").footnote(.regular).foregroundColor(.neutral.tone300)
        
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
struct HaveReminderView : View {
    @EnvironmentObject var routes: Routes
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("Cek Pengingat Yuk!").headline().foregroundColor(.neutral.shade300)
                Text("Ada suku cadang yang harus diganti ").footnote(.regular).foregroundColor(.neutral.tone300)
            }
            Spacer()
            Button(action: {
                routes.navigate(to: .AllReminderView)
            }){
                ZStack{
                    Color.primary.base
                    Text("Lihat Semua").foregroundStyle(Color.background)
                }.cornerRadius(14)
            }.frame(width: 120, height: 35)
        } .padding(.top, -30)
        
    }
}

