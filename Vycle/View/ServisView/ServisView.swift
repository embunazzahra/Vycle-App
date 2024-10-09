//
//  ServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI

struct ServisView: View {
    @State var isHavingRecord: Bool = false
    
    var body: some View {
        NavigationStack {
            if (isHavingRecord) {
                HistoriServisView()
            }
            else {
                NoServiceView()
            }
        }
        .tint(.white)
    }
}


#Preview {
    ServisView()
}
