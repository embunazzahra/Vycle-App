//
//  TambahServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

import SwiftUI
import AVFoundation
import PhotosUI

struct TambahServisView: View {
    
    // For vehicle mileage
    @State private var odometerValue: String = "" // track user input in textfield
    @State private var userOdometer: Int = 78250
    
    // For date selection
    @State private var showDatePicker = false
    @State private var selectedDate = Date() // Default selected part
    
    // For spareparts selection
    @State private var selectedParts: Set<SukuCadang> = [] // Track selected parts
    
    // For the camera and image picker
    @State private var isShowingCamera = false
    @State private var selectedImage: UIImage?
    @State private var isShowingPermissionAlert = false // show alert if user had denied permission
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var isShowingDialog: Bool = false
    
    
    init() {
        setupNavigationBar()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ServiceDateView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
                OdometerInputView(odometerValue: $odometerValue, userOdometer: userOdometer)
                ChooseSparepartView(selectedParts: $selectedParts)
                PhotoInputView(isShowingDialog: $isShowingDialog, showCamera: $showCamera, showGallery: $showGallery, selectedImage: $selectedImage)
            }
            .padding(.horizontal,16)
            .padding(.top,8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .safeAreaInset(edge: .bottom, content: {
            saveButton()
        })
        .navigationTitle("Tambahkan servis")
        .navigationBarBackButtonHidden(false)
    }
       
    func saveButton() -> some View {
        CustomButton(title: "Simpan Catatan", iconName: "save_icon", iconPosition: .left, buttonType: selectedParts.isEmpty ? .disabled : .primary, horizontalPadding: 0, action: {} )
            .frame(maxWidth: .infinity)
            .background(Color.neutral.tint300)
    }
}

#Preview {
    TambahServisView()
}
