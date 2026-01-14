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

// MARK: - Bluetooth Constants
struct BluetoothConstants {
    /// L2CAP PSM UUID for AirPods communication
    static let l2capPSMUUID = CBUUID(string: "74ec2172-0bad-4d01-8f77-997b2be0722a")
    
    /// Service UUIDs
    static let airPodsServiceUUID = CBUUID(string: "74ec2172-0bad-4d01-8f77-997b2be0722a")
}

// MARK: - AACP Opcodes
struct AACPOpcodes {
    static let setFeatureFlags: UInt8 = 0x4D
    static let requestNotifications: UInt8 = 0x0F
    static let batteryInfo: UInt8 = 0x04
    static let controlCommand: UInt8 = 0x09
    static let earDetection: UInt8 = 0x06
    static let conversationalAwareness: UInt8 = 0x4B
    static let information: UInt8 = 0x1D
    static let rename: UInt8 = 0x1E
    static let headTracking: UInt8 = 0x17
    static let proximityKeysReq: UInt8 = 0x30
    static let proximityKeysRsp: UInt8 = 0x31
    static let stemPress: UInt8 = 0x19
    static let eqData: UInt8 = 0x53
    static let connectedDevices: UInt8 = 0x2E
    static let audioSource: UInt8 = 0x0E
    static let smartRouting: UInt8 = 0x10
    static let tipi3: UInt8 = 0x0C
    static let smartRoutingResp: UInt8 = 0x11
    static let sendConnectedMAC: UInt8 = 0x14
}

// MARK: - Control Command Identifiers
enum ControlCommandIdentifier: UInt8 {
    case micMode = 0x01
    case buttonSendMode = 0x05
    case voiceTrigger = 0x12
    case singleClickMode = 0x14
    case doubleClickMode = 0x15
    case clickHoldMode = 0x16
    case doubleClickInterval = 0x17
    case clickHoldInterval = 0x18
    case listeningModeConfigs = 0x1A
    case oneBudANCMode = 0x1B
    case crownRotationDirection = 0x1C
    case listeningMode = 0x0D
    case autoAnswerMode = 0x1E
    case chimeVolume = 0x1F
    case conversationalAwareness = 0x20
    case transparencyCustomization = 0x21
    case adaptiveStrength = 0x22
    case hearingAid = 0x23
    case loudSoundReduction = 0x24
    case headGestures = 0x25
    case pressSpeed = 0x26
    case spatialAudio = 0x27
    case headDetection = 0x28
    case cameraControlGlobal = 0x29
}

// MARK: - App Settings Keys
struct SettingsKeys {
    static let connectedAirPodsMAC = "connected_airpods_mac"
    static let lastKnownBattery = "last_known_battery"
    static let deviceName = "device_name"
    static let listeningMode = "listening_mode"
    static let conversationalAwareness = "conversational_awareness"
    static let adaptiveAudio = "adaptive_audio"
    static let earDetection = "ear_detection"
    static let headGestures = "head_gestures"
    static let spatialAudio = "spatial_audio"
    static let loudSoundReduction = "loud_sound_reduction"
}

// MARK: - Notification Names
extension Notification.Name {
    static let airPodsConnected = Notification.Name("airPodsConnected")
    static let airPodsDisconnected = Notification.Name("airPodsDisconnected")
    static let batteryStatusUpdated = Notification.Name("batteryStatusUpdated")
    static let listeningModeChanged = Notification.Name("listeningModeChanged")
    static let earDetectionChanged = Notification.Name("earDetectionChanged")
    static let headGestureDetected = Notification.Name("headGestureDetected")
}

// MARK: - App Version
struct AppVersion {
    static let version = "1.0.0"
    static let build = "1"
    static let fullVersion = "\(version) (\(build))"
}
