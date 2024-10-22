//
//  ServiceHistoryCard.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 14/10/24.
//

import SwiftUI

struct ServiceHistoryCard: View {
    let service: Servis // Accept service data
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
                    if let photoData = service.photo {
                        Image(uiImage: UIImage(data: photoData) ?? UIImage(contentsOfFile: "image_icon")!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipped()
                            .clipShape(RoundedCorners(radius: 8, corners: [.topLeft, .bottomLeft]))
                    } else {
                        Image("image_icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 36, height: 36)
                            .cornerRadius(8)
                    }

                }
                
                VStack(alignment: .leading) {
                    Text(generateTitle(from: service.servicedSparepart))
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Text("Diservis pada KM \(Int(service.odometer ?? 0).formattedWithSeparator())")
                        .font(.caption)
                    Spacer()
                    Text(service.date.toString(format: "dd/MM/yyyy"))
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
    
    // Helper function untuk menghasilkan title dari spareparts
    private func generateTitle(from spareparts: [Sparepart]) -> String {
        return spareparts.map { $0.rawValue.capitalized }.joined(separator: ", ")
    }
}

struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
