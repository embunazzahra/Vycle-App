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
    @Environment(\.modelContext) var modelContext
    
    // For vehicle mileage
    @State private var odometerValue: String = "" // track user input in textfield
    @State private var userOdometer: Int = 78250
    
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
    
    var service: Servis?
    
    // Computed property to determine if the button should be disabled
    private var isButtonDisabled: Bool {
        selectedParts.isEmpty || odometerValue.isEmpty // Disable if parts are empty or TextField is empty
    }
    
    
    init(service: Servis?) {
        self.service = service
        print(service) // Debugging line
    }
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ServiceDateView(selectedDate: $selectedDate, showDatePicker: $showDatePicker)
                OdometerInputView(odometerValue: $odometerValue, userOdometer: userOdometer)
                ChooseSparepartView(selectedParts: $selectedParts)
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
                self.odometerValue = "\(Int(service.odometer ?? 0))"
                self.userOdometer = Int(service.odometer ?? 0)
                self.selectedDate =  service.date
                self.selectedParts = Set(service.servicedSparepart)
                
                if let photoData = service.photo, selectedImage == nil {
                    self.selectedImage = UIImage(data: photoData)
                }
            }
        }
    }
    
    func saveButton() -> some View {
        CustomButton(title: service == nil ? "Simpan catatan" : "Simpan perubahan", iconName: "save_icon", iconPosition: .left, buttonType: isButtonDisabled ? .disabled : .primary, horizontalPadding: 0) {
            if service == nil {
                saveNewService()
            } else {
                updateService()
            }
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
    
    
    // MARK: SwiftData Service
    
    // Function to save a new service to the database
    private func saveNewService() {
        let odometer = Float(odometerValue) ?? 0.0
        let newService = Servis(date: selectedDate,
                                servicedSparepart: Array(self.selectedParts),
                                photo: selectedImage?.jpegData(compressionQuality: 1.0),
                                odometer: odometer,
                                vehicle: Vehicle(vehicleType: .car, brand: .car(.honda)))
        
        modelContext.insert(newService)
        createReminder(for: newService.vehicle, with: odometer)
        do {
            try modelContext.save()
        } catch {
            print("Failed to save service: \(error)")
        }
    }
    
    // Function to update an existing service
    private func updateService() {
        guard let serviceToUpdate = service else { return }
        
        // Update properties of the existing service
        serviceToUpdate.date = selectedDate
        serviceToUpdate.odometer = Float(odometerValue) ?? 0.0
        serviceToUpdate.servicedSparepart = Array(selectedParts)
        serviceToUpdate.photo = selectedImage?.jpegData(compressionQuality: 1.0)
        
        // Save the changes in the model context
        do {
            try modelContext.save()
        } catch {
            print("Failed to update service: \(error)")
        }
    }
    
    // Function to create and insert a new Reminder for each selected spare part
    private func createReminder(for vehicle: Vehicle, with odometer: Float) {
        // Loop through each selected spare part
        for sparepart in selectedParts {
            // Get the interval for the sparepart based on the vehicle's brand
            guard let interval = vehicle.brand.intervalForSparepart(sparepart) else {
                continue
            }

            // Calculate the target odometer for the next service reminder
            let targetKM = odometer + Float(interval.kilometer)
            
            // Calculate the due date based on the interval in months
            let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: selectedDate) ?? Date()

            // Create a new reminder
            let newReminder = Reminder(
                date: selectedDate,
                sparepart: sparepart,
                targetKM: targetKM,
                kmInterval: Float(interval.kilometer),
                dueDate: dueDate,
                timeInterval: interval.month,
                vehicle: vehicle,
                isRepeat: true, // Set true if you want reminders to repeat
                isDraft: false
            )
            
            // Insert the reminder into the model context
            modelContext.insert(newReminder)
            print(newReminder)
        }

        // Save the model context after adding the reminders
        do {
            try modelContext.save()
        } catch {
            print("Failed to save reminder: \(error)")
        }
    }

}

#Preview {
    AddServiceView(service: nil)
}
