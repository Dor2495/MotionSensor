//
//  BluetoothManager.swift
//  MotionSensor
//
//  Created by Dor Mizrachi on 27/05/2025.
//

import CoreBluetooth
import Foundation
import ActivityKit

class BluetoothManager: NSObject, ObservableObject {
    @Published var isScanning = false
    @Published var isConnected = false
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var receivingData: String = "Waiting..."
    @Published var isMotionDetected: Bool = false {
        didSet {
            updateLiveActivity()
        }
    }
    @Published var peripheralName: String? = nil {
        didSet {
            updateLiveActivity()
        }
    }
    
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var writeCharacteristic: CBCharacteristic?
    
    @available(iOS 16.1, *)
    private var liveActivityManager: LiveActivityManager {
        return LiveActivityManager.shared
    }
    
    static let shared = BluetoothManager()
    
    private override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func startScanning() {
        guard centralManager.state == .poweredOn else { return }
        isScanning = true
        discoveredPeripherals.removeAll()
        centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
    
    func stopScanning() {
        isScanning = false
        centralManager.stopScan()
    }
    
    func connect(to peripheral: CBPeripheral) {
        centralManager.connect(peripheral, options: nil)
        peripheral.delegate = self
    }
    
    func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
    }
    
    func sendValue(_ value: String) {
        guard let characteristic = writeCharacteristic,
              let peripheral = connectedPeripheral else { return }
        
        guard let data = value.data(using: .utf8) else { return }
        peripheral.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    func sendValue(_ value: Bool) {
        sendValue(value.description)
    }
    
    func sendValue(_ value: Int) {
        sendValue(value.description)
    }
    
    func sendValue(_ value: Double) {
        sendValue(value.description)
    }
    
    // MARK: - Live Activity Management
    @available(iOS 16.1, *)
    func startLiveActivity() {
        let sensorName = "ESP32 Motion Sensor"
        let deviceName = peripheralName ?? "Unknown Device"
        liveActivityManager.startLiveActivity(
            sensorName: sensorName,
            deviceName: deviceName,
            isConnected: isConnected
        )
    }
    
    @available(iOS 16.1, *)
    func stopLiveActivity() {
        liveActivityManager.stopLiveActivity()
    }
    
    @available(iOS 16.1, *)
    private func updateLiveActivity() {
        guard #available(iOS 16.1, *) else { return }
        
        let deviceName = peripheralName ?? "Unknown Device"
        liveActivityManager.updateLiveActivity(
            isMotionDetected: isMotionDetected,
            deviceName: deviceName,
            isConnected: isConnected
        )
    }
}

extension BluetoothManager: CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            print("Bluetooth is powered on")
        } else {
            print("Bluetooth is not available: \(central.state)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        if !discoveredPeripherals.contains(peripheral) {
            discoveredPeripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        peripheralName = peripheral.name ?? "Unknown"
        isConnected = true
        stopScanning()
        peripheral.discoverServices(nil)
        
        // Update Live Activity when connection status changes
        updateLiveActivity()
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        connectedPeripheral = nil
        peripheralName = nil
        isConnected = false
        writeCharacteristic = nil
        
        // Update Live Activity when connection status changes
        updateLiveActivity()
    }
}

extension BluetoothManager: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            if characteristic.properties.contains(.write) || characteristic.properties.contains(.writeWithoutResponse) {
                writeCharacteristic = characteristic
            } else  if characteristic.properties.contains(.notify) {
                print("Subscribing to notifications for \(characteristic.uuid)")
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }

    
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        guard let data = characteristic.value else { return }
        let message = String(data: data, encoding: .utf8) ?? "Invalid"

        if message == "motion" {
            isMotionDetected = true
            receivingData = "🚨 Motion detected!"
            // Update UI or trigger event
        }
        
        if message == "no motion" {
            isMotionDetected = false
            receivingData = "✅ No Motion detected!"
            // Update UI or trigger event
        }
    }
}
