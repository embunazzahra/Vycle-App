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
    
    private func checkAndNotifyIfNeeded() {
        guard let latestOdometer = fetchOdometersForNotif().last else { return }
        
        let activeReminders = fetchRemindersForNotif().filter { !$0.isDraft }
        print("Latest odometer reading: \(latestOdometer.currentKM)")
        
        let locationHistory = fetchLocationHistoryForNotif()
        let totalLocationDistance = locationHistory.first?.distance ?? 0.0
        
        // Track notifications for spare parts already processed in this loop
        var notifiedSpareParts: Set<String> = []

        for reminder in activeReminders {
            let kilometerDifference = Double(reminder.kmInterval) - ((Double(latestOdometer.currentKM) + totalLocationDistance) - Double(reminder.reminderOdo))
            
            print("Processing reminder: \(reminder.sparepart.rawValue), Kilometer Difference: \(kilometerDifference)")
            
            // Skip if already notified for this spare part in this loop
            if notifiedSpareParts.contains(reminder.sparepart.rawValue) {
                continue
            }
            
            if kilometerDifference <= 0 {
                print("Inside 0 KM Difference for \(reminder.sparepart.rawValue)")

                let remindersForSparePart = activeReminders.filter { $0.sparepart.rawValue == reminder.sparepart.rawValue }
                
                let sortedReminders = remindersForSparePart.sorted { $0.date > $1.date }
                
                if let latestReminder = sortedReminders.first {
                    if latestReminder.id == reminder.id && shouldNotifyOnce(reminderID: reminder.id, sparepart: reminder.sparepart.rawValue) {
                        print("Notification sent for \(reminder.sparepart.rawValue)")
                        sendImmediateNotification(for: reminder.sparepart)
                        setLastNotifiedDate(reminderID: reminder.id, sparepart: reminder.sparepart.rawValue)
                        scheduleRepeatingNotification(for: reminder.sparepart)
                        
                        notifiedSpareParts.insert(reminder.sparepart.rawValue)
                    }
                }
                
                if !isDateUpdated(reminderID: reminder.id) {
                    updateReminderDateToNow(reminder: reminder)
                    setDateUpdated(reminderID: reminder.id)
                }
                
            } else if kilometerDifference <= 500 {
                print("Inside 500 KM Difference")
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
                     kmInterval: reminder.kmInterval,
                     dueDate: Date(),
                     timeInterval: reminder.timeInterval,
                     isRepeat: reminder.isRepeat,
                     isDraft: reminder.isDraft,
                     isHelperOn: reminder.isDraft,
                     reminderType: reminder.reminderType,
                     isEdited: reminder.isEdited,
                     date: reminder.date)
    }

    private func isDateUpdated(reminderID: PersistentIdentifier) -> Bool {
        let key = "dateUpdated_\(reminderID)"
        return UserDefaults.standard.bool(forKey: key)
    }

    private func setDateUpdated(reminderID: PersistentIdentifier) {
        let key = "dateUpdated_\(reminderID)"
        UserDefaults.standard.set(true, forKey: key)
    }

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
                    vehicle: self.getCurrentVehicle()!,
                    totalPrice: 0
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
//                        isUsingData: true,
                        isEdited: false
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
    func insertReminder(sparepart: Sparepart, reminderOdo: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, vehicle: Vehicle, isRepeat: Bool, isDraft: Bool, isHelperOn: Bool, reminderType: String, isEdited: Bool) {
        let existingReminders = fetchReminders(for: sparepart, dueBefore: dueDate)
        
        for reminder in existingReminders {
            NotificationManager.shared.cancelNotification(for: reminder)
            print("Canceled notification for existing reminder: \(reminder.sparepart)")
        }
        
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
            isEdited: false
        )
        
        modelContext.insert(newReminder)
        saveModelContext()
        
        NotificationManager.shared.scheduleNotification(for: newReminder)
        
        print("Reminder inserted and notification scheduled successfully!")
        print("Added reminder: \(newReminder.sparepart)")
    }

    private func fetchReminders(for sparepart: Sparepart, dueBefore date: Date? = nil) -> [Reminder] {
        let fetchDescriptor = FetchDescriptor<Reminder>()
        
        do {
            let allReminders = try modelContext.fetch(fetchDescriptor)
            print("fetchReminders: \(allReminders.count), sparepart: \(sparepart)")
            return allReminders.filter {
                $0.sparepart == sparepart && (date == nil || $0.date < date!)
            }
        } catch {
            print("Failed to fetch reminders: \(error)")
            return []
        }
    }

    
    func editReminder(reminder: Reminder, sparepart: Sparepart, kmInterval: Float, dueDate: Date, timeInterval: Int, isRepeat: Bool, isDraft: Bool, isHelperOn: Bool, reminderType: String, isEdited: Bool, date: Date? = nil) {
        reminder.sparepart = sparepart
        reminder.kmInterval = kmInterval
        reminder.dueDate = dueDate
        reminder.timeInterval = timeInterval
        reminder.isRepeat = isRepeat
        reminder.isDraft = isDraft
        reminder.isHelperOn = isHelperOn
        reminder.reminderType = "Edited Reminder"
        reminder.isEdited = true
        reminder.date = Date()
        saveModelContext()
        
        let activeReminders = fetchRemindersForNotif().filter { !$0.isDraft }
        
        let remindersForSparePart = activeReminders.filter { $0.sparepart.rawValue == reminder.sparepart.rawValue }
        let sortedReminders = remindersForSparePart.sorted { $0.dueDate > $1.dueDate }
        
        if let latestReminder = sortedReminders.first {
            if latestReminder.id == reminder.id {
                NotificationManager.shared.cancelNotification(for: reminder)
                
                NotificationManager.shared.scheduleNotification(for: reminder)
                
                print("Notification canceled and rescheduled for \(reminder.sparepart.rawValue) with due date \(reminder.dueDate)")
            }
        }
        
        print("Reminder edited successfully!")
    }
    
    func editDraft(reminder: Reminder, sparepart: Sparepart, reminderOdo: Float, kmInterval: Float, dueDate: Date, timeInterval: Int, isRepeat: Bool, isDraft: Bool, isHelperOn: Bool, reminderType: String, isEdited: Bool) {
        reminder.sparepart = sparepart
        reminder.reminderOdo = reminderOdo
        reminder.kmInterval = kmInterval
        reminder.dueDate = dueDate
        reminder.timeInterval = timeInterval
        reminder.isRepeat = isRepeat
        reminder.isDraft = isDraft
        reminder.isHelperOn = isHelperOn
        reminder.reminderType = reminderType
        reminder.isEdited = true
        saveModelContext()
        
        let activeReminders = fetchRemindersForNotif().filter { !$0.isDraft }
        
        let remindersForSparePart = activeReminders.filter { $0.sparepart.rawValue == reminder.sparepart.rawValue }
        let sortedReminders = remindersForSparePart.sorted { $0.dueDate > $1.dueDate }
        
        if let latestReminder = sortedReminders.first {
            if latestReminder.id == reminder.id {
                NotificationManager.shared.cancelNotification(for: reminder)
                
                NotificationManager.shared.scheduleNotification(for: reminder)
                
                print("Notification canceled and rescheduled for \(reminder.sparepart.rawValue) with due date \(reminder.dueDate)")
            }
        }
        
        
        print("Reminder edited successfully!")
    }
}

extension SwiftDataService {
    func saveNewService(selectedDate: Date,
                        selectedParts: Set<Sparepart>,
                        odometerValue: Float,
                        selectedImage: Data?,
                        vehicle: Vehicle,
                        totalPrice: Float) {
        
        let newService = Servis(date: selectedDate,
                                servicedSparepart: Array(selectedParts),
                                photo: selectedImage,
                                odometer: odometerValue,
                                vehicle: vehicle,
                                totalPrice: totalPrice)
        
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
                       selectedImage: Data?,
                       totalPrice: Float) {
        
        if let vehicle = modelContext.model(for: service.vehicle.persistentModelID) as? Vehicle {
            saveNewService(selectedDate: selectedDate, selectedParts: selectedParts, odometerValue: odometerValue, selectedImage: selectedImage, vehicle: vehicle, totalPrice: totalPrice)
            
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
        guard let lastService = modelContext.model(for: service.persistentModelID) as? Servis else {
            print("Service not found")
            return
        }

        print("Reminders for last service: \(lastService.reminders)")
        print("Spare part for last service: \(lastService.servicedSparepart)")

        do {
            let allReminders = try modelContext.fetch(FetchDescriptor<Reminder>())
            let sparePartName = lastService.reminders.first?.sparepart.rawValue ?? ""
            
            let remindersWithSameSparePart = allReminders.filter { $0.sparepart.rawValue == sparePartName }
            
            if let latestReminder = remindersWithSameSparePart.sorted(by: { $0.date > $1.date }).first {
                NotificationManager.shared.cancelNotification(for: latestReminder)
                print("Cancelled notification for the last reminder with spare part: \(sparePartName)")
            }
            
            modelContext.deleteParentAndChildren(parent: lastService, childrenKeyPath: \Servis.reminders)
            print("Successfully deleted the service and all associated reminders for spare part: \(sparePartName)")
            
            saveModelContext()
            
            // fetch lagi buat dapetin data terbaru
            let updatedReminders = try modelContext.fetch(FetchDescriptor<Reminder>())
            let remainingRemindersWithSameSparePart = updatedReminders.filter {
                $0.sparepart.rawValue == sparePartName && !$0.isDeleted
            }
            
            if let newLatestReminder = remainingRemindersWithSameSparePart.sorted(by: { $0.date > $1.date }).first {
                NotificationManager.shared.scheduleNotification(for: newLatestReminder)
                print("Scheduled notification for the new latest reminder with spare part: \(sparePartName)")
            } else {
                print("No remaining reminders with spare part: \(sparePartName)")
            }
            
        } catch {
            print("Failed to fetch reminders: \(error)")
        }
    }


    
    func createReminder(for vehicle: Vehicle,
                        with odometer: Float,
                        service: Servis,
                        selectedParts: Set<Sparepart>) {
        
        print("The service is on: \(service.date)")
        
        for sparepart in selectedParts {
            let existingReminders = fetchReminders(for: sparepart, dueBefore: service.date)
            print("existingReminders: \(existingReminders.count)")
            
            for reminder in existingReminders {
                NotificationManager.shared.cancelNotification(for: reminder)
                print("Canceled notification for existing reminder: \(reminder.sparepart)")
            }
            
            let reminderOdo = odometer
            
            // Check if an interval exists or if the latest reminder was edited
            if let interval = vehicle.brand.intervalForSparepart(sparepart) {
                let latestReminder = existingReminders.sorted { $0.date > $1.date }.first
                
                let kmInterval: Float
                let timeInterval: Int
                let dueDate: Date
                
                if let latestReminder = latestReminder, latestReminder.isEdited {
                    print("Using latest edited reminder values.")
                    kmInterval = latestReminder.kmInterval
                    timeInterval = latestReminder.timeInterval
                    dueDate = Calendar.current.date(byAdding: .month, value: timeInterval, to: service.date) ?? Date()
                } else {
                    print("No previous edited reminder found. Using default interval values.")
                    kmInterval = Float(interval.kilometer)
                    timeInterval = interval.month
                    dueDate = Calendar.current.date(byAdding: .month, value: timeInterval, to: service.date) ?? Date()
                }
                
                let newReminder = Reminder(
                    date: service.date,
                    sparepart: sparepart,
                    reminderOdo: reminderOdo,
                    kmInterval: kmInterval,
                    dueDate: dueDate,
                    timeInterval: timeInterval,
                    vehicle: service.vehicle,
                    isRepeat: true,
                    isDraft: false,
                    service: service,
                    isHelperOn: true,
                    reminderType: "Service Reminder",
                    isEdited: false
                )
                
                NotificationManager.shared.scheduleNotification(for: newReminder)
                modelContext.insert(newReminder)
            } else if let latestReminder = existingReminders.sorted(by: { $0.date > $1.date }).first, latestReminder.reminderType != "Draft Reminder" {
                print("No interval, but latest reminder was edited. Using latest edited reminder values.")
                
                let newReminder = Reminder(
                    date: service.date,
                    sparepart: sparepart,
                    reminderOdo: reminderOdo,
                    kmInterval: latestReminder.kmInterval,
                    dueDate: latestReminder.dueDate,
                    timeInterval: latestReminder.timeInterval,
                    vehicle: service.vehicle,
                    isRepeat: true,
                    isDraft: false,
                    service: service,
                    isHelperOn: true,
                    reminderType: "Service Reminder",
                    isEdited: false
                )
                
                NotificationManager.shared.scheduleNotification(for: newReminder)
                modelContext.insert(newReminder)
            } else {
                let newReminder = Reminder(
                    date: service.date,
                    sparepart: sparepart,
                    reminderOdo: reminderOdo,
                    kmInterval: 123, // will be ignored because it is still a draft
                    dueDate: Date(), // will be ignored because it is still a draft
                    timeInterval: 99, // will be ignored because it is still a draft
                    vehicle: service.vehicle,
                    isRepeat: true,
                    isDraft: true,
                    service: service,
                    isHelperOn: true,
                    reminderType: "Draft Reminder",
                    isEdited: false
                )
                
                modelContext.insert(newReminder)
            }
            
            do {
                try modelContext.save()
                print("Reminders saved successfully!")
            } catch {
                print("Failed to save reminder: \(error)")
            }
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

