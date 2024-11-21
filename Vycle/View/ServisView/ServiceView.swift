//
//  ServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import SwiftData

struct ServiceView: View {
    @EnvironmentObject var routes: Routes
    @Query var services : [Servis]
    @Binding var onBoardingDataSaved: Bool
    @Binding var isShowSplash: Bool
    
    var body: some View {
        
        if (!services.isEmpty) {
            ServiceHistoryView()
        }
        else {
            NoServiceView(onBoardingDataSaved: $onBoardingDataSaved, isShowSplash: $isShowSplash)
        }
        
    }
}



//#Preview {
//    ServiceView()
//}
