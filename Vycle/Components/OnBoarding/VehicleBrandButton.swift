//
//  VehicleBrandButton.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//

import SwiftUI

struct VehicleBrandButton: View {
    let brand: VehicleBrand
    let year: Int?
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .foregroundStyle(isSelected ? Color.primary.shade200 : Color.neutral.tint100)
                .opacity(isSelected ? 1 : 0.5)
                .padding(.horizontal, 16)
                .animation(.easeInOut(duration: 0.2), value: isSelected)

            HStack {
                Image(brand.isCustomBrand ? "Custom" : brand.stringValue)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(.leading, 28)
                
                Text(brand.stringValue)
                    .headline()
                    .foregroundStyle(isSelected ? Color.neutral.tint300 : Color.neutral.shade300)
                    .padding(.leading, 8)
                
                Spacer()
                
                if isSelected {
                    if let year = year {
                        Text(String(year))
                            .body(.regular)
                            .foregroundStyle(Color.neutral.tint300)
                            .padding(.trailing, 36)
                    }
                }
            }
        }
        .padding(.bottom, 2)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .onTapGesture {
            onSelect()
        }
    }
}
