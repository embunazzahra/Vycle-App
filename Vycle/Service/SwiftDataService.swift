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
        self.modelContainer = try! ModelContainer(for: Odometer.self, Vehicle.self, Servis.self, Trip.self, Reminder.self, configurations: ModelConfiguration(isStoredInMemoryOnly: false))
        
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
}

// MARK: OnBoarding
extension SwiftDataService {
    func insertOnBoarding(vehicleType: VehicleType, vehicleBrand: VehicleBrand, odometer: Float, serviceHistory: [ServiceHistory]){
        
        let vehicleData = Vehicle(vehicleType: vehicleType, brand: vehicleBrand)
        modelContext.insert(vehicleData)
        
        let odometerData = Odometer(date: Date(), currentKM: odometer, vehicle: vehicleData)
        modelContext.insert(odometerData)
        
        let groupedServiceHistory = Dictionary(grouping: serviceHistory, by: { $0.date })
        
        for (date, historyForDate) in groupedServiceHistory {
            let servicedSpareparts = historyForDate.compactMap { $0.sparepart }
            let serviceData = Servis(date: date, servicedSparepart: servicedSpareparts, vehicle: vehicleData)
            modelContext.insert(serviceData)
        }
        
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
        
        // Update properties of the existing service
        service.date = selectedDate
        service.odometer = odometerValue
        service.servicedSparepart = Array(selectedParts)
        service.photo = selectedImage
        
        // Clear all reminders associated with this service
        deleteReminders(for: service)
        // Create new reminders based on the updated service
        createReminder(for: Vehicle(vehicleType: .car, brand: .car(.honda)), with: odometerValue, service: service, selectedParts: selectedParts)
        
        // Save the changes in the model context
        do {
            try modelContext.save()
            
        } catch {
            print("Failed to update service: \(error)")
        }
    }
    
    func deleteReminders(for service: Servis) {
        // Fetch all reminders from the model context
        let allReminders = fetchReminders()
        
        // Create a variable to track if any reminders were deleted
        var remindersDeletedCount = 0
        
        // Iterate through the fetched reminders
        for reminder in allReminders {
            // Check if the reminder is associated with the specified service
            if (reminder.service?.id.hashValue) == (service.id.hashValue) {
                modelContext.delete(reminder) // Delete the reminder from the context
                remindersDeletedCount += 1
                print("Deleted reminder: \(reminder.sparepart)")
            }
            else {
                print("failed to delete reminder: \(reminder.service?.id)")
                print("failed to delete reminder service: \(service.id)")
                
            }
        }
        
        service.reminders.removeAll()
        
        // Attempt to save the context after deletion
        do {
            try modelContext.save()
            print("Successfully deleted \(remindersDeletedCount) reminders and saved context.")
        } catch {
            print("Failed to save context after deleting reminders: \(error)")
        }
        
        // Log the number of reminders left after deletion
        print("Total reminders after deletion: \(fetchReminders().count)")
    }
    
    //    // Function to delete reminders associated with a service
    //    func deleteReminders(for service: Servis) {
    //        let remindersToDelete = service.reminders // Store references to reminders
    //        for reminder in remindersToDelete {
    //            modelContext.delete(reminder) // Delete each reminder from the context
    //            saveModelContext()
    //            print("Deleted reminder: \(reminder.sparepart)")
    //        
    //        }
    //        
    //        print("reminder count: \(remindersToDelete.count)")
    //        
    //        // Optional: clear the local reminders array
    ////        service.reminders.removeAll()
    //        
    //        // Save the context after deletion
    //        do {
    //            try modelContext.save()
    //            print("Successfully deleted reminders and saved context.")
    //            print("reminder count 2: \(remindersToDelete.count)")
    //        } catch {
    //            print("Failed to save context after deleting reminders: \(error)")
    //        }
    //    }
    
    
    
    // Function to create and insert a new Reminder for each selected spare part
    private func createReminder(for vehicle: Vehicle,
                                with odometer: Float,
                                service: Servis,
                                selectedParts: Set<Sparepart>) {
        
        for sparepart in selectedParts {
            guard let interval = vehicle.brand.intervalForSparepart(sparepart) else {
                continue
            }
            
            let targetKM = odometer + Float(interval.kilometer)
            let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: service.date) ?? Date()
            
            let newReminder = Reminder(date: service.date,
                                       sparepart: sparepart,
                                       targetKM: targetKM,
                                       kmInterval: Float(interval.kilometer),
                                       dueDate: dueDate,
                                       timeInterval: interval.month,
                                       vehicle: vehicle,
                                       isRepeat: true,
                                       isDraft: false,
                                       service: service)
            
            modelContext.insert(newReminder)
        }
        
        // Save the model context after adding the reminders
        do {
            try modelContext.save()
        } catch {
            print("Failed to save reminder: \(error)")
        }
    }
    
}


