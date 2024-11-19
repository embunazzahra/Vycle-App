//
//  TotalCostView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 15/11/24.
//


import SwiftUI
import SwiftData

struct TotalCostView: View {
    var totalCost: Float
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.shade300)
                .frame(maxWidth: .infinity, maxHeight: 107)
            HStack {
                Image("cost_icon")
            }
            .frame(maxWidth: .infinity, maxHeight: 107, alignment: .bottomTrailing)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Pengeluaranmu")
                    .foregroundStyle(Color.neutral.tint300)
                    .font(.footnote)
                HStack(spacing: 3){
                    Text("Rp")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.neutral.tint300)
                        .padding(.top,5)
                    Text("\(totalCost.formatted())")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.neutral.tint300)
                }
                Text("Yuk, tetap jaga kondisi suku cadangmu!")
                    .foregroundStyle(Color.neutral.tint300)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}