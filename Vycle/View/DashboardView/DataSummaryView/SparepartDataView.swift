//
//  SparepartDataView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 15/11/24.
//


import SwiftUI
import SwiftData

struct SparepartDataView: View {
    var uniqueSpareParts: Set<SparepartCount>
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.primary.shade300)
                .frame(maxWidth: .infinity, maxHeight: 321)
            VStack(alignment: .leading) {
                Text("Komponen yang telah diganti")
                    .foregroundStyle(Color.neutral.tint300)
                    .font(.footnote)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    // Loop through all Sparepart cases
                    ForEach(Sparepart.allCases, id: \.self) { sparepart in
                        // Get the count of the spare part from uniqueSpareParts, defaulting to 0 if not found
                        let count = uniqueSpareParts
                            .compactMap { sparepartCount -> Int? in
                                // Match the .part case and check for the corresponding sparepart
                                if case let .part(sp, c) = sparepartCount, sp == sparepart {
                                    return c
                                }
                                return nil
                            }
                            .first ?? 0 // Default to 0 if no match is found
                        
                        SparepartDataCard(sparepart: sparepart, count: count)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}