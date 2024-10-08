//
//  Colors.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 04/10/24.
//

import SwiftUI

extension Color {
    static let primary = Primary()
    static let neutral = Neutral()
    static let persianRed = PersianRed()
    static let lima = Lima()
    static let amber = Amber()
    static let gradient = LinearCard()
    static let backgroundColor = Color("Background")
    static let tabBar = Color("StrokeTabBar")
}

struct Primary {
    let shade100 = Color("BlueLoyaltyShade100")
    let shade200 = Color("BlueLoyaltyShade200")
    let shade300 = Color("BlueLoyaltyShade300")
    let tint100 = Color("BlueLoyaltyTint100")
    let tint200 = Color("BlueLoyaltyTint200")
    let tint300 = Color("BlueLoyaltyTint300")
    let tone100 = Color("BlueLoyaltyTone100")
    let tone200 = Color("BlueLoyaltyTone200")
    let tone300 = Color("BlueLoyaltyTone300")
}

struct Neutral {
    let base = Color("GrayBase")
    let shade100 = Color("GrayShade100")
    let shade200 = Color("GrayShade200")
    let shade300 = Color("GrayShade300")
    let tint100 = Color("GrayTint100")
    let tint200 = Color("GrayTint200")
    let tint300 = Color("GrayTint300")
    let tone100 = Color("GrayTone100")
    let tone200 = Color("GrayTone200")
    let tone300 = Color("GrayTone300")
}

struct PersianRed {
    let red100 = Color("PersianRed100")
    let red200 = Color("PersianRed200")
    let red300 = Color("PersianRed300")
    let red400 = Color("PersianRed400")
    let red500 = Color("PersianRed500")
    let red600 = Color("PersianRed600")
    let red700 = Color("PersianRed700")
    let red800 = Color("PersianRed800")
    let red900 = Color("PersianRed900")
}

struct Lima {
    let lima100 = Color("Lima100")
    let lima200 = Color("Lima200")
    let lima300 = Color("Lima300")
    let lima400 = Color("Lima400")
    let lima500 = Color("Lima500")
    let lima600 = Color("Lima600")
    let lima700 = Color("Lima700")
    let lima800 = Color("Lima800")
    let lima900 = Color("Lima900")
}

struct Amber {
    let amber100 = Color("Amber100")
    let amber200 = Color("Amber200")
    let amber300 = Color("Amber300")
    let amber400 = Color("Amber400")
    let amber500 = Color("Amber500")
    let amber600 = Color("Amber600")
    let amber700 = Color("Amber700")
    let amber800 = Color("Amber800")
    let amber900 = Color("Amber900")
}

struct LinearCard {
    let gradient0 = Color("Gradient 0")
    let gradient50 = Color("Gradient 50")
    let gradient100 = Color("Gradient 100")
}
