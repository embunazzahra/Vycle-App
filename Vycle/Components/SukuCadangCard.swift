//
//  SukuCadangCard.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

import SwiftUI

struct SukuCadangCard: View {
    var title: String
    
    var body: some View {
        HStack {
            Image(systemName: "minus.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 23, height: 23)
                .foregroundStyle(.persianRed500)
            Text(title)
                .font(.subheadline)
        }
    }
}

#Preview {
    SukuCadangCard(title: "Pilih suku cadang")
}
