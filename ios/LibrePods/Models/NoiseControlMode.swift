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

// MARK: - Noise Control Mode
enum NoiseControlMode: String, Codable, CaseIterable {
    case off = "Off"
    case transparency = "Transparency"
    case adaptive = "Adaptive"
    case anc = "ANC"
    
    var displayName: String {
        switch self {
        case .off:
            return "Off"
        case .transparency:
            return "Transparency"
        case .adaptive:
            return "Adaptive"
        case .anc:
            return "Noise Cancellation"
        }
    }
    
    var byteValue: UInt8 {
        switch self {
        case .off:
            return 0x01
        case .transparency:
            return 0x02
        case .adaptive:
            return 0x03
        case .anc:
            return 0x04
        }
    }
    
    static func from(byte: UInt8) -> NoiseControlMode? {
        switch byte {
        case 0x01:
            return .off
        case 0x02:
            return .transparency
        case 0x03:
            return .adaptive
        case 0x04:
            return .anc
        default:
            return nil
        }
    }
}

// MARK: - Battery Component
enum BatteryComponent: String, Codable {
    case left = "left"
    case right = "right"
    case case_ = "case"
}

// MARK: - Battery Status
struct BatteryStatus: Codable, Equatable {
    var left: Int?
    var right: Int?
    var case_: Int?
    var leftCharging: Bool = false
    var rightCharging: Bool = false
    var caseCharging: Bool = false
    
    var isAnyBudConnected: Bool {
        return left != nil || right != nil
    }
    
    var lowestBatteryPercentage: Int? {
        let levels = [left, right].compactMap { $0 }
        return levels.isEmpty ? nil : levels.min()
    }
    
    static func == (lhs: BatteryStatus, rhs: BatteryStatus) -> Bool {
        return lhs.left == rhs.left &&
               lhs.right == rhs.right &&
               lhs.case_ == rhs.case_ &&
               lhs.leftCharging == rhs.leftCharging &&
               lhs.rightCharging == rhs.rightCharging &&
               lhs.caseCharging == rhs.caseCharging
    }
}

// MARK: - Ear Detection Status
struct EarDetectionStatus: Codable, Equatable {
    var leftInEar: Bool = false
    var rightInEar: Bool = false
    
    var anyInEar: Bool {
        return leftInEar || rightInEar
    }
    
    var bothInEar: Bool {
        return leftInEar && rightInEar
    }
}

// MARK: - Stem Action
enum StemAction: String, Codable, CaseIterable {
    case noiseControl = "noise_control"
    case siri = "siri"
    case playPause = "play_pause"
    case nextTrack = "next_track"
    case previousTrack = "previous_track"
    case off = "off"
    
    var displayName: String {
        switch self {
        case .noiseControl:
            return "Noise Control"
        case .siri:
            return "Siri"
        case .playPause:
            return "Play/Pause"
        case .nextTrack:
            return "Next Track"
        case .previousTrack:
            return "Previous Track"
        case .off:
            return "Off"
        }
    }
    
    var byteValue: UInt8 {
        switch self {
        case .noiseControl:
            return 0x01
        case .siri:
            return 0x02
        case .playPause:
            return 0x03
        case .nextTrack:
            return 0x04
        case .previousTrack:
            return 0x05
        case .off:
            return 0x00
        }
    }
}

// MARK: - Head Gesture
enum HeadGesture: String, Codable {
    case nod
    case shake
    case none
    
    var displayName: String {
        switch self {
        case .nod:
            return "Nod (Accept)"
        case .shake:
            return "Shake (Decline)"
        case .none:
            return "None"
        }
    }
}

// MARK: - Stem Press Type
enum StemPressType: String, Codable {
    case single = "single"
    case double = "double"
    case long = "long"
}
