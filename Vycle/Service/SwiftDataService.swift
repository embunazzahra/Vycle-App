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


