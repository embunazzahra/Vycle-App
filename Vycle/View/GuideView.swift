//
//  GuideView.swift
//  Vycle
//
//  Created by Vincent Senjaya on 12/11/24.
//
import SwiftUI
import SwiftData

struct GuideView: View {
    @Query(sort: \LocationHistory.time, order: .reverse) var locationHistory: [LocationHistory]
    @Query(sort: \Odometer.date, order: .forward) var initialOdometer: [Odometer]
    
    var body: some View {
        let roundedOdometer = getRoundedOdometer()
        
        VStack(alignment: .leading) {
            Text("Servis \(roundedOdometer) Kilometer")
                .title3(.emphasized)
//                .foregroundColor(.gray)
            
            if let currentVehicle = SwiftDataService.shared.getCurrentVehicle(),
               let carBrand = Car(rawValue: currentVehicle.brand.stringValue) {
                HStack{
                    Image(systemName: "info.circle").foregroundColor(Color.neutral.tone200)
                    Text("Berdasarkan buku manual merk kendaraanmu")
                        .subhead(.regular)
                        .foregroundColor(Color.neutral.tone200)
//                        .foregroundColor(Color.neutral.shade300)
                        
                }.padding(.bottom, 16)
                
                ForEach(Sparepart.allCases, id: \.self) { sparepart in
                    if let interval = carBrand.intervalForSparepart(sparepart),
                       roundedOdometer % interval.kilometer == 0 {
                        Text("\(sparepart.rawValue)").body(.regular).foregroundColor(Color.neutral.shade300).padding(.horizontal)
                        Divider()
                    }
                }
            } else {
                Text("Vehicle brand not recognized.")
                    .font(.headline)
                    .padding()
            }
            Spacer()
        }
        .navigationTitle("Servis Berkala").navigationBarTitleDisplayMode(.inline)
        .padding()
    }
    
    private func getRoundedOdometer() -> Int {
        let totalDistance = calculateTotalDistance() ?? 0
        return roundUpToNextTenThousand(totalDistance)
    }
    
    func calculateTotalDistance() -> Double? {
        let initialOdoValue = initialOdometer.last?.currentKM ?? 0
        if let firstLocation = locationHistory.first {
            let totalDistance = Double(initialOdoValue) + (firstLocation.distance ?? 0)
            return totalDistance
        } else {
            return Double(initialOdoValue)
        }
    }
    
    func roundUpToNextTenThousand(_ value: Double) -> Int {
        let interval = 10000
        return ((Int(value) + interval - 1) / interval) * interval
    }
}

#Preview {
    GuideView()
}
