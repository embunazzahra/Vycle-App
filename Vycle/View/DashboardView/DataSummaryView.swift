//
//  DataSummaryView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/11/24.
//

import SwiftUI

struct DataSummaryView: View {
    let cards = Array(1...9)
    
    var body: some View {
        VStack(spacing: 12){
            Text("Ringkasan servis kendaraanmu di VYCLE! Lihat semua riwayat servis dengan mudah di satu tempat")
                .font(.subheadline)
            TotalMileageView()
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primary.shade100)
                    .frame(maxWidth: .infinity, maxHeight: 321)
                VStack(alignment: .leading) {
                    Text("Komponen yang telah diganti")
                        .foregroundStyle(Color.neutral.tint300)
                        .font(.footnote)
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                        ForEach(cards, id: \.self) { card in
                            SparepartDataCard()
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
            TotalCostView()
        }
        .padding()
    }
}

#Preview {
    DataSummaryView()
}

struct TotalMileageView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.shade100)
                .frame(maxWidth: .infinity, maxHeight: 107)
            HStack {
                Image("street_car")
                    .resizable()
                    .frame(width: 119, height: 62)
            }
            .frame(maxWidth: .infinity, maxHeight: 107, alignment: .bottomTrailing)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Total Perjalananmu")
                    .foregroundStyle(Color.neutral.tint300)
                    .font(.footnote)
                HStack(spacing: 3){
                    Text("15.000")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.neutral.tint300)
                    Text("Kilometer")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.neutral.tint300)
                        .padding(.top,5)
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

struct TotalCostView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.shade100)
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
                    Text("15.000")
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

struct SparepartDataCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.shade300)
                .overlay(
                    Image("filterudara_twotone"),
                    alignment: .bottomTrailing
                )
            
            HStack{
                VStack {
                    Text("Filter udara")
                        .foregroundStyle(Color.neutral.tint300)
                        .font(.footnote)
                    HStack(spacing: 3){
                        Text("5")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.neutral.tint300)
                        Text("kali")
                            .font(.caption)
                            .foregroundStyle(Color.neutral.tint300)
                            .padding(.top,5)
                    }
                }
                .frame(maxWidth: 55, alignment: .leading)
                Spacer()
            }
            .frame(maxWidth: 108)
            .padding(8)
        }
        .frame(maxWidth: 108, maxHeight: 85)
    }
}
