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
    
    @State private var isLoading: Bool = true
    @State private var generatedImage: UIImage? = nil
    @State private var sheetPresented: Bool = false

    var body: some View {
        VStack(spacing: 16) {
            if isLoading {
                ProgressView("Generating Image...")
                    .padding()
            } else if let image = generatedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()

                Button(action: {
                    sheetPresented = true
                }) {
                    Text("Share")
                        .padding()
                        .foregroundStyle(.black)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .navigationTitle("Bagikan Data")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            Task {
                generatedImage = await renderAsImage()
                isLoading = false
            }
        }
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
        let renderer = ImageRenderer(content: ShareContentView(totalMileage: totalMileage, uniqueSpareParts: uniqueSpareParts, totalCost: totalCost))
        renderer.scale = displayScale
        return renderer.uiImage
    }
}

//#Preview {
//    ShareSummaryView(totalMileage: 10000, uniqueSpareParts: .part, totalCost: <#Float#>)
//}

