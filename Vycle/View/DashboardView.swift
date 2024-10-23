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
    @Query var reminders : [Reminder]
    @State private var showSheet = false
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]
    @State private var odometer: Float?
    
    var body: some View {
//        let limitedLocationHistory = locationHistory.prefix(10)
        
        NavigationView {
            ScrollView{
                ZStack{
                    VStack{
                        ZStack {
                            Color.pink
                            Image("dashboard_normal")
                                .resizable() // Makes the image resizable
                                .scaledToFill() // Scales the image to fill the available space
                                .frame(maxWidth: .infinity, maxHeight: .infinity) // Ensures it stretches to fill the frame
                                .clipped() // Clips any overflowing parts of the image
                            VStack{
                                HStack{
                                    BTIndicator(locationManager: locationManager)  // Pass locationManager to BTIndicator
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
                                    //                                    Text("\(locationHistory[0].distance ?? 0, specifier: "%.2f") Kilometer")
                                    //                                        .headline()
                                    //                                        .foregroundStyle(.grayShade300)
                                    let initialOdo = initialOdometer.first?.currentKM ?? 0
                                    ForEach(initialOdometer){odometer in
                                        Text("\(Int(odometer.currentKM)) Kilometer Odo")
                                    }
                                    Text("\(Int(initialOdo)) Kilometer Odo")
                                    if let firstLocation = locationHistory.first {
//                                        let totalDistance = (Double(initialOdo) + (firstLocation.distance ?? 0))
                                        let totalDistance = calculateTotalDistance() ?? 0
//                                        odometer = Float(totalDistance)
                                        Text("\(Int(totalDistance)) Kilometer")
                                            .headline()
                                            .foregroundStyle(.grayShade300)
                                        
                                    } else {
                                        Text("\(Int(initialOdo)) Kilometer")
                                            .headline()
                                            .foregroundStyle(.grayShade300)
                                    }

                                    
                                }.padding(.horizontal, 10)
                                Spacer()
                                
                                Button(action: {
                                    // Action for editing
                                    _ = calculateTotalDistance()
                                    showSheet.toggle()
                                    
                                }) {
                                    Image(systemName: "pencil").foregroundStyle(Color.white)
                                }.frame(width: 28, height: 28).background(Color.blue).cornerRadius(8).sheet(isPresented : $showSheet){
                                    ZStack{
                                        VStack{
                                            HStack{
                                                Button(action: {
                                                    showSheet.toggle()
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
                                                SwiftDataService.shared.insertOnBoarding(
                                                    vehicleType: .car,
                                                    vehicleBrand: .car(.honda),
                                                    odometer: odometer ?? 0,
                                                    serviceHistory: []
                                                )
                                                showSheet.toggle()
                                                _ = calculateTotalDistance()
                                            }
                                        }
                                        
                                    }
                                    
                                }
                            }
                            .padding()
                            .background(Color(.background))
                            .cornerRadius(12)
                            .shadow(radius: 4, y: 2)
                        }.padding(.horizontal, 16).offset(y: -45)
                            VStack {
                                if !reminders.isEmpty {
                                    HStack{
                                        HaveReminderView().padding(.horizontal, 16)
                                    }
                                    
                                    ForEach(reminders) { reminder in
                                        SparepartReminderCard(reminder: reminder, currentKilometer: 10, serviceOdometer: 10)
                                            .listRowInsets(EdgeInsets())
                                            .listRowSeparator(.hidden)
                                            .listSectionSeparator(.hidden)
                                    }
                                } else {
                                    Spacer()
                                    NoReminderView()
                                    
                                }
                               
                            }.padding(.horizontal, 16)
                            
                        
                    }
                    
                }
                
            }
        }
        
    }
    
    func calculateTotalDistance() -> Double? {
        let initialOdoValue = initialOdometer.first?.currentKM ?? 0
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

//#Preview {
//    DashboardView()
//        .environmentObject(LocationManager()) 
//}
