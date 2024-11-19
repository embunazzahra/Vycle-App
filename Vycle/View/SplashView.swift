//
//  SplashView.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 18/10/24.
//

import SwiftUI
import Lottie

struct SplashView: View {
    @Binding var isShowSplash: Bool
    
    var body: some View {
        ZStack {
            Color.backgroundColor
            LottieView(animation: .named("Splash-Screen.json"))
                .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                .animationDidFinish { completed in
                    isShowSplash = false
                }
                .ignoresSafeArea()
        }
    }
}
