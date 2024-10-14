//
//  VehicleButton.swift
//  Vycle
//
//  Created by Brendan Alexander Soendjojo on 13/10/24.
//
import SwiftUI

enum VehicleType {
    case motor
    case mobil
}

struct VehicleTypeButton: View {
    let vehicleType: VehicleType
    let isSelected: Bool
    let height: CGFloat
    let onSelect: () -> Void

    var body: some View {
        ZStack(alignment: .leading) {
            Rectangle()
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(width: 361, height: 118)
                .foregroundStyle(isSelected ? Color.primary.shade200 : Color.neutral.tint200)
                .padding(.horizontal, 16)
                .animation(.easeInOut, value: isSelected)
            
            Image(vehicleType == .motor ? "motor" : "mobil")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: height)
                .scaleEffect(isSelected ? 1.4 : 1)
                .padding(.leading, vehicleType == .motor ? 56 : 36)
                .animation(.easeInOut(duration: 0.3), value: isSelected)
            
            Text(vehicleType == .motor ? "Motor" : "Mobil")
                .font(.headline)
                .foregroundStyle(isSelected ? Color.neutral.tint300 : Color.neutral.shade300)
                .padding(.leading, 250)
                .animation(.easeInOut, value: isSelected)
        }
        .padding(.bottom, 6)
        .onTapGesture {
            onSelect()
        }
    }
}
