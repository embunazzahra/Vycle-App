//
//  DashboardView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var routes: Routes
    @State var number: Int = 0
    var body: some View {
        VStack {
            Text("Angka Hokimu: \(number)")
//            CustomButton(title: "Tambah"){
//                number += 1
//            }
//            CustomButton(title: "Pergi", routes: routes, destination: .PengingatView)
//            CustomButton(title: "Tambah & Pergi", routes: routes, destination: .PengingatView) {
//                number += 10
//            }
        }
    }
}

#Preview {
    DashboardView()
}
