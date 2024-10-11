//
//  BLEManager.swift
//  Vycle
//
//  Created by Vincent Senjaya on 11/10/24.
//


import SwiftUI
import SwiftData
import CoreBluetooth

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    var centralManager: CBCentralManager!
    var espPeripheral: CBPeripheral?
    
    @Published var isConnected = false // Published property to notify SwiftUI of connection changes
    @Published var message = "Searching for ESP32..."
    @Published var rssi: Int? // RSSI value of the connected device
    
    override init() {
        super.init()
//        centralManager = CBCentralManager(delegate: self, queue: nil)
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "BLEManagerRestoreKey"])

    }
    
    // Called when the state of Bluetooth changes
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            message = "Bluetooth is powered on. Scanning..."
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        case .poweredOff:
            message = "Bluetooth is off. Please enable it."
        case .unsupported:
            message = "Bluetooth is not supported on this device."
        default:
            message = "Bluetooth state unknown."
        }
    }
    
    // Discovered a peripheral
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if peripheral.name == "ALOHA" {
            espPeripheral = peripheral
            centralManager.stopScan()
            message = "ESP32 Found! Connecting..."
            centralManager.connect(peripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String: Any]) {
        if let peripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
            for peripheral in peripherals {
                if peripheral.name == "ALOHA" {
                    espPeripheral = peripheral
                    espPeripheral?.delegate = self
                    isConnected = true
                    message = "Restored connection to ESP32!"
                    centralManager.connect(peripheral, options: nil)
                }
            }
        }
    }

    
    // Connected to the peripheral
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isConnected = true
        message = "Connected to ESP32!"
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        
        // Read RSSI periodically (every 1 second)
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            peripheral.readRSSI()
        }
    }
    
    // Disconnected from the peripheral
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isConnected = false
        message = "Disconnected from ESP32. Scanning again..."
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    // RSSI value updated
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let error = error {
            print("Error reading RSSI: \(error.localizedDescription)")
        } else {
            rssi = RSSI.intValue // Update the RSSI value
        }
    }
    
    // Discovered services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            for service in services {
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    
    // Discovered characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                // Add your interaction logic here (e.g., read/write characteristics)
            }
        }
    }
}
