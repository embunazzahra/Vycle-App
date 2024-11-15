//
//  DataSummaryView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/11/24.
//

import SwiftUI
import SwiftData

enum SparepartCount: Hashable {
    case part(Sparepart, count: Int)
}


struct DataSummaryView: View {
    var sparepartData = Array(1...9)
    @State private var selectedTab: Int = 0 // 0: YTD, 1: 3 Tahun, 2: 5 Tahun, 3: Seluruhnya
    @Query private var allServices: [Servis]
    var ytdServices: [Servis] {
        let startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Date()))!
        return allServices.filter { $0.date >= startDate }
    }
    
    var threeYearServices: [Servis] {
        let startDate = Calendar.current.date(byAdding: .year, value: -3, to: Date())!
        return allServices.filter { $0.date >= startDate }
    }
    
    var fiveYearServices: [Servis] {
        let startDate = Calendar.current.date(byAdding: .year, value: -5, to: Date())!
        return allServices.filter { $0.date >= startDate }
    }
    
    
    
    var body: some View {
        
        VStack(spacing: 12){
            VStack {
                Text("Ringkasan servis kendaraanmu di VYCLE! Lihat semua riwayat servis dengan mudah di satu tempat")
                    .font(.subheadline)
                
                ZStack{
                    HStack{
                        ForEach((TabbedItems.allCases), id: \.self){ item in
                            Button{
                                selectedTab = item.rawValue
                            } label: {
                                CustomTabItem( title: item.title, isActive: (selectedTab == item.rawValue))
                            }
                            // Add separator except for the last item
                            if item != TabbedItems.allCases.last && selectedTab != item.rawValue {
                                Image("separator")
                            }
                        }
                    }
                    .padding(6)
                }
                .background(Color.gray.opacity(0.12))
                .cornerRadius(9)
            }
            
            
            // Custom content view based on the selected tab
            if selectedTab == 0 {
                DataContentView(sparepartData: sparepartData, services: ytdServices)
            } else if selectedTab == 1 {
                DataContentView(sparepartData: sparepartData, services: threeYearServices)
            } else if selectedTab == 2 {
                DataContentView(sparepartData: sparepartData, services: fiveYearServices)
            } else if selectedTab == 3 {
                DataContentView(sparepartData: sparepartData, services: allServices)
            }
            
            
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .navigationTitle("Ringkasan Data")
        
    }
}

#Preview {
    DataSummaryView()
}

struct TotalMileageView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.shade300)
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

struct SparepartDataCard: View {
    var sparepart: Sparepart
    var count: Int
    
    private var imageName: String {
        switch sparepart {
        case .oliMesin:
            return "olimesin_twotone"
            
        case .busi:
            return "busi_twotone"

        case .filterOli:
            return "filteroli_twotone"

        case .minyakKopling:
            return "minyakkopling_twotone"

        case .minyakRem:
            return "minyakrem_twotone"
            
        case .oliTransmisi:
            return "olitransmisi_twotone"
            
        case .airCoolant:
            return "aircoolant_twotone"
            
        case .filterUdara:
            return "filterudara_twotone"
            
        case .oliGardan:
            return "oligardan_twotone"

        default:
            return ""
        }
    }
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.tone300)
                .overlay(
                    Image(imageName),
                    alignment: .bottomTrailing
                )
            
            HStack{
                VStack {
                    Text(sparepart.rawValue)
                        .foregroundStyle(Color.neutral.tint300)
                        .font(.footnote)
                    HStack(spacing: 3){
                        Text("\(count)")
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

struct SparepartDataView: View {
    var sparepartData: [Int]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.shade300)
                .frame(maxWidth: .infinity, maxHeight: 321)
            VStack(alignment: .leading) {
                Text("Komponen yang telah diganti")
                    .foregroundStyle(Color.neutral.tint300)
                    .font(.footnote)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    ForEach(sparepartData, id: \.self) { card in
                        SparepartDataCard(sparepart: .filterUdara, count: 5)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}

enum TabbedItems: Int, CaseIterable{
    case ytd = 0
    case threeYears
    case fiveYears
    case all
    
    var title: String{
        switch self {
        case .ytd:
            return "YTD"
        case .threeYears:
            return "3 Tahun"
        case .fiveYears:
            return "5 Tahun"
        case .all:
            return "Seluruhnya"
        }
    }
}

extension DataSummaryView{
    func CustomTabItem(title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Text(title)
                .font(.system(size: 14))
                .foregroundColor(isActive ? .white : .black)
                .fontWeight(isActive ? .semibold : .regular)
            Spacer()
        }
        .frame(height: 24)
        .background(isActive ? Color.primary.shade200 : .clear)
        .cornerRadius(8)
    }
}

struct DataContentView: View {
    var sparepartData: [Int]
    var services: [Servis]
    
    var totalCost: Float {
        services.reduce(0) { $0 + $1.totalPrice }
    }
    
    var uniqueSpareParts: Set<SparepartCount> {
        let sparePartCounts = services.flatMap { $0.servicedSparepart }
            .reduce(into: [:]) { counts, sparePart in
                counts[sparePart, default: 0] += 1
            }
        
        return Set(sparePartCounts.map { SparepartCount.part($0.key, count: $0.value) })
    }
    
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 12){
                TotalMileageView()
                SparepartDataView(sparepartData: sparepartData)
                TotalCostView(totalCost: totalCost)
                CustomButton(title: "Bagikan",  iconName: "share_icon", iconPosition: .left, buttonType: .primary,horizontalPadding: 0, verticalPadding: 0) {
                    print("Tes")
                }
            }
        }
        
        
    }
}
