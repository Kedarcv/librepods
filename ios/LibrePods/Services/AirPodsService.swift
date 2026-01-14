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
import Combine
import CoreBluetooth
import UserNotifications

/// Main service managing AirPods connection and features
class AirPodsService: ObservableObject {
    
    // MARK: - Published Properties
    @Published var airPods: AirPodsInstance?
    @Published var isConnected: Bool = false
    @Published var packetLogs: [PacketLog] = []
    
    // MARK: - Private Properties
    private let bluetoothManager = BluetoothManager()
    private let aacpManager = AACPManager()
    private var cancellables = Set<AnyCancellable>()
    private var heartbeatTimer: Timer?
    
    // MARK: - Initialization
    init() {
        setupBluetoothCallbacks()
        setupAACPCallbacks()
        loadSavedAirPods()
    }
    
    // MARK: - Public Methods
    
    /// Start scanning for AirPods
    func startScanning() {
        bluetoothManager.startScanning()
    }
    
    /// Stop scanning
    func stopScanning() {
        bluetoothManager.stopScanning()
    }
    
    /// Connect to specific AirPods
    func connect(to peripheral: CBPeripheral) {
        bluetoothManager.connect(to: peripheral)
    }
    
    /// Disconnect from AirPods
    func disconnect() {
        bluetoothManager.disconnect()
        isConnected = false
        airPods?.isConnected = false
        stopHeartbeat()
    }
    
    /// Change listening mode
    func setListeningMode(_ mode: NoiseControlMode) {
        let packet = aacpManager.setListeningMode(mode)
        sendPacket(packet)
        airPods?.listeningMode = mode
        logPacket("Set Listening Mode", data: packet, direction: .sent)
    }
    
    /// Toggle conversational awareness
    func setConversationalAwareness(enabled: Bool) {
        let packet = aacpManager.setConversationalAwareness(enabled: enabled)
        sendPacket(packet)
        airPods?.conversationalAwareness = enabled
        logPacket("Set Conversational Awareness", data: packet, direction: .sent)
    }
    
    /// Toggle ear detection
    func setEarDetection(enabled: Bool) {
        let packet = aacpManager.setEarDetection(enabled: enabled)
        sendPacket(packet)
        logPacket("Set Ear Detection", data: packet, direction: .sent)
    }
    
    /// Toggle head gestures
    func setHeadGestures(enabled: Bool) {
        let packet = aacpManager.setHeadGestures(enabled: enabled)
        sendPacket(packet)
        airPods?.headGestures = enabled
        logPacket("Set Head Gestures", data: packet, direction: .sent)
    }
    
    /// Rename AirPods
    func rename(to name: String) {
        let packet = aacpManager.renameDevice(name: name)
        sendPacket(packet)
        airPods?.name = name
        saveAirPods()
        logPacket("Rename Device", data: packet, direction: .sent)
    }
    
    /// Request device information
    func requestDeviceInfo() {
        let packet = aacpManager.requestDeviceInformation()
        sendPacket(packet)
        logPacket("Request Device Info", data: packet, direction: .sent)
    }
    
    /// Request battery status
    func requestBatteryStatus() {
        let packet = aacpManager.requestNotifications()
        sendPacket(packet)
        logPacket("Request Notifications", data: packet, direction: .sent)
    }
    
    // MARK: - Private Methods
    
    private func setupBluetoothCallbacks() {
        bluetoothManager.onDataReceived = { [weak self] data in
            self?.handleReceivedData(data)
        }
        
        bluetoothManager.onConnectionStateChanged = { [weak self] connected in
            self?.handleConnectionStateChange(connected)
        }
        
        bluetoothManager.onError = { error in
            print("Bluetooth error: \(error.localizedDescription)")
        }
    }
    
    private func setupAACPCallbacks() {
        aacpManager.onBatteryInfoReceived = { [weak self] data in
            self?.parseBatteryInfo(data)
        }
        
        aacpManager.onEarDetectionReceived = { [weak self] data in
            self?.parseEarDetection(data)
        }
        
        aacpManager.onConversationAwarenessReceived = { [weak self] data in
            self?.parseConversationalAwareness(data)
        }
        
        aacpManager.onDeviceInformationReceived = { [weak self] info in
            self?.updateDeviceInformation(info)
        }
        
        aacpManager.onHeadTrackingReceived = { [weak self] data in
            self?.parseHeadTracking(data)
        }
        
        aacpManager.onStemPressReceived = { [weak self] pressType, budType in
            self?.handleStemPress(pressType: pressType, budType: budType)
        }
    }
    
    private func handleConnectionStateChange(_ connected: Bool) {
        isConnected = connected
        
        if connected {
            // Request initial status
            requestDeviceInfo()
            requestBatteryStatus()
            
            // Start heartbeat
            startHeartbeat()
            
            // Post notification
            NotificationCenter.default.post(name: .airPodsConnected, object: nil)
            
            // Show system notification
            showNotification(title: "AirPods Connected", body: "Connected to \(airPods?.name ?? "AirPods")")
        } else {
            stopHeartbeat()
            airPods?.isConnected = false
            
            NotificationCenter.default.post(name: .airPodsDisconnected, object: nil)
        }
    }
    
    private func handleReceivedData(_ data: Data) {
        logPacket("Received Packet", data: data, direction: .received)
        aacpManager.parsePacket(data)
    }
    
    private func sendPacket(_ packet: Data) {
        bluetoothManager.sendData(packet)
    }
    
    private func parseBatteryInfo(_ data: Data) {
        guard data.count >= 10 else { return }
        
        // Parse battery levels (simplified)
        let leftBattery = Int(data[7])
        let rightBattery = Int(data[8])
        let caseBattery = Int(data[9])
        
        var batteryStatus = BatteryStatus()
        batteryStatus.left = leftBattery > 0 ? leftBattery : nil
        batteryStatus.right = rightBattery > 0 ? rightBattery : nil
        batteryStatus.case_ = caseBattery > 0 ? caseBattery : nil
        
        airPods?.batteryStatus = batteryStatus
        saveAirPods()
        
        NotificationCenter.default.post(name: .batteryStatusUpdated, object: batteryStatus)
    }
    
    private func parseEarDetection(_ data: Data) {
        guard data.count >= 9 else { return }
        
        let leftInEar = data[7] & 0x01 != 0
        let rightInEar = data[8] & 0x01 != 0
        
        var earStatus = EarDetectionStatus()
        earStatus.leftInEar = leftInEar
        earStatus.rightInEar = rightInEar
        
        airPods?.earDetection = earStatus
        
        NotificationCenter.default.post(name: .earDetectionChanged, object: earStatus)
    }
    
    private func parseConversationalAwareness(_ data: Data) {
        guard data.count >= 8 else { return }
        
        let enabled = data[7] == 0x01
        airPods?.conversationalAwareness = enabled
    }
    
    private func parseHeadTracking(_ data: Data) {
        // Parse head tracking data and detect gestures
        // This would include quaternion data for head orientation
        // and logic to detect nods and shakes
        
        // For now, just log it
        logPacket("Head Tracking Data", data: data, direction: .received)
    }
    
    private func updateDeviceInformation(_ info: AACPManager.AirPodsInformation) {
        airPods?.name = info.name
        airPods?.serialNumber = info.serialNumber
        
        // Try to identify model from model number
        if let model = AirPodsModel.model(for: info.modelNumber) {
            airPods?.model = model
        }
        
        saveAirPods()
    }
    
    private func handleStemPress(pressType: StemPressType, budType: AACPManager.StemPressBudType) {
        print("Stem press detected: \(pressType) on \(budType)")
        
        // Handle stem press action based on configuration
        let action: StemAction
        
        switch budType {
        case .left:
            action = airPods?.leftStemAction ?? .noiseControl
        case .right:
            action = airPods?.rightStemAction ?? .noiseControl
        }
        
        performStemAction(action)
    }
    
    private func performStemAction(_ action: StemAction) {
        switch action {
        case .noiseControl:
            // Cycle through noise control modes
            cycleNoiseControlMode()
        case .siri:
            // Trigger Siri
            triggerSiri()
        case .playPause:
            // Toggle media playback
            toggleMediaPlayback()
        case .nextTrack:
            skipToNextTrack()
        case .previousTrack:
            skipToPreviousTrack()
        case .off:
            break
        }
    }
    
    private func cycleNoiseControlMode() {
        guard let currentMode = airPods?.listeningMode else { return }
        
        let modes: [NoiseControlMode] = [.off, .transparency, .anc]
        if let currentIndex = modes.firstIndex(of: currentMode) {
            let nextIndex = (currentIndex + 1) % modes.count
            setListeningMode(modes[nextIndex])
        }
    }
    
    private func triggerSiri() {
        // iOS doesn't allow triggering Siri programmatically
        // Show notification instead
        showNotification(title: "Siri", body: "Say 'Hey Siri' to activate")
    }
    
    private func toggleMediaPlayback() {
        // Use MPRemoteCommandCenter
        // This is handled by the system, we just send the command
        print("Toggle media playback")
    }
    
    private func skipToNextTrack() {
        print("Skip to next track")
    }
    
    private func skipToPreviousTrack() {
        print("Skip to previous track")
    }
    
    private func startHeartbeat() {
        heartbeatTimer = Timer.scheduledTimer(withTimeInterval: 30.0, repeats: true) { [weak self] _ in
            self?.requestBatteryStatus()
        }
    }
    
    private func stopHeartbeat() {
        heartbeatTimer?.invalidate()
        heartbeatTimer = nil
    }
    
    // MARK: - Persistence
    
    private func loadSavedAirPods() {
        guard let data = UserDefaults.standard.data(forKey: "saved_airpods") else {
            return
        }
        
        do {
            airPods = try JSONDecoder().decode(AirPodsInstance.self, from: data)
        } catch {
            print("Error loading saved AirPods: \(error)")
        }
    }
    
    private func saveAirPods() {
        guard let airPods = airPods else { return }
        
        do {
            let data = try JSONEncoder().encode(airPods)
            UserDefaults.standard.set(data, forKey: "saved_airpods")
        } catch {
            print("Error saving AirPods: \(error)")
        }
    }
    
    // MARK: - Packet Logging
    
    struct PacketLog: Identifiable {
        let id = UUID()
        let timestamp: Date
        let description: String
        let data: Data
        let direction: Direction
        
        enum Direction {
            case sent, received
        }
        
        var hexString: String {
            data.map { String(format: "%02X", $0) }.joined(separator: " ")
        }
    }
    
    private func logPacket(_ description: String, data: Data, direction: PacketLog.Direction) {
        let log = PacketLog(timestamp: Date(), description: description, data: data, direction: direction)
        packetLogs.append(log)
        
        // Keep only last 100 logs
        if packetLogs.count > 100 {
            packetLogs.removeFirst(packetLogs.count - 100)
        }
    }
    
    // MARK: - Notifications
    
    private func showNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error showing notification: \(error)")
            }
        }
    }
}
