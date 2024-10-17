//
//  VycleApp.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import SwiftUI
import SwiftData

@main
struct VycleApp: App {
    @StateObject var routes = Routes()
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environmentObject(routes)
            OnBoardingView()
        }
    }
}
