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
    @ObservedObject var locationManager: LocationManager  // Add LocationManager to DashboardView
    
    var body: some View {
        NavigationView {
            ScrollView{
                
                ZStack{
                    VStack{
                        ZStack {
                            Color.pink
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
                                VStack(alignment: .leading){
                                    Text("Jarak tempuh saat ini")
                                        .body(NonTitleStyle.regular).foregroundStyle(.grayShade300)
                                    Text("  \(locationManager.totalDistanceTraveled, specifier: "%.2f") kilometers")
                                        .headline()
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.grayShade300)
                                }.padding(.horizontal, 10)
                                Spacer()
                                
                                Button(action: {
                                    // Action for editing
                                }) {
                                    Image(systemName: "pencil")
                                }
                            }
                            .padding()
                            .background(Color(.background))
                            .cornerRadius(12)
                        }.padding(.horizontal, 16).offset(y: -45)
                        Spacer()
                        MapView(locations: locationManager.locationHistory)
                            .frame(height: 200)
                            .padding()
                        
                    }
                    
                    
                    
                    VStack{
                        HStack{
                            BTIndicator(locationManager: locationManager)  // Pass locationManager to BTIndicator
                            Spacer()
                        }.padding(.leading, 16).padding(.top, 16)
                        Spacer()
                        
                        Spacer()
                    }
                }
                
            }
            
        }
    }
}




#Preview {
    DashboardView(locationManager: LocationManager())
}
