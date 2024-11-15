//
//  ShareSummaryView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 15/11/24.
//

import SwiftUI

struct ShareSummaryView: View {
    let totalMileage: Float
    let uniqueSpareParts: Set<SparepartCount>
    let totalCost: Float
    @Environment(\.displayScale) var displayScale
    
    @State private var isLoading: Bool = false
    @State private var sheetPresented: Bool = false
    @State private var generatedImage: UIImage? = nil
    
    var body: some View {
        VStack(spacing: 16) {
//            if isLoading {
//                ProgressView("Generating Image...")
//                    .padding()
//            } else {
                TotalMileageView(totalMileage: totalMileage)
                SparepartDataView(uniqueSpareParts: uniqueSpareParts)
                TotalCostView(totalCost: totalCost)
//            }
            
            Button(action: {
                withAnimation {
                    isLoading = true
                    Task {
                        generatedImage = await renderAsImage()
                        isLoading = false
                        sheetPresented = true
                    }
                }
            }) {
                Text("Generate & Share")
                    .foregroundStyle(.black)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Bagikan Data")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $sheetPresented) {
            if let image = generatedImage {
                ShareViewController(activityItems: [image])
            }
        }
    }
}

extension ShareSummaryView {
    @MainActor
    func renderAsImage() async -> UIImage? {
        let renderer = ImageRenderer(content: self)
        renderer.scale = displayScale
        return renderer.uiImage
    }
}

//#Preview {
//    ShareSummaryView(totalMileage: 10000, uniqueSpareParts: .part, totalCost: <#Float#>)
//}

