//
//  VehicleBrandButton.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

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
                .animation(.easeInOut(duration: 0.2), value: isSelected)

            HStack {
                Image(brand.isCustomBrand ? "Custom" : brand.stringValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(.leading, 24)
                Text(brand.stringValue)
                    .headline()
                    .foregroundStyle(isSelected ? Color.neutral.tint300 : Color.neutral.shade300)
                    .padding(.leading, 4)
                    .animation(.easeInOut(duration: 0.2), value: isSelected)
            }
        }
        .padding(.bottom, 2)
        .onTapGesture {
            onSelect()
        }
    }
}
