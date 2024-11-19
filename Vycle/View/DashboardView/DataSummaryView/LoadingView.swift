//
//  LoadingView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 18/11/24.
//

import SwiftUI
import Lottie

struct LoadingView: View {
    @Binding var isShowLoading: Bool
    
    var body: some View {
        VStack {
            LottieView(animation: .named("GifCarLoad.json"))
                .playbackMode(.playing(.toProgress(1, loopMode: .playOnce)))
                .animationDidFinish { completed in
                    isShowLoading = false
                }
            VStack(spacing: 4){
                Text("Tunggu sebentar...")
                    .font(.headline)
                Text("Data spesialnya lagi disiapin ni🤤")
                    .font(.body)
                    .foregroundStyle(Color.neutral.tone200)
                
            }
        }
        
        .ignoresSafeArea()
    }
}
