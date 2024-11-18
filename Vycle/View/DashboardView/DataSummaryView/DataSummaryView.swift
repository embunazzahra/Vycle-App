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
    @EnvironmentObject var routes: Routes
    
    @State private var selectedTab: Int = 0 // 0: YTD, 1: 3 Tahun, 2: 5 Tahun, 3: Seluruhnya
    @Query private var allServices: [Servis]
    @Query private var allOdometers: [Odometer]
    
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
    
    var latestOdometer: Odometer? {
        return allOdometers.sorted(by: { $0.date > $1.date }).first
    }
    
    // For each time period (YTD, 3 years, 5 years, all)
    var latestOdometerYTD: Float {
        return odometerDifference(for: 1)
    }

    var latestOdometer3Years: Float {
        return odometerDifference(for: 3)
    }

    var latestOdometer5Years: Float {
        return odometerDifference(for: 5)
    }

    var latestOdometerAllTime: Float {
        guard let latestReading = latestOdometer else {
            return 0 // No odometer readings available
        }
        return latestReading.currentKM // Return the latest odometer reading if it's all-time
    }
    
    func odometerDifference(for years: Int) -> Float {
        let endDate = Date() // Current date
        let startDate = Calendar.current.date(byAdding: .year, value: -years, to: endDate)!

        // Get the latest odometer reading
        guard let latestReading = latestOdometer else {
            return 0 // No odometer readings available
        }

        // Get the earliest odometer reading in the given period (before the start date)
        guard let earliestReadingInPeriod = allOdometers
            .filter({ $0.date >= startDate && $0.date <= endDate })
            .sorted(by: { $0.date < $1.date })
            .first else {
                return latestReading.currentKM // If there's no previous reading, return just the latest reading
        }

        // Return the difference between the latest reading and the earliest reading within the given period
        return latestReading.currentKM - earliestReadingInPeriod.currentKM
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
                DataContentView(services: ytdServices, odometer: latestOdometerYTD, dateRange: dateRange(for: selectedTab))
            } else if selectedTab == 1 {
                DataContentView(services: threeYearServices, odometer: latestOdometer3Years, dateRange: dateRange(for: selectedTab))
            } else if selectedTab == 2 {
                DataContentView(services: fiveYearServices, odometer: latestOdometer5Years, dateRange: dateRange(for: selectedTab))
            } else if selectedTab == 3 {
                DataContentView(services: allServices, odometer: latestOdometerAllTime, dateRange: dateRange(for: selectedTab))
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

extension DataSummaryView {
    func dateRange(for tab: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "id_ID") // Set to Indonesian for "Januari", etc.
        
        let endDate = Date()
        let startDate: Date
        
        switch tab {
        case 0: // YTD (Year to Date)
            startDate = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: endDate))!
        case 1: // 3 Tahun (3 years ago)
            startDate = Calendar.current.date(byAdding: .year, value: -3, to: endDate)!
        case 2: // 5 Tahun (5 years ago)
            startDate = Calendar.current.date(byAdding: .year, value: -5, to: endDate)!
        case 3: // Seluruhnya (All time)
            startDate = allServices.min(by: { $0.date < $1.date })?.date ?? endDate
        default:
            startDate = endDate
        }
        
        // Format start and end date to display as month year
        let startDateString = dateFormatter.string(from: startDate)
        let endDateString = dateFormatter.string(from: endDate)
        
        return "\(startDateString) - \(endDateString)"
    }
}


