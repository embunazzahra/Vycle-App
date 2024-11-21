//
//  Views.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

import SwiftUI
import UIKit

extension View {
    func setupNavigationBar() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .blueLoyaltyTone100
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        
        UINavigationBar.appearance().tintColor = .white
        
        UINavigationBar.appearance().barTintColor = UIColor(.white)
    }
    
    func setupNavigationBarWithoutScroll() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithOpaqueBackground()
        coloredAppearance.backgroundColor = .blueLoyaltyTone100
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        coloredAppearance.shadowColor = nil
        
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance

        UINavigationBar.appearance().tintColor = .white
    }

}

extension View {
    func formatAndValidate<T: Numeric, F: ParseableFormatStyle>(
        _ numberStore: NumberStore<T, F>,
        errorCondition: @escaping (T) -> Bool
    ) -> some View {
        onChange(of: numberStore.text) { text in
            numberStore.error = false
            if let value = numberStore.getValue(), !errorCondition(value) {
                numberStore.error = false
            } else if text.isEmpty || text == numberStore.minusCharacter {
                numberStore.error = false
            } else {
                numberStore.error = true
            }
        }
        .foregroundColor(numberStore.error ? .red : .black)
        .disableAutocorrection(true)
        .autocapitalization(.none)
        .onSubmit {
            if numberStore.text.count > 1 && numberStore.text.suffix(1) == numberStore.decimalSeparator {
                numberStore.text.removeLast()
            }
        }
    }
}
