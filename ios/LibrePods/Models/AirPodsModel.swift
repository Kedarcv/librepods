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

// MARK: - AirPods Capability
enum AirPodsCapability: String, Codable {
    case listeningMode = "LISTENING_MODE"
    case conversationalAwareness = "CONVERSATION_AWARENESS"
    case stemConfig = "STEM_CONFIG"
    case headGestures = "HEAD_GESTURES"
    case loudSoundReduction = "LOUD_SOUND_REDUCTION"
    case ppe = "PPE"
    case sleepDetection = "SLEEP_DETECTION"
    case hearingAid = "HEARING_AID"
    case adaptiveAudio = "ADAPTIVE_AUDIO"
    case adaptiveVolume = "ADAPTIVE_VOLUME"
    case swipeForVolume = "SWIPE_FOR_VOLUME"
    case hrm = "HRM"
}

// MARK: - AirPods Model Base
protocol AirPodsModelProtocol {
    var modelNumbers: [String] { get }
    var name: String { get }
    var displayName: String { get }
    var manufacturer: String { get }
    var capabilities: Set<AirPodsCapability> { get }
    var imageName: String { get }
}

// MARK: - AirPods Model Definitions
struct AirPodsModel: AirPodsModelProtocol, Codable, Equatable {
    let modelNumbers: [String]
    let name: String
    let displayName: String
    let manufacturer: String
    let capabilities: Set<AirPodsCapability>
    let imageName: String
    
    init(modelNumbers: [String], 
         name: String, 
         displayName: String = "AirPods",
         manufacturer: String = "Apple Inc.",
         capabilities: Set<AirPodsCapability> = [],
         imageName: String) {
        self.modelNumbers = modelNumbers
        self.name = name
        self.displayName = displayName
        self.manufacturer = manufacturer
        self.capabilities = capabilities
        self.imageName = imageName
    }
    
    // MARK: - Predefined Models
    static let airPods1 = AirPodsModel(
        modelNumbers: ["A1523", "A1722"],
        name: "AirPods 1",
        capabilities: [],
        imageName: "airpods_1"
    )
    
    static let airPods2 = AirPodsModel(
        modelNumbers: ["A2032", "A2031"],
        name: "AirPods 2",
        capabilities: [],
        imageName: "airpods_2"
    )
    
    static let airPods3 = AirPodsModel(
        modelNumbers: ["A2565", "A2564"],
        name: "AirPods 3",
        capabilities: [.headGestures],
        imageName: "airpods_3"
    )
    
    static let airPods4 = AirPodsModel(
        modelNumbers: ["A3053", "A3050", "A3054"],
        name: "AirPods 4",
        capabilities: [.headGestures, .sleepDetection, .adaptiveVolume],
        imageName: "airpods_4"
    )
    
    static let airPodsPro = AirPodsModel(
        modelNumbers: ["A2083", "A2084"],
        name: "AirPods Pro",
        capabilities: [.listeningMode, .stemConfig, .headGestures],
        imageName: "airpods_pro"
    )
    
    static let airPodsPro2 = AirPodsModel(
        modelNumbers: ["A2698", "A2699", "A2700"],
        name: "AirPods Pro 2",
        capabilities: [
            .listeningMode, .conversationalAwareness, .stemConfig,
            .headGestures, .loudSoundReduction, .hearingAid,
            .adaptiveAudio, .adaptiveVolume
        ],
        imageName: "airpods_pro_2"
    )
    
    static let airPodsPro3 = AirPodsModel(
        modelNumbers: ["A3600", "A3601", "A3602"],
        name: "AirPods Pro 3",
        capabilities: [
            .listeningMode, .conversationalAwareness, .stemConfig,
            .headGestures, .loudSoundReduction, .hearingAid,
            .adaptiveAudio, .adaptiveVolume
        ],
        imageName: "airpods_pro_3"
    )
    
    static let airPodsMax = AirPodsModel(
        modelNumbers: ["A2096"],
        name: "AirPods Max",
        capabilities: [.listeningMode, .conversationalAwareness, .adaptiveAudio],
        imageName: "airpods_max"
    )
    
    static let allModels: [AirPodsModel] = [
        airPods1, airPods2, airPods3, airPods4,
        airPodsPro, airPodsPro2, airPodsPro3, airPodsMax
    ]
    
    static func model(for modelNumber: String) -> AirPodsModel? {
        return allModels.first { model in
            model.modelNumbers.contains(modelNumber)
        }
    }
    
    func hasCapability(_ capability: AirPodsCapability) -> Bool {
        return capabilities.contains(capability)
    }
}
