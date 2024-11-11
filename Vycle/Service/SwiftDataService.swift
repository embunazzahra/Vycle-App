//
//  SwiftDataService.swift
//  Vycle
//
//  Created by Dhau Embun Azzahra on 08/10/24.
//

import Foundation
import SwiftData
import UserNotifications

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
        let testTrip = Trip(tripID: 1, isFinished: false, locationHistories: [], vehicle: Vehicle(vehicleType: .car, brand: .car(.honda)))
        saveModelContext()
        let locationHistory = LocationHistory(distance: distance, latitude: latitude, longitude: longitude, time: time, trip: testTrip)
        modelContext.insert(locationHistory)
        
            do {
                try saveModelContext() // Save the context to persist the new trip
                checkAndNotifyIfNeeded()
            } catch {
                print("Failed to save trip: \(error.localizedDescription)")
            }
    }
    
//    private func checkAndNotifyIfNeeded() {
//           guard let latestOdometer = fetchOdometersForNotif().last,
//                 let reminder = fetchActiveReminder() else { return }
//           
//           let kilometerDifference = Float(reminder.kmInterval) - (Float(latestOdometer.currentKM) - Float(reminder.reminderOdo))
//           
//           if kilometerDifference <= 500 {
//               scheduleNotification(for: reminder.sparepart)
//               updateReminderDateToNow(reminder: reminder)
//           }
//    }
    
    private func checkAndNotifyIfNeeded() {
        guard let latestOdometer = fetchOdometersForNotif().last else { return }
        
        let activeReminders = fetchRemindersForNotif().filter { !$0.isDraft }
        
        print("Odometer terakhir: \(latestOdometer.currentKM)")
        
        let locationHistory = fetchLocationHistoryForNotif()
        let totalLocationDistance = locationHistory.first?.distance ?? 0.0
        
        for reminder in activeReminders {
            let kilometerDifference = Double(reminder.kmInterval) - ((Double(latestOdometer.currentKM) + totalLocationDistance) - Double(reminder.reminderOdo))

            print("Processing reminder: \(reminder.sparepart.rawValue), Kilometer Difference: \(kilometerDifference)")

//            if kilometerDifference > 500 {
//                if isDateUpdated(reminderID: reminder.id) {
//                    resetDateUpdated(reminderID: reminder.id)
//                    resetReminderDateToBefore(reminder: Reminder, vehicleType: VehicleType, vehicleBrand: VehicleBrand, servicedSpareparts: [Sparepart], service: Servis)
//                } else {
//                    print("Nothing")
//                }
//                
//            } else
            
            if kilometerDifference <= 0 {
                print("inside 0 KM Difference for \(reminder.sparepart.rawValue)")

                if shouldNotifyOnce(reminderID: reminder.id, sparepart: reminder.sparepart.rawValue) {
                    print("Notification sent for \(reminder.sparepart)")
                    sendImmediateNotification(for: reminder.sparepart)
                    setLastNotifiedDate(reminderID: reminder.id, sparepart: reminder.sparepart.rawValue)
                    scheduleRepeatingNotification(for: reminder.sparepart)
                }
                
                if !isDateUpdated(reminderID: reminder.id) {
                    updateReminderDateToNow(reminder: reminder)
                    setDateUpdated(reminderID: reminder.id)
                }
                
            } else if kilometerDifference <= 500 {
                print("inside 500 KM Difference")
                updateReminderDateToNow(reminder: reminder)
                setDateUpdated(reminderID: reminder.id)
            }
        }
    }

    private func fetchLocationHistoryForNotif() -> [LocationHistory] {
        let fetchDescriptor = FetchDescriptor<LocationHistory>(sortBy: [SortDescriptor(\.time, order: .reverse)])
        return (try? modelContext.fetch(fetchDescriptor)) ?? []
    }


    private func updateReminderDateToNow(reminder: Reminder) {
        editReminder(reminder: reminder,
                     sparepart: reminder.sparepart,
                     reminderOdo: reminder.reminderOdo,
                     kmInterval: reminder.kmInterval,
                     dueDate: Date(),
                     timeInterval: reminder.timeInterval,
    //                     vehicle: reminder.vehicle!,
                     isRepeat: reminder.isRepeat,
                     isDraft: reminder.isDraft,
                     isHelperOn: reminder.isDraft,
                     reminderType: reminder.reminderType,
                     isUsingData: reminder.isUsingData)
    }
    
    
//    private func resetReminderDateToBefore(reminder: Reminder, vehicleType: VehicleType, vehicleBrand: VehicleBrand, servicedSpareparts: [Sparepart], service: Servis) {
//        let vehicle = Vehicle(vehicleType: vehicleType, brand: vehicleBrand)
//        
//        for sparepart in servicedSpareparts {
//            guard let interval = vehicle.brand.intervalForSparepart(sparepart) else {
//                continue
//            }
//
//            let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: service.date) ?? Date()
//
//            editReminder(reminder: reminder,
//                         sparepart: reminder.sparepart,
//                         reminderOdo: reminder.reminderOdo,
//                         kmInterval: reminder.kmInterval,
//                         dueDate: dueDate,
//                         timeInterval: reminder.timeInterval,
//                         //                     vehicle: reminder.vehicle!,
//                         isRepeat: reminder.isRepeat,
//                         isDraft: reminder.isDraft)
//        }
//    }

    
    private func isDateUpdated(reminderID: PersistentIdentifier) -> Bool {
        let key = "dateUpdated_\(reminderID)"
        return UserDefaults.standard.bool(forKey: key)
    }

    private func setDateUpdated(reminderID: PersistentIdentifier) {
        let key = "dateUpdated_\(reminderID)"
        UserDefaults.standard.set(true, forKey: key)
    }

//    private func resetDateUpdated(reminderID: PersistentIdentifier) {
//        let key = "dateUpdated_\(reminderID)"
//        UserDefaults.standard.set(false, forKey: key)
//    }

    private func shouldNotifyOnce(reminderID: PersistentIdentifier, sparepart: String) -> Bool {
        let reminderKey = "initialNotified_\(sparepart)_\(reminderID)"
        return UserDefaults.standard.bool(forKey: reminderKey) == false
    }

    private func setLastNotifiedDate(reminderID: PersistentIdentifier, sparepart: String) {
        let reminderKey = "initialNotified_\(sparepart)_\(reminderID)"
        UserDefaults.standard.set(true, forKey: reminderKey)
        UserDefaults.standard.set(Date(), forKey: "lastNotified_\(reminderKey)")
    }

    private func getLastNotifiedDate(for sparepart: String) -> Date? {
        return UserDefaults.standard.object(forKey: "lastNotified_\(sparepart)") as? Date
    }

    private func sendImmediateNotification(for sparepart: Sparepart) {
       let content = UNMutableNotificationContent()
       content.title = "🚗 Honk! Kilometer suku cadang sudah mendekat, siap ganti!"
       content.body = "Waktunya untuk cek dan ganti \(sparepart.rawValue) biar kendaraanmu tetap prima di jalan! 🔧✨"
       content.sound = .default
       
       let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
       let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
       
       UNUserNotificationCenter.current().add(request) { error in
           if let error = error {
               print("Notification error: \(error.localizedDescription)")
           } else {
               print("Immediate notification sent for sparepart: \(sparepart.rawValue)")
           }
       }
    }

    private func scheduleRepeatingNotification(for sparepart: Sparepart) {
       let content = UNMutableNotificationContent()
       content.title = "🚗 Honk! Kilometer suku cadang sudah mendekat, siap ganti!"
       content.body = "Waktunya untuk cek dan ganti \(sparepart.rawValue) biar kendaraanmu tetap prima di jalan! 🔧✨"
       content.sound = .default
       
       let sevenDaysInSeconds: TimeInterval = 7 * 24 * 60 * 60
       let trigger = UNTimeIntervalNotificationTrigger(timeInterval: sevenDaysInSeconds, repeats: true)
       let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
       
       UNUserNotificationCenter.current().add(request) { error in
           if let error = error {
               print("Notification error: \(error.localizedDescription)")
           } else {
               print("Repeating notification scheduled for sparepart: \(sparepart.rawValue)")
           }
       }
    }

    private func fetchActiveReminder() -> Reminder? {
       return fetchRemindersForNotif().first { !$0.isDraft }
    }

    private func fetchRemindersForNotif() -> [Reminder] {
       let fetchDescriptor = FetchDescriptor<Reminder>(sortBy: [SortDescriptor(\.date, order: .reverse)])
       return (try? modelContext.fetch(fetchDescriptor)) ?? []
    }

    private func fetchOdometersForNotif() -> [Odometer] {
       let fetchDescriptor = FetchDescriptor<Odometer>(sortBy: [SortDescriptor(\.date, order: .forward)])
       return (try? modelContext.fetch(fetchDescriptor)) ?? []
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
        print(" odometer number: \(odometer)")
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
//                    let reminderOdo = odometer
//                    print("target km : \(reminderOdo)")
                    let dueDate = Calendar.current.date(byAdding: .month, value: interval.month, to: date) ?? Date()
                    let reminderData = Reminder(
                        date: date,
                        sparepart: sparepart,
                        reminderOdo: 0,
                        kmInterval: Float(interval.kilometer),
                        dueDate: dueDate,
                        timeInterval: interval.month,
                        vehicle: self.getCurrentVehicle()!,
                        isRepeat: true, // Set true if you want reminders to repeat
                        isDraft: true,
                        isHelperOn: false,
                        reminderType: "Service Reminder",
                        isUsingData: true
                    )
                    modelContext.insert(reminderData)
                }
            }
        }

        
        saveModelContext()
        printAllData()
    }
    
    func insertOdometerData(odometer: Float){
        let odometerData = Odometer(date: Date(), currentKM: odometer, vehicle: self.getCurrentVehicle()!)
        modelContext.insert(odometerData)
        saveModelContext()
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
    
    func fetchLocationHistory() -> [LocationHistory] {
        let fetchRequest = FetchDescriptor<LocationHistory>()
        let locationHistory = (try? modelContext.fetch(fetchRequest)) ?? []
        return locationHistory
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
    func insertReminder(sparepart: Sparepart, reminderOdo: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool, isHelperOn: Bool, reminderType: String, isUsingData: Bool) {
        let newReminder = Reminder(
            date: Date(),
            sparepart: sparepart,
            reminderOdo: reminderOdo,
            kmInterval: kmInterval,
            dueDate: dueDate,
            timeInterval: timeInterval,
            vehicle: vehicle,
            isRepeat: isRepeat,
            isDraft: isDraft,
            isHelperOn: false,
            reminderType: "Manual Reminder",
            isUsingData: false
        )
        modelContext.insert(newReminder)
        saveModelContext()
        
        NotificationManager.shared.scheduleNotification(for: newReminder)
        
        print("Reminder inserted and notification scheduled successfully!")
        
        print("Added reminder: \(newReminder.sparepart.rawValue)")
    }
    
    func editReminder(reminder: Reminder, sparepart: Sparepart, reminderOdo: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, isRepeat: Bool, isDraft: Bool, isHelperOn: Bool, reminderType: String, isUsingData: Bool) {
        reminder.sparepart = sparepart
        reminder.reminderOdo = reminderOdo
        reminder.kmInterval = kmInterval
        reminder.dueDate = dueDate
        reminder.timeInterval = timeInterval
//        reminder.vehicle = vehicle
        reminder.isRepeat = isRepeat
        reminder.isDraft = isDraft
        reminder.isHelperOn = isHelperOn
        reminder.reminderType = "Edited Reminder"
        reminder.isUsingData = isUsingData
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
        do {
            try modelContext.save()
        } catch {
            print("Failed to save service: \(error)")
        }
        createReminder(for: newService.vehicle, with: odometerValue, service: newService, selectedParts: selectedParts)
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
            modelContext.deleteParentAndChildren(parent: lastService, childrenKeyPath: \Servis.reminders)
            
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
                                       service: service,
                                       isHelperOn: true,
                                       reminderType: "Service Reminder",
                                       isUsingData: true)
            NotificationManager.shared.scheduleNotification(for: newReminder)
            
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

