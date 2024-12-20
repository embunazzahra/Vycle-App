//
//  TambahServisView.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 09/10/24.
//

import SwiftUI
import SwiftData

struct AddServiceView: View {
    @EnvironmentObject var routes: Routes
    @EnvironmentObject var popUpHelper: PopUpHelper
    
    // For vehicle mileage
    @State private var odometerValue: String = "" // track user input in textfield
    @State private var userOdometer: Int = 0
    
    // For date selection
    @State private var showDatePicker = false
    @State private var selectedDate = Date() // Default selected part
    
    // For spareparts selection
    @State private var selectedParts: Set<Sparepart> = [] // Track selected parts
    
    // For the camera and image picker
    @State private var isShowingCamera = false
    @State private var selectedImage: UIImage?
    @State private var isShowingPermissionAlert = false // show alert if user had denied permission
    @State private var showCamera = false
    @State private var showGallery = false
    @State private var isShowingDialog: Bool = false
    
    @State private var priceValue: String = ""
    
    @AppStorage("hasNewNotification") var hasNewNotification: Bool = false
    
    @FocusState private var focusedField: Bool
    
    var service: Servis?
    
    // Computed property to determine if the button should be disabled
    private var isButtonDisabled: Bool {
        selectedParts.isEmpty || odometerValue.isEmpty || priceValue.isEmpty || Int(odometerValue) ?? 0 > userOdometer
    }
    
    enum Field {
        case odometer
        case price
    }
    
    
    init(service: Servis?) {
        self.service = service
        print(service) // Debugging line
    }
    
    
    var body: some View {
        ScrollView (showsIndicators: false){
            VStack(alignment: .leading, spacing: 20) {
                ServiceDateView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
                OdometerInputView(odometerValue: $odometerValue, userOdometer: userOdometer)
                    .focused($focusedField)
                ChooseSparepartView(selectedParts: $selectedParts)
                PriceInputView(value: $priceValue)
                    .focused($focusedField)
                addPhotoView()
                    
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    focusedField = false // Dismiss the keyboard when 'Done' is tapped
                }
                .foregroundStyle(Color.primary.base) // Customizes the button color
            }
        }
        .onTapGesture {
            focusedField = false //dismiss
        }
        .onAppear {
            let odometers = SwiftDataService.shared.fetchOdometers()
            
            if let latestOdometer = odometers.last {
                self.userOdometer = Int(latestOdometer.currentKM)
            }
            
            // initiate edit service view
            if let service = service {
                self.odometerValue = "\(Int(service.odometer ?? 0))"
                self.selectedDate =  service.date
                self.selectedParts = Set(service.servicedSparepart)
                self.priceValue = "\(Int(service.totalPrice ?? 0))"
                
                if let photoData = service.photo, selectedImage == nil {
                    self.selectedImage = UIImage(data: photoData)
                }
            } else {
                let locationHistory = SwiftDataService.shared.fetchLocationHistory()
                
                // if location is exist, the users is using IOT, so odometer value is not empty
                if let latestLocation = locationHistory.last {
                    if let latestOdometer = odometers.last {
                        odometerValue = "\(Int(latestOdometer.currentKM))"
                    }
                }
                
            }
        }
    }
    
    func saveButton() -> some View {
        CustomButton(title: service == nil ? "Simpan catatan" : "Simpan perubahan", iconName: "save_icon", iconPosition: .left, buttonType: isButtonDisabled ? .disabled : .primary, horizontalPadding: 0) {
            if service == nil {
                saveNewService()
                
                popUpHelper.popUpType = .addServiceSuccess
                popUpHelper.popUpAction = {
                    routes.navigateToRoot()
                }
                
            } else {
                updateService()
                
                popUpHelper.popUpType = .updateServiceSuccess
                popUpHelper.popUpAction = {
                    routes.navigateToRoot()
                }
            }
            hasNewNotification = true
            popUpHelper.showPopUp = true
            focusedField = false
        }
        .frame(maxWidth: .infinity)
        .background(Color.neutral.tint300)
    }
    
    func addPhotoView() -> some View {
        VStack(alignment: .leading) {
            Text("Bukti Pembayaran")
                .font(.headline)
            Text("Opsional")
                .font(.footnote)
            if let selectedImage = selectedImage {
                ImagePreviewView(selectedImage: $selectedImage)
                    .onTapGesture {
                        if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
                            routes.navigate(to: .PhotoReviewView(imageData: imageData))
                        } else {
                            print("Failed to convert UIImage to Data")
                        }
                    }
            } else {
                PhotoInputView(isShowingDialog: $isShowingDialog, showCamera: $showCamera, showGallery: $showGallery, selectedImage: $selectedImage)
            }
        }
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
    
    // MARK: SwiftData Service
    
    // Function to save a new service to the database
    private func saveNewService() {
        let vehicle = SwiftDataService.shared.getCurrentVehicle()
        
        
        if let latestVehicle = vehicle {
            SwiftDataService.shared.saveNewService(selectedDate: selectedDate, selectedParts: selectedParts, odometerValue: Float(odometerValue) ?? 0.0, selectedImage: selectedImage?.jpegData(compressionQuality: 1.0), vehicle: latestVehicle, totalPrice: Float(priceValue) ?? 0.0)
            print("vehicle brand saved is:\(latestVehicle.brand)")
        }
        
    }
    
    // Function to update an existing service
    private func updateService() {
        guard let serviceToUpdate = service else { return }
        
        // Panggil fungsi updateService dari SwiftDataService
        SwiftDataService.shared.updateService(service: serviceToUpdate,
                                              selectedDate: selectedDate,
                                              selectedParts: selectedParts,
                                              odometerValue: Float(odometerValue) ?? 0.0,
                                              selectedImage: selectedImage?.jpegData(compressionQuality: 1.0),
                                              totalPrice: Float(priceValue) ?? 0.0)
    }
}

#Preview {
    AddServiceView(service: nil)
}
