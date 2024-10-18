//
//  ServiceHistoryCard.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//

import SwiftUI

struct ServiceHistoryCard: View {
    let service: UserServiceHistory // Accept service data
    var onCardTap: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .compositingGroup()
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 2, y: 2)

            HStack {
                ZStack {
                    Color.neutral.shade100
                        .frame(width: 100)
                    Image("image_icon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 36, height: 36)
                        .cornerRadius(8)
                }

                VStack(alignment: .leading) {
                    Text(service.title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("Diservis pada KM \(service.mileage.formattedWithSeparator())")
                        .font(.caption)
                    Spacer()
                    Text(service.date)
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.neutral.tone300)
                }
                .padding()
                Spacer()
            }
            .cornerRadius(12)
            .frame(height: 100)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 2)
        .padding(.vertical, 4)
        .onTapGesture {
            onCardTap() // Call the closure when the card is tapped
        }
    }
}
