//
//  BTIndicator.swift
//  Vycle
//
//  Created by Vincent Senjaya on 11/10/24.
//

import SwiftUI

struct BTIndicator: View {
    @ObservedObject var locationManager: LocationManager  // Observe locationManager for region status

    var body: some View {
        HStack{
            Image(locationManager.isInsideBeaconRegion ? "bt" : "bt_red").frame(height: 18)
            Text(locationManager.isInsideBeaconRegion ? "IoT Tersambung" : "IoT Terputus").foregroundStyle(locationManager.isInsideBeaconRegion ? .lima500 : .persianRed600)
                .frame(height: 18)
            
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(Color.background)
        .cornerRadius(12)
        .frame(height: 32)
        
    }
}



#Preview {
    BTIndicator(locationManager: LocationManager())
}
