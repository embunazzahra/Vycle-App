//
//  TitleWithBackgroundView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import UIKit

struct TitleWithBackgroundView: View {
    init() {
      let coloredAppearance = UINavigationBarAppearance()
      coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .blueLoyaltyTone100
      coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
      coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
      
      UINavigationBar.appearance().standardAppearance = coloredAppearance
      UINavigationBar.appearance().compactAppearance = coloredAppearance
      UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
      
      UINavigationBar.appearance().tintColor = .white
    }
    
    
    var body: some View {
        NavigationView {
            Text("Navigation Bar with different color")
              .navigationTitle("Servis")
          }
        .navigationBarTitleDisplayMode(.large)
    }
}

#Preview {
    TitleWithBackgroundView()
}
