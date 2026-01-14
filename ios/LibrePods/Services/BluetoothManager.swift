/*
    LibrePods - AirPods liberated from Apple's ecosystem
    Copyright (C) 2025 LibrePods contributors

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import Foundation
import CoreBluetooth
import Combine

/// Bluetooth manager wrapping CoreBluetooth for AirPods communication
class BluetoothManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    @Published var isScanning: Bool = false
    @Published var isConnected: Bool = false
    @Published var discoveredPeripherals: [CBPeripheral] = []
    @Published var connectionState: CBPeripheralState = .disconnected
    
    // MARK: - Private Properties
    private var centralManager: CBCentralManager!
    private var connectedPeripheral: CBPeripheral?
    private var l2capChannel: CBL2CAPChannel?
    private var l2capPSM: UInt16 = 0
    
    // MARK: - Callbacks
    var onDataReceived: ((Data) -> Void)?
    var onConnectionStateChanged: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
    
    // MARK: - Initialization
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }
    
    // MARK: - Public Methods
    
    /// Start scanning for AirPods
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            print("Bluetooth is not powered on")
            return
        }
        
        isScanning = true
        
        // Scan for devices with AirPods service UUID
        let services = [BluetoothConstants.airPodsServiceUUID]
        centralManager.scanForPeripherals(withServices: services, options: [
            CBCentralManagerScanOptionAllowDuplicatesKey: false
        ])
        
        print("Started scanning for AirPods...")
    }
    
    /// Stop scanning for AirPods
    func stopScanning() {
        centralManager.stopScan()
        isScanning = false
        print("Stopped scanning")
    }
    
    /// Connect to a specific peripheral
    func connect(to peripheral: CBPeripheral) {
        connectedPeripheral = peripheral
        peripheral.delegate = self
        centralManager.connect(peripheral, options: nil)
        print("Connecting to \(peripheral.name ?? "Unknown")")
    }
    
    /// Disconnect from current peripheral
    func disconnect() {
        if let peripheral = connectedPeripheral {
            centralManager.cancelPeripheralConnection(peripheral)
        }
        
        if let channel = l2capChannel {
            // Close L2CAP channel
            l2capChannel = nil
        }
    }
    
    /// Send data over L2CAP channel
    func sendData(_ data: Data) {
        guard let channel = l2capChannel else {
            print("No L2CAP channel available")
            return
        }
        
        // Write data to the output stream
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            guard let pointer = bytes.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                return
            }
            
            let outputStream = channel.outputStream
            let bytesWritten = outputStream.write(pointer, maxLength: data.count)
            
            if bytesWritten < 0 {
                print("Error writing data: \(outputStream.streamError?.localizedDescription ?? "Unknown")")
            } else if bytesWritten < data.count {
                print("Warning: Only wrote \(bytesWritten) of \(data.count) bytes")
            } else {
                print("Sent \(bytesWritten) bytes")
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func openL2CAPChannel(peripheral: CBPeripheral) {
        // Try to open L2CAP channel
        // Note: iOS doesn't provide direct PSM discovery, so we might need to use characteristics
        // For now, we'll use a placeholder approach
        
        // Discover services first
        peripheral.discoverServices([BluetoothConstants.airPodsServiceUUID])
    }
    
    private func setupL2CAPChannel(_ channel: CBL2CAPChannel) {
        self.l2capChannel = channel
        
        // Set up input stream delegate to receive data
        let inputStream = channel.inputStream
        inputStream.delegate = self
        inputStream.schedule(in: .main, forMode: .default)
        inputStream.open()
        
        // Open output stream for writing
        let outputStream = channel.outputStream
        outputStream.schedule(in: .main, forMode: .default)
        outputStream.open()
        
        print("L2CAP channel established")
    }
}

// MARK: - CBCentralManagerDelegate
extension BluetoothManager: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
        case .poweredOff:
            print("Bluetooth is powered off")
        case .resetting:
            print("Bluetooth is resetting")
        case .unauthorized:
            print("Bluetooth is unauthorized")
        case .unsupported:
            print("Bluetooth is not supported")
        case .unknown:
            print("Bluetooth state is unknown")
        @unknown default:
            print("Unknown Bluetooth state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, 
                       didDiscover peripheral: CBPeripheral,
                       advertisementData: [String: Any],
                       rssi RSSI: NSNumber) {
        
        print("Discovered: \(peripheral.name ?? "Unknown") (\(peripheral.identifier))")
        
        // Add to discovered peripherals if not already present
        if !discoveredPeripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            discoveredPeripherals.append(peripheral)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "Unknown")")
        
        isConnected = true
        connectionState = .connected
        onConnectionStateChanged?(true)
        
        // Stop scanning once connected
        stopScanning()
        
        // Open L2CAP channel
        openL2CAPChannel(peripheral: peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, 
                       didDisconnectPeripheral peripheral: CBPeripheral,
                       error: Error?) {
        print("Disconnected from \(peripheral.name ?? "Unknown")")
        
        if let error = error {
            print("Disconnect error: \(error.localizedDescription)")
            onError?(error)
        }
        
        isConnected = false
        connectionState = .disconnected
        l2capChannel = nil
        onConnectionStateChanged?(false)
    }
    
    func centralManager(_ central: CBCentralManager, 
                       didFailToConnect peripheral: CBPeripheral,
                       error: Error?) {
        print("Failed to connect to \(peripheral.name ?? "Unknown")")
        
        if let error = error {
            print("Connection error: \(error.localizedDescription)")
            onError?(error)
        }
        
        isConnected = false
    }
    
    func centralManager(_ central: CBCentralManager,
                       didOpen channel: CBL2CAPChannel,
                       error: Error?) {
        if let error = error {
            print("Error opening L2CAP channel: \(error.localizedDescription)")
            onError?(error)
            return
        }
        
        print("L2CAP channel opened with PSM: \(channel.psm)")
        setupL2CAPChannel(channel)
    }
}

// MARK: - CBPeripheralDelegate
extension BluetoothManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            return
        }
        
        guard let services = peripheral.services else { return }
        
        for service in services {
            print("Discovered service: \(service.uuid)")
            
            // Discover characteristics
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, 
                   didDiscoverCharacteristicsFor service: CBService,
                   error: Error?) {
        if let error = error {
            print("Error discovering characteristics: \(error.localizedDescription)")
            return
        }
        
        guard let characteristics = service.characteristics else { return }
        
        for characteristic in characteristics {
            print("Discovered characteristic: \(characteristic.uuid)")
            
            // Try to open L2CAP channel if supported
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, 
                   didUpdateValueFor characteristic: CBCharacteristic,
                   error: Error?) {
        if let error = error {
            print("Error updating value: \(error.localizedDescription)")
            return
        }
        
        if let data = characteristic.value {
            print("Received data: \(data.count) bytes")
            onDataReceived?(data)
        }
    }
}

// MARK: - StreamDelegate
extension BluetoothManager: StreamDelegate {
    
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case .openCompleted:
            print("Stream opened")
            
        case .hasSpaceAvailable:
            break // Can write data
            
        case .hasBytesAvailable:
            // Read data from input stream
            if let inputStream = aStream as? InputStream {
                readFromStream(inputStream)
            }
            
        case .errorOccurred:
            if let error = aStream.streamError {
                print("Stream error: \(error.localizedDescription)")
                onError?(error)
            }
            
        case .endEncountered:
            print("Stream end encountered")
            aStream.close()
            
        default:
            break
        }
    }
    
    private func readFromStream(_ stream: InputStream) {
        let bufferSize = 1024
        var buffer = [UInt8](repeating: 0, count: bufferSize)
        
        while stream.hasBytesAvailable {
            let bytesRead = stream.read(&buffer, maxLength: bufferSize)
            
            if bytesRead > 0 {
                let data = Data(buffer[0..<bytesRead])
                print("Read \(bytesRead) bytes from stream")
                onDataReceived?(data)
            } else if bytesRead < 0 {
                print("Error reading from stream")
                break
            }
        }
    }
}
