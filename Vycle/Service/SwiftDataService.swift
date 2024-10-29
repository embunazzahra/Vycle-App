//
//  SwiftDataService.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import Foundation
import SwiftData

class SwiftDataService {
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    @MainActor
    static let shared = SwiftDataService()
    
    
    @MainActor
    private init() {
        // Change isStoredInMemoryOnly to false if you would like to see the data persistance after kill/exit the app
        self.modelContainer = try! ModelContainer(for: Odometer.self, Vehicle.self, Servis.self, Trip.self, Reminder.self, LocationHistory.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        
        self.modelContext = modelContainer.mainContext
    }
    func saveModelContext(){
        do {
            try modelContext.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    //testing
}

extension SwiftDataService {
    func insertTrip(){
        let testTrip = Trip(tripID: 1, isFinished: false, locationHistories: [], vehicle: Vehicle(vehicleType: .car, brand: .car(.toyota)))
        modelContext.insert(testTrip)
        
        do {
            try saveModelContext() // Save the context to persist the new trip
        } catch {
            print("Failed to save trip: \(error.localizedDescription)")
        }
    }
    

    
    func insertLocationHistory(distance: Double?, latitude: Double, longitude: Double, time: Date){
        let testTrip = Trip(tripID: 1, isFinished: false, locationHistories: [], vehicle: Vehicle(vehicleType: .car, brand: .car(.toyota)))
        let locationHistory = LocationHistory(distance: distance, latitude: latitude, longitude: longitude, time: time, trip: testTrip)
        modelContext.insert(locationHistory)
        
            do {
                try saveModelContext() // Save the context to persist the new trip
            } catch {
                print("Failed to save trip: \(error.localizedDescription)")
            }
    }
}

// MARK: OnBoarding

extension SwiftDataService {
    func insertOnBoarding(vehicleType: VehicleType, vehicleBrand: VehicleBrand, odometer: Float, serviceHistory: [ServiceHistory]? = nil) {
        
        let vehicleData = Vehicle(vehicleType: vehicleType, brand: vehicleBrand)
        modelContext.insert(vehicleData)
        saveModelContext()
        self.setCurrentVehicle(vehicleData)
        // Insert Odometer
        let odometerData = Odometer(date: Date(), currentKM: odometer, vehicle: vehicleData)
        modelContext.insert(odometerData)
        
        
        // Check if serviceHistory is not nil and not empty
        if let serviceHistory = serviceHistory, !serviceHistory.isEmpty {
                
            let groupedServiceHistory = Dictionary(grouping: serviceHistory, by: { $0.date })
            
            for (date, historyForDate) in groupedServiceHistory {
                // Insert Service History
                let servicedSpareparts = historyForDate.compactMap { $0.sparepart }
                let serviceData = Servis(
                    date: date,
                    servicedSparepart: servicedSpareparts,
                    vehicle: self.getCurrentVehicle()!
                )
                modelContext.insert(serviceData)
                
                for sparepart in servicedSpareparts {
                    // Insert Reminder
                    guard let interval = Vehicle(vehicleType: vehicleType, brand: vehicleBrand).brand.intervalForSparepart(sparepart) else {
                        continue
                    }

//                    let targetKM = odometer + Float(interval.kilometer)
                    let reminderOdo = odometer
                    print("target km : \(reminderOdo)")
                    let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: date) ?? Date()
                    let reminderData = Reminder(
                        date: date,
                        sparepart: sparepart,
                        reminderOdo: reminderOdo,
                        kmInterval: Float(interval.kilometer),
                        dueDate: dueDate,
                        timeInterval: interval.month,
                        vehicle: self.getCurrentVehicle()!,
                        isRepeat: true, // Set true if you want reminders to repeat
                        isDraft: false
                    )
                    modelContext.insert(reminderData)
                }
            }
        }


        saveModelContext()
        printAllData()
    }
    
//    func insertOdometerData(vehicleData: Vehicle, odometer: Float){
//        let odometerData = Odometer(date: Date(), currentKM: odometer, vehicle: vehicleData)
//        modelContext.insert(odometerData)
//        saveModelContext()
//    }
}


// MARK: Debug
extension SwiftDataService {
    
    func fetchVehicles() -> [Vehicle] {
        let fetchRequest = FetchDescriptor<Vehicle>()
        let vehicles = (try? modelContext.fetch(fetchRequest)) ?? []
        return vehicles
    }
    
    func fetchOdometers() -> [Odometer] {
        let fetchRequest = FetchDescriptor<Odometer>()
        let odometers = (try? modelContext.fetch(fetchRequest)) ?? []
        return odometers
    }
    
    func fetchServices() -> [Servis] {
        let fetchRequest = FetchDescriptor<Servis>()
        let services = (try? modelContext.fetch(fetchRequest)) ?? []
        return services
    }
    
    func fetchReminders() -> [Reminder] {
        let fetchRequest = FetchDescriptor<Reminder>()
        let reminders = (try? modelContext.fetch(fetchRequest)) ?? []
        return reminders
    }
    
    func printAllData() {
        let vehicles = fetchVehicles()
        let odometers = fetchOdometers()
        let services = fetchServices()
        let reminders = fetchReminders()

        print("Vehicles:")
        for vehicle in vehicles {
            print("ID: \(vehicle.vehicleID), Type: \(vehicle.vehicleType), Brand: \(vehicle.brand)")
        }
        
        print("\nServices:")
        for service in services {
            print("Date: \(service.date), Spareparts: \(service.servicedSparepart), Vehicle ID: \(service.vehicle.vehicleID)")
        }
        
        print("\nOdometers:")
        for odometer in odometers {
            print("Date: \(odometer.date), Current KM: \(odometer.currentKM), Vehicle ID: \(odometer.vehicle.vehicleID)")
        }
    }
}

extension SwiftDataService {
    func insertReminder(sparepart: Sparepart, reminderOdo: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool) {
        let newReminder = Reminder(
            date: Date(),
            sparepart: sparepart,
            reminderOdo: reminderOdo,
            kmInterval: kmInterval,
            dueDate: dueDate,
            timeInterval: timeInterval,
            vehicle: vehicle,
            isRepeat: isRepeat,
            isDraft: isDraft
        )
        modelContext.insert(newReminder)
        saveModelContext()
        
        NotificationManager.shared.scheduleNotification(for: newReminder)
        
        print("Reminder inserted and notification scheduled successfully!")
        
        print("Added reminder: \(newReminder.sparepart.rawValue)")
    }
    
    func editReminder(reminder: Reminder, sparepart: Sparepart, reminderOdo: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool) {
        reminder.sparepart = sparepart
        reminder.reminderOdo = reminderOdo
        reminder.kmInterval = kmInterval
        reminder.dueDate = dueDate
        reminder.timeInterval = timeInterval
        reminder.vehicle = vehicle
        reminder.isRepeat = isRepeat
        reminder.isDraft = isDraft
        saveModelContext()
        
        NotificationManager.shared.cancelNotification(for: reminder)
        NotificationManager.shared.scheduleNotification(for: reminder)
        
        print("Reminder edited successfully!")
    }
}

extension SwiftDataService {
    // Function to save a new service to the database
    func saveNewService(selectedDate: Date,
                        selectedParts: Set<Sparepart>,
                        odometerValue: Float,
                        selectedImage: Data?,
                        vehicle: Vehicle) {
        
        let newService = Servis(date: selectedDate,
                                servicedSparepart: Array(selectedParts),
                                photo: selectedImage,
                                odometer: odometerValue,
                                vehicle: vehicle)
        
        modelContext.insert(newService)
        createReminder(for: newService.vehicle, with: odometerValue, service: newService, selectedParts: selectedParts)
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save service: \(error)")
        }
    }
    
    // Function to update an existing service
    func updateService(service: Servis,
                       selectedDate: Date,
                       selectedParts: Set<Sparepart>,
                       odometerValue: Float,
                       selectedImage: Data?) {
        
        if let vehicle = modelContext.model(for: service.vehicle.persistentModelID) as? Vehicle {
            saveNewService(selectedDate: selectedDate, selectedParts: selectedParts, odometerValue: odometerValue, selectedImage: selectedImage, vehicle: vehicle)
            
        } else {
            print("vehicle not found")
        }
        if let lastService = modelContext.model(for: service.persistentModelID) as? Servis {
            modelContext.deleteParentAndChildren(parent: lastService, childrenKeyPath: \Servis.reminders)
  
        } else {
            print("vehicle not found")
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save reminder: \(error)")
        }
        
    }
    
    func deleteHistory(for service: Servis) {
        if let lastService = modelContext.model(for: service.persistentModelID) as? Servis {
            modelContext.delete(lastService)
            
        } else {
            print("vehicle not found")
        }
    
        saveModelContext()
    }
    
    // Function to create and insert a new Reminder for each selected spare part
    func createReminder(for vehicle: Vehicle,
                        with odometer: Float,
                        service: Servis,
                        selectedParts: Set<Sparepart>) {
        
        print("the service is : \(service.date)")
        
        for sparepart in selectedParts {
            guard let interval = vehicle.brand.intervalForSparepart(sparepart) else {
                continue
            }
            
//            let targetKM = odometer + Float(interval.kilometer)
            let reminderOdo = odometer
            let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: service.date) ?? Date()
            
            //            let newService = service
            let newReminder = Reminder(date: service.date,
                                       sparepart: sparepart,
                                       reminderOdo: reminderOdo,
                                       kmInterval: Float(interval.kilometer),
                                       dueDate: dueDate,
                                       timeInterval: interval.month,
                                       vehicle: service.vehicle,
                                       isRepeat: true,
                                       isDraft: false,
                                       service: service)
            NotificationManager.shared.scheduleNotification(for: newReminder)
            
            //            modelContext.insert(newReminder)
        }
        
        // Save the model context after adding the reminders
        do {
            //            try modelContext.save()
        } catch {
            print("Failed to save reminder: \(error)")
        }
    }
}



extension ModelContext {

    ///
    /// TODO:  BE REMOVED WHEN `.cascade` is fixed
    ///
    public func deleteParentAndChildren<Parent: PersistentModel, Child: PersistentModel>(
        parent: Parent,
        childrenKeyPath: KeyPath<Parent, [Child]>
    ) {
  
        let children = parent[keyPath: childrenKeyPath]
        
      
        for child in children {
            self.delete(child)  // Hapus setiap child
        }
        
        
        self.delete(parent)  // Hapus parent setelah child dihapus
        
        
        do {
            try self.save()
            print("Successfully deleted parent and its children.")
        } catch {
            print("Failed to delete parent and children: \(error)")
        }
    }

}

extension SwiftDataService {
    // Property to keep track of the current vehicle ID in UserDefaults
    private var currentVehicleID: String? {
        get {
            return UserDefaults.standard.string(forKey: "currentVehicleID")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentVehicleID")
        }
    }

    // MARK: - Set Current Vehicle
    func setCurrentVehicle(_ vehicle: Vehicle) {
        currentVehicleID = vehicle.vehicleID.uuidString
    }

    // MARK: - Get Current Vehicle
    func getCurrentVehicle() -> Vehicle? {
        guard let currentVehicleID = currentVehicleID, let uuid = UUID(uuidString: currentVehicleID) else {
            print("No current vehicle ID set or invalid UUID.")
            return nil
        }
        
        // Create a predicate to fetch the vehicle by its UUID
        let predicate = #Predicate<Vehicle> { vehicle in
            vehicle.vehicleID == uuid // Use the UUID for comparison
        }
        var descriptor = FetchDescriptor(predicate: predicate)
        descriptor.fetchLimit = 1 // Limit to one result

        do {
            // Fetch the vehicle from the model context
            let vehicles = try modelContext.fetch(descriptor)
            return vehicles.first // Return the first (and only) result
        } catch {
            print("Failed to fetch current vehicle: \(error.localizedDescription)")
            return nil
        }
    }
}

