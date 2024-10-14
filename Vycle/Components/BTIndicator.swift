//
//  BTIndicator.swift
//  Vycle
//
//  Created by Vincent Senjaya on 11/10/24.
//

import SwiftUI

struct BTIndicator: View {
    var body: some View {
        HStack{
            Image("bt")
            Text("IoT Tersambung")
        }
        .padding()
        .background(Color.blue)
        .foregroundColor(Color.lima500)
        .cornerRadius(8)
        .frame(height: 100)
    }
}


#Preview {
    BTIndicator()
}
