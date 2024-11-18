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
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

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
                
                HStack {
                    CustomButton(title: "Bagikan", iconName: "share_icon_2",buttonType: .secondary, horizontalPadding: 0, verticalPadding: 0, width: 175, height: 40) {
                        sheetPresented = true
                    }
                    Spacer()
                    CustomButton(title: "Unduh Gambar", iconName: "save_icon",buttonType: .primary, horizontalPadding: 0, verticalPadding: 0, width: 175, height: 40) {
                        if let image = generatedImage {
                            saveImageToPhotosAlbum(image)
                        }
                    }
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Notifikasi"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    private func saveImageToPhotosAlbum(_ image: UIImage) {
        let imageService = ImageService()
        imageService.addToPhotos(image: image) { error in
            if let error = error {
                alertMessage = "Error: \(error.localizedDescription)"
            } else {
                alertMessage = "Gambar berhasil disimpan"
            }
            showAlert = true
        }
    }
}



extension ShareSummaryView {
    @MainActor
    func renderAsImage() async -> UIImage? {
        let renderer = ImageRenderer(content: ShareContentView(totalMileage: totalMileage, uniqueSpareParts: uniqueSpareParts, totalCost: totalCost))
        renderer.scale = displayScale * 2
        return renderer.uiImage
    }
}

import UIKit

struct ImageService {
    final class Delegate: NSObject {
        let completion: (Error?) -> Void

        init(completion: @escaping (Error?) -> Void) {
            self.completion = completion
        }

        @objc func savedImage(
            _ im: UIImage,
            error: Error?,
            context: UnsafeMutableRawPointer?
        ) {
            DispatchQueue.main.async {
                self.completion(error)
            }
        }
    }

    func addToPhotos(image: UIImage, completion: @escaping (Error?) -> Void) {
        let delegate = Delegate(completion: completion)
        UIImageWriteToSavedPhotosAlbum(
            image,
            delegate,
            #selector(Delegate.savedImage(_:error:context:)),
            nil
        )
    }
}

//#Preview {
//    ShareSummaryView(totalMileage: 10000, uniqueSpareParts: .part, totalCost: <#Float#>)
//}

