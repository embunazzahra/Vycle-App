//
//  PopUpHelper.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 13/11/24.
//
import SwiftUI

class PopUpHelper: ObservableObject {
    @Published var showPopUp: Bool = false
    @Published var popUpType: PopUpType = .addServiceSuccess
    var popUpAction: (() -> Void)? = nil
}
