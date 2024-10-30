//
//  Untitled.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 30/10/24.
//

import SwiftUICore

extension AnyTransition {
    static var backslide: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .move(edge: .trailing),
            removal: .move(edge: .leading))}
}
