//
//  ServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI

struct ServiceView: View {
    @State var isHavingRecord: Bool = false
    @EnvironmentObject var routes: Routes
    
    var body: some View {
        
        if (isHavingRecord) {
            ServiceHistoryView()
        }
        else {
//            NoServiceView()
            ServiceHistoryView()
        }
        
    }
}


#Preview {
    ServiceView()
}
