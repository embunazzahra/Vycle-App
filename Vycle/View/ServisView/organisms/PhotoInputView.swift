//
//  PhotoInputView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 11/10/24.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct PhotoInputView: View {
    @Binding var isShowingDialog: Bool
    @Binding var showCamera: Bool
    @Binding var showGallery: Bool
    @Binding var selectedImage: UIImage?

    var body: some View {
        HStack {
            Image("photo_logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 21, height: 21)
            Text("Masukkan foto bukti pembayaran")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    style: StrokeStyle(lineWidth: 1, dash: [4])
                )
                .foregroundColor(.grayTone300)
        )
        .foregroundColor(.grayTone200)
        .onTapGesture {
            isShowingDialog = true
        }
        .confirmationDialog("", isPresented: $isShowingDialog, titleVisibility: .hidden) {
            Button("Kamera") {
                checkCameraPermission()
            }
            Button("Galeri") {
                checkGalleryPermission()
            }
            Button("Cancel", role: .cancel) {}
        }
        .sheet(isPresented: $showCamera) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
        }
        .sheet(isPresented: $showGallery) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
    }

    func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            showCamera = true
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        showCamera = true
                    }
                }
            }
        default:
            print("Camera access denied or restricted")
        }
    }

    func checkGalleryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized, .limited:
            showGallery = true
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    DispatchQueue.main.async {
                        showGallery = true
                    }
                }
            }
        default:
            print("Gallery access denied or restricted")
        }
    }
}
