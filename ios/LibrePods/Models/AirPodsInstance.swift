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

// MARK: - AirPods Instance
class AirPodsInstance: ObservableObject, Codable {
    @Published var macAddress: String
    @Published var name: String
    @Published var model: AirPodsModel?
    @Published var batteryStatus: BatteryStatus
    @Published var listeningMode: NoiseControlMode
    @Published var earDetection: EarDetectionStatus
    @Published var isConnected: Bool
    @Published var conversationalAwareness: Bool
    @Published var adaptiveAudio: Bool
    @Published var headGestures: Bool
    @Published var spatialAudio: Bool
    @Published var loudSoundReduction: Bool
    @Published var leftStemAction: StemAction
    @Published var rightStemAction: StemAction
    @Published var longPressAction: StemAction
    @Published var serialNumber: String?
    @Published var firmwareVersion: String?
    
    // Head tracking
    @Published var headTrackingEnabled: Bool = false
    @Published var lastHeadGesture: HeadGesture = .none
    
    // Hearing aid features
    @Published var hearingAidEnabled: Bool = false
    @Published var hearingAidAudiogramData: Data?
    
    // Transparency customization
    @Published var transparencyAmplification: Double = 0.5
    @Published var transparencyBalance: Double = 0.5
    @Published var transparencyTone: Double = 0.5
    @Published var conversationBoost: Bool = false
    @Published var ambientNoiseReduction: Bool = false
    
    // Camera control
    @Published var cameraControlEnabled: Bool = false
    
    init(macAddress: String, name: String = "AirPods") {
        self.macAddress = macAddress
        self.name = name
        self.model = nil
        self.batteryStatus = BatteryStatus()
        self.listeningMode = .off
        self.earDetection = EarDetectionStatus()
        self.isConnected = false
        self.conversationalAwareness = false
        self.adaptiveAudio = false
        self.headGestures = false
        self.spatialAudio = false
        self.loudSoundReduction = false
        self.leftStemAction = .noiseControl
        self.rightStemAction = .noiseControl
        self.longPressAction = .siri
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case macAddress, name, model, batteryStatus, listeningMode
        case earDetection, isConnected, conversationalAwareness
        case adaptiveAudio, headGestures, spatialAudio
        case loudSoundReduction, leftStemAction, rightStemAction
        case longPressAction, serialNumber, firmwareVersion
        case headTrackingEnabled, hearingAidEnabled
        case hearingAidAudiogramData, transparencyAmplification
        case transparencyBalance, transparencyTone
        case conversationBoost, ambientNoiseReduction
        case cameraControlEnabled
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        macAddress = try container.decode(String.self, forKey: .macAddress)
        name = try container.decode(String.self, forKey: .name)
        model = try container.decodeIfPresent(AirPodsModel.self, forKey: .model)
        batteryStatus = try container.decode(BatteryStatus.self, forKey: .batteryStatus)
        listeningMode = try container.decode(NoiseControlMode.self, forKey: .listeningMode)
        earDetection = try container.decode(EarDetectionStatus.self, forKey: .earDetection)
        isConnected = try container.decode(Bool.self, forKey: .isConnected)
        conversationalAwareness = try container.decode(Bool.self, forKey: .conversationalAwareness)
        adaptiveAudio = try container.decode(Bool.self, forKey: .adaptiveAudio)
        headGestures = try container.decode(Bool.self, forKey: .headGestures)
        spatialAudio = try container.decode(Bool.self, forKey: .spatialAudio)
        loudSoundReduction = try container.decode(Bool.self, forKey: .loudSoundReduction)
        leftStemAction = try container.decode(StemAction.self, forKey: .leftStemAction)
        rightStemAction = try container.decode(StemAction.self, forKey: .rightStemAction)
        longPressAction = try container.decode(StemAction.self, forKey: .longPressAction)
        serialNumber = try container.decodeIfPresent(String.self, forKey: .serialNumber)
        firmwareVersion = try container.decodeIfPresent(String.self, forKey: .firmwareVersion)
        headTrackingEnabled = try container.decodeIfPresent(Bool.self, forKey: .headTrackingEnabled) ?? false
        hearingAidEnabled = try container.decodeIfPresent(Bool.self, forKey: .hearingAidEnabled) ?? false
        hearingAidAudiogramData = try container.decodeIfPresent(Data.self, forKey: .hearingAidAudiogramData)
        transparencyAmplification = try container.decodeIfPresent(Double.self, forKey: .transparencyAmplification) ?? 0.5
        transparencyBalance = try container.decodeIfPresent(Double.self, forKey: .transparencyBalance) ?? 0.5
        transparencyTone = try container.decodeIfPresent(Double.self, forKey: .transparencyTone) ?? 0.5
        conversationBoost = try container.decodeIfPresent(Bool.self, forKey: .conversationBoost) ?? false
        ambientNoiseReduction = try container.decodeIfPresent(Bool.self, forKey: .ambientNoiseReduction) ?? false
        cameraControlEnabled = try container.decodeIfPresent(Bool.self, forKey: .cameraControlEnabled) ?? false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(macAddress, forKey: .macAddress)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(model, forKey: .model)
        try container.encode(batteryStatus, forKey: .batteryStatus)
        try container.encode(listeningMode, forKey: .listeningMode)
        try container.encode(earDetection, forKey: .earDetection)
        try container.encode(isConnected, forKey: .isConnected)
        try container.encode(conversationalAwareness, forKey: .conversationalAwareness)
        try container.encode(adaptiveAudio, forKey: .adaptiveAudio)
        try container.encode(headGestures, forKey: .headGestures)
        try container.encode(spatialAudio, forKey: .spatialAudio)
        try container.encode(loudSoundReduction, forKey: .loudSoundReduction)
        try container.encode(leftStemAction, forKey: .leftStemAction)
        try container.encode(rightStemAction, forKey: .rightStemAction)
        try container.encode(longPressAction, forKey: .longPressAction)
        try container.encodeIfPresent(serialNumber, forKey: .serialNumber)
        try container.encodeIfPresent(firmwareVersion, forKey: .firmwareVersion)
        try container.encode(headTrackingEnabled, forKey: .headTrackingEnabled)
        try container.encode(hearingAidEnabled, forKey: .hearingAidEnabled)
        try container.encodeIfPresent(hearingAidAudiogramData, forKey: .hearingAidAudiogramData)
        try container.encode(transparencyAmplification, forKey: .transparencyAmplification)
        try container.encode(transparencyBalance, forKey: .transparencyBalance)
        try container.encode(transparencyTone, forKey: .transparencyTone)
        try container.encode(conversationBoost, forKey: .conversationBoost)
        try container.encode(ambientNoiseReduction, forKey: .ambientNoiseReduction)
        try container.encode(cameraControlEnabled, forKey: .cameraControlEnabled)
    }
}
