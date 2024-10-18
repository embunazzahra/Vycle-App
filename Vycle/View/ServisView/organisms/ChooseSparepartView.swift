//
//  ChooseSparepartView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 11/10/24.
//

import SwiftUI

struct ChooseSparepartView: View {
    @Binding var selectedParts: Set<Sparepart>

    var body: some View {
        VStack(alignment: .leading) {
            Text("Suku cadang")
                .font(.headline)
            Text("Dapat memilih lebih dari satu suku cadang")
                .font(.footnote)

            WrappingHStack(models: Sparepart.allCases, viewGenerator: { part in
                Button(action: {
                    // Toggle selection
                    if selectedParts.contains(part) {
                        selectedParts.remove(part)
                    } else {
                        selectedParts.insert(part)
                    }
                }) {
                    HStack(spacing: 0) {
                        Text(part.rawValue)
                            .padding(.vertical, 12)
                            .foregroundStyle(selectedParts.contains(part) ? .white : Color.primary.shade300)

                        if selectedParts.contains(part) {
                            Image(systemName: "minus.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 17)
                                .foregroundStyle(.white)
                                .padding(.leading, 4)
                        }
                    }
                    .padding(.horizontal, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(selectedParts.contains(part) ? Color.primary.shade200 : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.primary.shade200, lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(PlainButtonStyle())
            }, horizontalSpacing: 4, verticalSpacing: 4)
        }
    }
}
