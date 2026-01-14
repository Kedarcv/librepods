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

/// Manager class for Apple Accessory Communication Protocol (AACP)
/// Handles L2CAP socket management, packet construction and parsing for AirPods communication
class AACPManager {
    
    // MARK: - Properties
    private let headerBytes: [UInt8] = [0x04, 0x00, 0x04, 0x00]
    
    var controlCommandStatusList: [ControlCommandStatus] = []
    var owns: Bool = false
    var connectedDevices: [ConnectedDevice] = []
    var audioSource: AudioSource?
    var eqData: [Float] = Array(repeating: 0.0, count: 8)
    
    // Callbacks
    var onBatteryInfoReceived: ((Data) -> Void)?
    var onEarDetectionReceived: ((Data) -> Void)?
    var onConversationAwarenessReceived: ((Data) -> Void)?
    var onControlCommandReceived: ((Data) -> Void)?
    var onDeviceInformationReceived: ((AirPodsInformation) -> Void)?
    var onHeadTrackingReceived: ((Data) -> Void)?
    var onStemPressReceived: ((StemPressType, StemPressBudType) -> Void)?
    var onConnectedDevicesReceived: (([ConnectedDevice]) -> Void)?
    
    // MARK: - Data Structures
    
    struct ControlCommandStatus: Equatable {
        let identifier: ControlCommandIdentifier
        let value: Data
        
        static func == (lhs: ControlCommandStatus, rhs: ControlCommandStatus) -> Bool {
            return lhs.identifier == rhs.identifier && lhs.value == rhs.value
        }
    }
    
    struct ConnectedDevice {
        let mac: String
        let info1: UInt8
        let info2: UInt8
        var type: String?
    }
    
    struct AudioSource {
        let mac: String
        let type: AudioSourceType
    }
    
    enum AudioSourceType: UInt8 {
        case none = 0x00
        case call = 0x01
        case media = 0x02
    }
    
    struct AirPodsInformation {
        let name: String
        let modelNumber: String
        let manufacturer: String
        let serialNumber: String
        let version1: String
        let version2: String
        let hardwareRevision: String
        let updaterIdentifier: String
        let leftSerialNumber: String
        let rightSerialNumber: String
        let version3: String
    }
    
    enum StemPressBudType: UInt8 {
        case left = 0x01
        case right = 0x02
    }
    
    // MARK: - Packet Construction
    
    /// Creates a packet with the given opcode and data
    func createPacket(opcode: UInt8, data: [UInt8] = []) -> Data {
        var packet = Data()
        
        // Add header
        packet.append(contentsOf: headerBytes)
        
        // Add opcode
        packet.append(opcode)
        
        // Add length
        let length = UInt16(data.count + 1) // +1 for opcode
        var lengthBigEndian = length.bigEndian
        packet.append(Data(bytes: &lengthBigEndian, count: 2))
        
        // Add data
        if !data.isEmpty {
            packet.append(contentsOf: data)
        }
        
        return packet
    }
    
    /// Request notifications from AirPods
    func requestNotifications() -> Data {
        return createPacket(opcode: AACPOpcodes.requestNotifications)
    }
    
    /// Set listening mode (noise control)
    func setListeningMode(_ mode: NoiseControlMode) -> Data {
        let data: [UInt8] = [
            ControlCommandIdentifier.listeningMode.rawValue,
            0x01, // length
            mode.byteValue
        ]
        return createPacket(opcode: AACPOpcodes.controlCommand, data: data)
    }
    
    /// Set conversational awareness
    func setConversationalAwareness(enabled: Bool) -> Data {
        let data: [UInt8] = [
            ControlCommandIdentifier.conversationalAwareness.rawValue,
            0x01,
            enabled ? 0x01 : 0x00
        ]
        return createPacket(opcode: AACPOpcodes.controlCommand, data: data)
    }
    
    /// Set ear detection
    func setEarDetection(enabled: Bool) -> Data {
        let data: [UInt8] = [
            ControlCommandIdentifier.earDetectionConfig.rawValue,
            0x01,
            enabled ? 0x01 : 0x00
        ]
        return createPacket(opcode: AACPOpcodes.controlCommand, data: data)
    }
    
    /// Set head gestures
    func setHeadGestures(enabled: Bool) -> Data {
        let data: [UInt8] = [
            ControlCommandIdentifier.headDetection.rawValue,
            0x01,
            enabled ? 0x01 : 0x00
        ]
        return createPacket(opcode: AACPOpcodes.controlCommand, data: data)
    }
    
    /// Request device information
    func requestDeviceInformation() -> Data {
        return createPacket(opcode: AACPOpcodes.information)
    }
    
    /// Rename AirPods
    func renameDevice(name: String) -> Data {
        guard let nameData = name.data(using: .utf8) else {
            return Data()
        }
        var data = [UInt8](nameData)
        return createPacket(opcode: AACPOpcodes.rename, data: data)
    }
    
    /// Set stem press action
    func setStemPressAction(bud: StemPressBudType, pressType: StemPressType, action: StemAction) -> Data {
        var identifier: ControlCommandIdentifier
        
        switch pressType {
        case .single:
            identifier = .singleClickMode
        case .double:
            identifier = .doubleClickMode
        case .long:
            identifier = .clickHoldMode
        }
        
        let data: [UInt8] = [
            identifier.rawValue,
            0x02,
            bud.rawValue,
            action.byteValue
        ]
        return createPacket(opcode: AACPOpcodes.controlCommand, data: data)
    }
    
    // MARK: - Packet Parsing
    
    /// Parse incoming packet from AirPods
    func parsePacket(_ packet: Data) {
        guard packet.count >= 7 else {
            return
        }
        
        // Skip header (4 bytes)
        let opcode = packet[4]
        
        switch opcode {
        case AACPOpcodes.batteryInfo:
            onBatteryInfoReceived?(packet)
            
        case AACPOpcodes.earDetection:
            onEarDetectionReceived?(packet)
            
        case AACPOpcodes.conversationalAwareness:
            onConversationAwarenessReceived?(packet)
            
        case AACPOpcodes.controlCommand:
            parseControlCommand(packet)
            onControlCommandReceived?(packet)
            
        case AACPOpcodes.information:
            parseDeviceInformation(packet)
            
        case AACPOpcodes.headTracking:
            onHeadTrackingReceived?(packet)
            
        case AACPOpcodes.stemPress:
            parseStemPress(packet)
            
        case AACPOpcodes.connectedDevices:
            parseConnectedDevices(packet)
            
        case AACPOpcodes.audioSource:
            parseAudioSource(packet)
            
        default:
            break
        }
    }
    
    private func parseControlCommand(_ packet: Data) {
        guard packet.count >= 8 else { return }
        
        let identifierByte = packet[7]
        guard let identifier = ControlCommandIdentifier(rawValue: identifierByte) else {
            return
        }
        
        let valueLength = Int(packet[8])
        guard packet.count >= 9 + valueLength else { return }
        
        let value = packet.subdata(in: 9..<(9 + valueLength))
        
        let status = ControlCommandStatus(identifier: identifier, value: value)
        
        // Remove existing status with same identifier
        controlCommandStatusList.removeAll { $0.identifier == identifier }
        controlCommandStatusList.append(status)
        
        // Handle ownership
        if identifier == .ownsConnection {
            owns = !value.isEmpty && value[0] == 0x01
        }
    }
    
    private func parseDeviceInformation(_ packet: Data) {
        // Parse device information packet
        // This is a simplified version - full implementation would parse all fields
        guard packet.count > 20 else { return }
        
        // Extract information from packet
        // Full implementation would parse name, model, serial numbers, etc.
        let info = AirPodsInformation(
            name: "AirPods",
            modelNumber: "Unknown",
            manufacturer: "Apple Inc.",
            serialNumber: "Unknown",
            version1: "Unknown",
            version2: "Unknown",
            hardwareRevision: "Unknown",
            updaterIdentifier: "Unknown",
            leftSerialNumber: "Unknown",
            rightSerialNumber: "Unknown",
            version3: "Unknown"
        )
        
        onDeviceInformationReceived?(info)
    }
    
    private func parseStemPress(_ packet: Data) {
        guard packet.count >= 8 else { return }
        
        if let pressType = StemPressType(rawValue: packet[6]),
           let budType = StemPressBudType(rawValue: packet[7]) {
            onStemPressReceived?(pressType, budType)
        }
    }
    
    private func parseConnectedDevices(_ packet: Data) {
        // Parse connected devices list
        var devices: [ConnectedDevice] = []
        
        // Simplified parsing - full implementation would parse all device entries
        connectedDevices = devices
        onConnectedDevicesReceived?(devices)
    }
    
    private func parseAudioSource(_ packet: Data) {
        guard packet.count >= 13 else { return }
        
        // Parse MAC address
        let macBytes = packet.subdata(in: 7..<13)
        let mac = macBytes.map { String(format: "%02X", $0) }.joined(separator: ":")
        
        // Parse source type
        let typeByte = packet[13]
        let sourceType = AudioSourceType(rawValue: typeByte) ?? .none
        
        audioSource = AudioSource(mac: mac, type: sourceType)
    }
    
    // MARK: - Helper Methods
    
    func getControlCommandStatus(identifier: ControlCommandIdentifier) -> ControlCommandStatus? {
        return controlCommandStatusList.first { $0.identifier == identifier }
    }
}
