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
                    vehicle: vehicleData
                )
                modelContext.insert(serviceData)
                
                for sparepart in servicedSpareparts {
                    // Insert Reminder
                    guard let interval = vehicleData.brand.intervalForSparepart(sparepart) else {
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
                        vehicle: vehicleData,
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


