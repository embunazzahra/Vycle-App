//
//  KeyboardResponder.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 16/10/24.
//

import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible = false
    @Published var keyboardHeight: CGFloat = 0.0
    private var cancellable: AnyCancellable?
    
    init() {
        cancellable = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { [weak self] notification in
                if notification.name == UIResponder.keyboardWillShowNotification {
                    self?.isKeyboardVisible = true
                    if let userInfo = notification.userInfo,
                       let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                        self?.keyboardHeight = frame.cgRectValue.height
                    }
                } else {
                    self?.isKeyboardVisible = false
                    self?.keyboardHeight = 0
                }
            }
    }
}
