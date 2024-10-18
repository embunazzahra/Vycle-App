//
//  TambahServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

import SwiftUI

struct AddServiceView: View {
    @EnvironmentObject var routes: Routes
    
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
    
    var service: UserServiceHistory?
    
    // Computed property to determine if the button should be disabled
    private var isButtonDisabled: Bool {
        selectedParts.isEmpty || odometerValue.isEmpty // Disable if parts are empty or TextField is empty
    }
    
    
    init(service: UserServiceHistory?) {
        self.service = service
        print(service) // Debugging line
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ServiceDateView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
                OdometerInputView(odometerValue: $odometerValue, userOdometer: userOdometer)
                ChooseSparepartView(selectedParts: $selectedParts)
                if selectedImage != nil {
                    ImagePreviewView(selectedImage: $selectedImage)
                } else {
                    PhotoInputView(isShowingDialog: $isShowingDialog, showCamera: $showCamera, showGallery: $showGallery, selectedImage: $selectedImage)
                }
            }
            .padding(.horizontal,16)
            .padding(.vertical,24)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .safeAreaInset(edge: .bottom, content: {
            saveButton()
        })
        .navigationTitle(service == nil ? "Tambahkan servis" : "Edit catatan servis")
        .navigationBarBackButtonHidden(false)
        .onAppear {
            if let service = service {
                self.odometerValue = "\(service.mileage)"
                self.userOdometer = service.mileage
                self.selectedDate = AddServiceView.date(from: service.date) // Adjust the date conversion
                self.selectedParts = Set(service.spareparts)
            }
        }
    }
    
    func saveButton() -> some View {
        CustomButton(title: service == nil ? "Simpan catatan" : "Simpan perubahan", iconName: "save_icon", iconPosition: .left, buttonType: isButtonDisabled ? .disabled : .primary, horizontalPadding: 0) {
            routes.navigateToRoot()
        }
        .frame(maxWidth: .infinity)
        .background(Color.neutral.tint300)
    }
    
    // Helper function to convert String to Date
    private static func date(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        if let date = formatter.date(from: string) {
            return date
        }
        return Date() // Return current date if conversion fails
    }
}

#Preview {
    AddServiceView(service: nil)
}
