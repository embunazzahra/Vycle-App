//
//  PhotoReviewView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 20/10/24.
//

import SwiftUI

struct PhotoReviewView: View {
    @Environment(\.presentationMode) var presentationMode
    
    let imageData: Data
    
    var body: some View {
        VStack {
            if let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                Text("Invalid Image")
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) { Color.clear }
            ToolbarItem(placement: .topBarLeading) {
                Button("Tinjau Ulang") {
                    presentationMode.wrappedValue.dismiss()
                }
                .offset(x: -25)
            }
        }
    }
}

#Preview {
    // Provide dummy image data for preview purposes
    let dummyImage = UIImage(systemName: "contoh_nota")!
    PhotoReviewView(imageData: dummyImage.jpegData(compressionQuality: 1.0)!)
}
