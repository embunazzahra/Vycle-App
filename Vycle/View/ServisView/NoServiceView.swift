//
//  NoServiceView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import UIKit

struct NoServiceView: View {

    @EnvironmentObject var routes: Routes
    
    var body: some View {
        VStack {
            Image("service_empty_state_icon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 236, height: 200)
                .foregroundStyle(.yellow)
            Text("Kamu belum pernah mencatat servis nih 🙁").font(.headline)
                .padding(.bottom,4)
            Text("Tambahkan catatan dengan tombol di bawah ini yuk").font(.footnote)
                .padding(.bottom,12)
            
            CustomButton(title: "Mulai mencatat") {
                routes.navigate(to: .AddServiceView(service: nil))
            }
            
        }
        .padding(.bottom,60)
        .navigationTitle("Servis")
    }
}

#Preview {
    NoServiceView()
}

// Custom Button definition
struct CustomButtonAlternative: View {
    var title: String
    var symbolName: String? = nil // Optional symbol name
    var isEnabled: Bool = true
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(isEnabled ? Color.blue : Color.gray)
                .frame(width: 361, height: 60)
            
            HStack {
                if let symbol = symbolName {
                    Image(systemName: symbol)
                        .foregroundColor(.white)
                }
                Text(title)
                    .font(.body)
                    .foregroundColor(isEnabled ? Color.neutral.tint300 : Color.gray)
            }
        }
        .padding(.horizontal, 16)
    }
}
