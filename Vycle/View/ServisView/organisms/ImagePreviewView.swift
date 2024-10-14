//
//  ImagePreviewView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 11/10/24.
//

import SwiftUI

struct ImagePreviewView: View {
    @Binding var selectedImage: UIImage?
    
    var body: some View {
        if let selectedImage = selectedImage {
            VStack {
                ZStack {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity, maxHeight: 120)
                        .clipped()
                        .contentShape(Rectangle())
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay( // Add the border
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.grayShade300, lineWidth: 0.5)
                                .fill(Color.black.opacity(0.5))
                        )
                    
                    // Checkmark icon in the center
                    Image("white_square_checklist")
                        .resizable()
                        .frame(width: 41, height: 41)
                        .foregroundColor(Color.black)
                    
                    // Cancel button at top-right corner
                    Button(action: {
                        self.selectedImage = nil // Clear the image when cancel is pressed
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24) // Set button size
                            .foregroundColor(Color.neutral.tone100)
                            .background(Color.white.clipShape(Circle()))
                    }
                    .padding(.top,-4)
                    .padding(.trailing,-4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                }
                Text("Gambarmu berhasil dimasukkan!")
                    .font(.footnote)
                    .foregroundStyle(.grayTone100)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        
    }
}

//#Preview {
//    ImagePreviewView(selectedImage: <#Binding<UIImage?>#>)
//}
