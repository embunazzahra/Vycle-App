//
//  SplashView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 18/10/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
            Image("logo")
        }
    }
}

#Preview {
    SplashView()
}
