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
        NavigationView {
            VStack{
                HStack{
                    Image("bt")
                    Text("IoT Tersambung")
                        .padding()
                        .background(Color.background)
                        .foregroundColor(Color.lima500)
                        .cornerRadius(8)
                }
                  
//                    .navigationTitle("Dashboard")
            }
        }.ignoresSafeArea()
    }
}



#Preview {
    DashboardView()
}
