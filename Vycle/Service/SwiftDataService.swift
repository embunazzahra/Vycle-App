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
    
    func insertVehicle(){
        let testVehicle = Vehicle(vehicleType: .car, brand: .car(.toyota))
        modelContext.insert(testVehicle)
    }
    
    func insertReminder(){
        let testVehicle = Reminder(date: Date(), sparepart: .busi, targetKM: 1000, kmInterval: 1200, dueDate: Date(), timeInterval: 1, vehicle: Vehicle(vehicleType: .car, brand: .car(.toyota)), isRepeat: false, isDraft: false)
        modelContext.insert(testVehicle)
    }
    
    func resetPersistentStore() {
        do {
            try modelContext.delete(model: LocationHistory.self)
        } catch {
            print("Failed to clear all Country and City data.")
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
//extension SwiftDataService {
//    func insertOnBoarding(vehicleType: VehicleType, vehicleBrand: VehicleBrand, odometer: Float, serviceHistory: [ServiceHistory]){
//        
//        let vehicleData = Vehicle(vehicleType: vehicleType, brand: vehicleBrand)
//        let odometerData = Odometer(date: Date(), currentKM: odometer, vehicle: vehicleData)
//        
//        let servicedSparepart = serviceHistory.map { $0.sparepart }
//        let serviceData = Servis(date: Date(), servicedSparepart: servicedSparepart, vehicle: vehicleData)
//        
//        modelContext.insert(vehicleData)
//        modelContext.insert(odometerData)
//        modelContext.insert(serviceData)
//        
//        saveModelContext()
//        
//        printAllData()
//    }
//}

extension SwiftDataService {
    func insertOnBoarding(vehicleType: VehicleType, vehicleBrand: VehicleBrand, odometer: Float, serviceHistory: [ServiceHistory]? = nil) {
        
        let vehicleData = Vehicle(vehicleType: vehicleType, brand: vehicleBrand)

        let odometerData = Odometer(date: Date(), currentKM: odometer, vehicle: vehicleData)
        
        // Insert the vehicle and odometer data
       
        
        // Only insert service data if serviceHistory is not nil or empty
        if let serviceHistory = serviceHistory, !serviceHistory.isEmpty {
            let servicedSparepart = serviceHistory.map { $0.sparepart }
            let serviceData = Servis(date: Date(), servicedSparepart: servicedSparepart, vehicle: vehicleData)
            modelContext.insert(serviceData)
        }
        modelContext.insert(vehicleData)
        modelContext.insert(odometerData)
        
//        let odometerData = Odometer(date: Date(), currentKM: odometer, vehicle: vehicleData)
//        modelContext.insert(odometerData)
        
//        let groupedServiceHistory = Dictionary(grouping: serviceHistory, by: { $0.date })
//        saveModelContext()
        
//        for (date, historyForDate) in groupedServiceHistory {
//            let servicedSpareparts = historyForDate.compactMap { $0.sparepart }
//            let serviceData = Servis(date: date, servicedSparepart: servicedSpareparts, vehicle: vehicleData)
//            modelContext.insert(serviceData)
//        }

        saveModelContext()
        printAllData()
    }
}


// MARK: Debug
extension SwiftDataService {
    
    func fetchVehicles() -> [Vehicle] {
        let fetchRequest = FetchDescriptor<Vehicle>()
        let vehicles = (try? modelContext.fetch(fetchRequest)) ?? []
        return vehicles
    }
    
    func fetchServices() -> [Servis] {
        let fetchRequest = FetchDescriptor<Servis>()
        let services = (try? modelContext.fetch(fetchRequest)) ?? []
        return services
    }
    
    func fetchOdometers() -> [Odometer] {
        let fetchRequest = FetchDescriptor<Odometer>()
        let odometers = (try? modelContext.fetch(fetchRequest)) ?? []
        return odometers
    }
    
    func fetchReminders() -> [Reminder] {
        let fetchRequest = FetchDescriptor<Reminder>()
        let reminders = (try? modelContext.fetch(fetchRequest)) ?? []
        return reminders
    }
    
    func printAllData() {
        let vehicles = fetchVehicles()
        let services = fetchServices()
        let odometers = fetchOdometers()
        
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
    func insertReminder(sparepart: Sparepart, targetKM: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool) {
        let newReminder = Reminder(
            date: Date(),
            sparepart: sparepart,
            targetKM: targetKM,
            kmInterval: kmInterval,
            dueDate: dueDate,
            timeInterval: timeInterval,
            vehicle: vehicle,
            isRepeat: isRepeat,
            isDraft: isDraft
        )
        modelContext.insert(newReminder)
        saveModelContext()
        print("Reminder inserted successfully!")
    }
    
    func editReminder(reminder: Reminder, sparepart: Sparepart, targetKM: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool) {
        reminder.sparepart = sparepart
        reminder.targetKM = targetKM
        reminder.kmInterval = kmInterval
        reminder.dueDate = dueDate
        reminder.timeInterval = timeInterval
        reminder.vehicle = vehicle
        reminder.isRepeat = isRepeat
        reminder.isDraft = isDraft
        saveModelContext()
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
            
            let targetKM = odometer + Float(interval.kilometer)
            let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: service.date) ?? Date()
            
            //            let newService = service
            let newReminder = Reminder(date: service.date,
                                       sparepart: sparepart,
                                       targetKM: targetKM,
                                       kmInterval: Float(interval.kilometer),
                                       dueDate: dueDate,
                                       timeInterval: interval.month,
                                       vehicle: service.vehicle,
                                       isRepeat: true,
                                       isDraft: false,
                                       service: service)
            
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

extension SwiftDataService {
    func insertReminder(sparepart: Sparepart, targetKM: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool) {
        let newReminder = Reminder(
            date: Date(),
            sparepart: sparepart,
            targetKM: targetKM,
            kmInterval: kmInterval,
            dueDate: dueDate,
            timeInterval: timeInterval,
            vehicle: vehicle,
            isRepeat: isRepeat,
            isDraft: isDraft
        )
        modelContext.insert(newReminder)
        saveModelContext()
        print("Reminder inserted successfully!")
    }
    
    func editReminder(reminder: Reminder, sparepart: Sparepart, targetKM: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool) {
        reminder.sparepart = sparepart
        reminder.targetKM = targetKM
        reminder.kmInterval = kmInterval
        reminder.dueDate = dueDate
        reminder.timeInterval = timeInterval
        reminder.vehicle = vehicle
        reminder.isRepeat = isRepeat
        reminder.isDraft = isDraft
        saveModelContext()
        print("Reminder edited successfully!")
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
