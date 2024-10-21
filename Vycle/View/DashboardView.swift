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
    @EnvironmentObject var locationManager: LocationManager  // Add LocationManager to DashboardView
    @Query var trips: [Trip]
    @Query var vehicles : [Vehicle]
    @Query var reminders : [Reminder]
    @State private var showSheet = false
    
    @State private var odometer: Float? = 10000
    var body: some View {
        NavigationView {
            ScrollView{
                ZStack{
                    VStack{
                        ZStack {
                            Color.pink
                            VStack{
                                HStack{
                                    BTIndicator(locationManager: locationManager)  // Pass locationManager to BTIndicator
                                    Spacer()
                                }.padding(.leading, 16).padding(.top, 16)
                                Spacer()
                                
                                Spacer()
                            }
                            Image(systemName: "car.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.orange)
                                .frame(height: 150)
                                .padding(.top, 20)
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
                                    Text("\(locationManager.totalDistanceTraveled, specifier: "%.2f") Kilometer")
                                        .headline()
                                        .foregroundStyle(.grayShade300)
                                }.padding(.horizontal, 10)
                                Spacer()
                                
                                Button(action: {
                                    // Action for editing
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
                                                showSheet.toggle()
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
                        
                        
                        
                        HStack{
                            HaveReminderView().padding(.horizontal, 16)
                        }
//                        MapView(locations: locationManager.locationHistory)
//                            .frame(height: 200)
                    }
                }
                
            }
            
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
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text("Cek Pengingat Yuk!").headline().foregroundColor(.neutral.shade300)
                Text("Ada suku cadang yang harus diganti ").footnote(.regular).foregroundColor(.neutral.tone300)
            }
            Spacer()
            Button(action: {
                //
            }){
                ZStack{
                    Color.primary.base
                    Text("Lihat Semua").foregroundStyle(Color.background)
                }.cornerRadius(14)
            }.frame(width: 120, height: 35)
        }
        
    }
}

#Preview {
    DashboardView()
        .environmentObject(LocationManager()) 
}
