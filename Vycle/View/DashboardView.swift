//
//  DashboardView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var routes: Routes
    var body: some View {
//        Button(action: {
//            routes.navigate(to: .PengingatView)
//        }) {
//            Image(systemName: "doc.text")
//                .foregroundStyle(Color.black)
//        }
        CustomButton(title: "test", destination: .PengingatView)
    }
}

#Preview {
    DashboardView()
}
