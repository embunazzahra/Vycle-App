//
//  ShareContentView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 15/11/24.
//


import SwiftUI

struct ShareContentView: View {
    let totalMileage: Float
    let uniqueSpareParts: Set<SparepartCount>
    let totalCost: Float
    let vehicleIcon: String
    let vehicleYear: Int
    let dateRange: String
    
    var body: some View {
        
        VStack {
            ZStack {
                Image("data_summary_background")
                    .resizable()
                
                VStack {
                    VStack(alignment: .leading){
                        HStack {
                            Image("logo_vycle_square")
                            
                            Spacer()
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.primary.shade300)
                                HStack {
                                    Image(vehicleIcon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 32, height: 32)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.gray, lineWidth: 1))
                                    
                                    
                                    Divider()
                                        .frame(width: 1, height: 20)
                                        .overlay(.white)
                                    
                                    
                                    Text("\(String(vehicleYear))")
                                        .foregroundStyle(Color.neutral.tint300)
                                        .font(.footnote)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal,8)
                                .padding(.vertical,4)
                                
                            }.frame(width: 100)
                            
                        }
                        .frame(height: 40)
                        HStack {
                            Text("Periode:")
                                .font(.footnote)
                            Text(dateRange)
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                        
                    }
                    
                    TotalMileageView(totalMileage: totalMileage)
                    SparepartDataView(uniqueSpareParts: uniqueSpareParts)
                    TotalCostView(totalCost: totalCost)
                }
                .padding()
                //            .padding(.horizontal,38)
            }
        }
        .frame(width: 341, height: 645 )
        
    }
}

#Preview {
    ShareContentView(
        totalMileage: 10000,
        uniqueSpareParts: Set([
            SparepartCount.part(.filterUdara, count: 4),
            SparepartCount.part(.filterOli, count: 2)
        ]),
        totalCost: 200000,
        vehicleIcon: "Toyota",
        vehicleYear: 2024,
        dateRange: "Januari 2020 - Januari 2024"
    )
}

