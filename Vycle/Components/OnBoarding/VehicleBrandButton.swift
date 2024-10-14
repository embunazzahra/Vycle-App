//
//  VehicleBrandButton.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

enum VehicleBrand: Hashable {
    case honda
    case suzuki
    case toyota
    case daihatsu
    case mitsubishi
    case custom(String)
}

struct VehicleBrandButton: View {
    let brand: VehicleBrand
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(width: 361, height: 64)
                .foregroundStyle(isSelected ? Color.primary.shade200 : Color.neutral.tint200)
                .padding(.horizontal, 12)
                .animation(.easeInOut, value: isSelected)

            HStack {
                Image("placeholder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(.leading, 24)
                Text(brandText)
                    .headline()
                    .foregroundStyle(isSelected ? Color.neutral.tint300 : Color.neutral.shade300)
                    .animation(.easeInOut, value: isSelected)
                    .padding(.leading, 4)
            }
        }
        .padding(.bottom, 2)
        .onTapGesture {
            onSelect()
        }
    }
    
    private var brandImage: String {
        switch brand {
        case .honda:
            return "honda"
        case .suzuki:
            return "suzuki"
        case .toyota:
            return "toyota"
        case .daihatsu:
            return "daihatsu"
        case .mitsubishi:
            return "mitsubishi"
        case .custom(let name):
            return name
        }
    }
    
    private var brandText: String {
        switch brand {
        case .honda:
            return "Honda"
        case .suzuki:
            return "Suzuki"
        case .toyota:
            return "Toyota"
        case .daihatsu:
            return "Daihatsu"
        case .mitsubishi:
            return "Mitsubishi"
        case .custom(let name):
            return name
        }
    }
}
