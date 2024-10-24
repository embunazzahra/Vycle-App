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
        let odometers = fetchOdometers()
        do {
            try modelContext.delete(model: LocationHistory.self)
            saveModelContext()
            print("\nOdometers:")
            for odometer in odometers {
                print("Date: \(odometer.date), Current KM: \(odometer.currentKM), Vehicle ID: \(odometer.vehicle.vehicleID)")
            }
        } catch {
            print("Failed to clear all location")
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
                    vehicle: Vehicle(vehicleType: vehicleType, brand: vehicleBrand)
                )
                modelContext.insert(serviceData)
                
                for sparepart in servicedSpareparts {
                    // Insert Reminder
                    guard let interval = Vehicle(vehicleType: vehicleType, brand: vehicleBrand).brand.intervalForSparepart(sparepart) else {
                        continue
                    }

                    let targetKM = odometer + Float(interval.kilometer)
                    let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: date) ?? Date()
                    let reminderData = Reminder(
                        date: date,
                        sparepart: sparepart,
                        targetKM: targetKM,
                        kmInterval: Float(interval.kilometer),
                        dueDate: dueDate,
                        timeInterval: interval.month,
                        vehicle: Vehicle(vehicleType: vehicleType, brand: vehicleBrand),
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

        print("\nOdometers:")
        for odometer in odometers {
            print("Date: \(odometer.date), Current KM: \(odometer.currentKM), Vehicle ID: \(odometer.vehicle.vehicleID)")
        }
        
        print("\nServices:")
        for service in services {
            print("Date: \(service.date), Spareparts: \(service.servicedSparepart), Vehicle ID: \(service.vehicle.vehicleID)")
        }
        
        print("\nReminders:")
        for reminder in reminders {
            print("Date: \(reminder.date), Sparepart: \(reminder.sparepart), Target KM: \(reminder.targetKM), KM Interval: \(reminder.kmInterval), Due Date: \(reminder.dueDate), Time Interval: \(reminder.timeInterval) months, Vehicle ID: \(reminder.vehicle.vehicleID), Repeat: \(reminder.isRepeat ? "Yes" : "No"), Draft: \(reminder.isDraft ? "Yes" : "No")")
        }
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
