//
//  ProgressBar.swift
//  Vycle
//
//  Created by Clarissa Alverina on 10/10/24.
//

import SwiftUI

struct ProgressBar: View {
    var currentKilometer: Double
    var maxKilometer: Double
    var serviceOdometer: Double

    private var kilometerDifference: Double {
        return maxKilometer - currentKilometer
    }
    
    private var progress: Double {
        return min(currentKilometer / maxKilometer, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if progress >= 1.0 {
                Text("Sudah tiba bulannya nih!")
                    .footnote(.emphasized)
                    .foregroundColor(Color.persianRed600)
            } else if progress > 0.7 {
                Text("\(Int(kilometerDifference)) Kilometer lagi")
                    .footnote(.emphasized)
                    .foregroundColor(Color.persianRed600)
            }  else if progress > 0.3 && progress < 0.7 {
                Text("\(Int(kilometerDifference)) Kilometer lagi")
                    .footnote(.emphasized)
                    .foregroundColor(Color.amber600)
            } else if progress <= 0 {
                Text("Belum ada data kilometer")
                    .footnote(.emphasized)
                    .foregroundColor(Color.neutral.tone200)
            } else {
                Text("\(Int(kilometerDifference)) Kilometer lagi")
                    .footnote(.emphasized)
                    .foregroundColor(Color.lima600)
            }
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: 265, height: 8)
                    .cornerRadius(4)
                    .foregroundColor(Color.gray.opacity(0.3))
                
                Rectangle()
                    .frame(width: CGFloat(progress) * 265, height: 8)
                    .cornerRadius(4)
                    .foregroundColor(
                        progress > 0.7 ? .persianRed600 :
                        (progress > 0.3 && progress < 0.7 ? .amber600 : .lima600)
                    )
                    .animation(.linear, value: progress)
            }
        }
    }
}

#Preview {
    ProgressBar(currentKilometer: 0, maxKilometer: 15, serviceOdometer: 0)
    
    ProgressBar(currentKilometer: 10, maxKilometer: 50, serviceOdometer: 5)
    
    ProgressBar(currentKilometer: 50, maxKilometer: 100, serviceOdometer: 10)
    
    ProgressBar(currentKilometer: 200, maxKilometer: 200, serviceOdometer: 5)
}

//import SwiftUI
//
//struct ProgressBar: View {
//    var currentKilometer: Double
//    var maxKilometer: Double
//    var serviceOdometer: Double
//
//    private var kilometerDifference: Double {
//        return maxKilometer - (currentKilometer - serviceOdometer)
//    }
//    
//    private var progress: Double {
//        return min((currentKilometer - serviceOdometer) / maxKilometer, 1.0)
//    }
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            if progress >= 1.0 {
//                Text("Sudah tiba bulannya nih!")
//                    .footnote(.emphasized)
//                    .foregroundColor(Color.persianRed600)
//            } else if progress >= 0.66 {
//                Text("\(Int(kilometerDifference)) Kilometer lagi")
//                    .footnote(.emphasized)
//                    .foregroundColor(Color.persianRed600)
//            } else if progress <= 0 {
//                Text("Belum ada data kilometer")
//                    .footnote(.emphasized)
//                    .foregroundColor(Color.neutral.tone200)
//            } else {
//                Text("\(Int(kilometerDifference)) Kilometer lagi")
//                    .footnote(.emphasized)
//                    .foregroundColor(Color.lima600)
//            }
//            
//            ZStack(alignment: .leading) {
//                Rectangle()
//                    .frame(width: 265, height: 8)
//                    .cornerRadius(4)
//                    .foregroundColor(Color.gray.opacity(0.3))
//                
//                Rectangle()
//                    .frame(width: CGFloat(progress) * 265, height: 8)
//                    .cornerRadius(4)
//                    .foregroundColor(progress >= 0.66 ? .persianRed600 : .lima600)
//                    .animation(.linear, value: progress)
//            }
//        }
//    }
//}
//
//#Preview {
//    ProgressBar(currentKilometer: 0, maxKilometer: 15000, serviceOdometer: 0)
//    
//    ProgressBar(currentKilometer: 2000, maxKilometer: 10000, serviceOdometer: 1000)
//    
//    ProgressBar(currentKilometer: 10000, maxKilometer: 10000, serviceOdometer: 1000)
//}
