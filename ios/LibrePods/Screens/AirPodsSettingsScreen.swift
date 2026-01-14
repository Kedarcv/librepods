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

import SwiftUI

struct AirPodsSettingsScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    @State private var showingDisconnectAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Battery View
                if let airPods = airPodsService.airPods {
                    BatteryView(batteryStatus: airPods.batteryStatus, model: airPods.model)
                        .padding()
                }
                
                // Noise Control Settings
                NoiseControlCard()
                
                // Audio Settings
                AudioSettingsCard()
                
                // Hearing Health Settings
                if let airPods = airPodsService.airPods,
                   airPods.model?.hasCapability(.hearingAid) == true {
                    HearingHealthCard()
                }
                
                // Stem Action Settings
                if let airPods = airPodsService.airPods,
                   airPods.model?.hasCapability(.stemConfig) == true {
                    StemActionCard()
                }
                
                // Microphone & Call Settings
                MicrophoneCard()
                
                // Connection Settings
                ConnectionCard()
                
                // About
                AboutCard()
                
                // Disconnect Button
                Button(action: {
                    showingDisconnectAlert = true
                }) {
                    Text("Disconnect")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                .alert("Disconnect AirPods?", isPresented: $showingDisconnectAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Disconnect", role: .destructive) {
                        airPodsService.disconnect()
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationTitle(airPodsService.airPods?.name ?? "AirPods")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AppSettingsScreen()) {
                    Image(systemName: "gearshape")
                }
            }
        }
    }
}

// MARK: - Noise Control Card
struct NoiseControlCard: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    
    var body: some View {
        CardView(title: "Noise Control") {
            VStack(spacing: 15) {
                Picker("Mode", selection: Binding(
                    get: { airPodsService.airPods?.listeningMode ?? .off },
                    set: { airPodsService.setListeningMode($0) }
                )) {
                    ForEach(NoiseControlMode.allCases, id: \.self) { mode in
                        Text(mode.displayName).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                
                if let airPods = airPodsService.airPods,
                   airPods.model?.hasCapability(.conversationalAwareness) == true {
                    Toggle("Conversational Awareness", isOn: Binding(
                        get: { airPods.conversationalAwareness },
                        set: { airPodsService.setConversationalAwareness(enabled: $0) }
                    ))
                }
                
                NavigationLink(destination: TransparencySettingsScreen()) {
                    HStack {
                        Text("Customize Transparency")
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - Audio Settings Card
struct AudioSettingsCard: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    
    var body: some View {
        CardView(title: "Audio Settings") {
            VStack(spacing: 15) {
                Toggle("Spatial Audio", isOn: Binding(
                    get: { airPodsService.airPods?.spatialAudio ?? false },
                    set: { airPodsService.airPods?.spatialAudio = $0 }
                ))
                
                if let airPods = airPodsService.airPods,
                   airPods.model?.hasCapability(.adaptiveAudio) == true {
                    Toggle("Adaptive Audio", isOn: Binding(
                        get: { airPods.adaptiveAudio },
                        set: { airPodsService.airPods?.adaptiveAudio = $0 }
                    ))
                }
            }
        }
    }
}

// MARK: - Hearing Health Card
struct HearingHealthCard: View {
    
    var body: some View {
        CardView(title: "Hearing Health") {
            VStack(spacing: 10) {
                NavigationLink(destination: HearingAidScreen()) {
                    SettingRow(icon: "ear.fill", title: "Hearing Aid", subtitle: "Configure hearing aid features")
                }
                
                NavigationLink(destination: HearingProtectionScreen()) {
                    SettingRow(icon: "speaker.wave.3.fill", title: "Hearing Protection", subtitle: "Loud sound reduction")
                }
                
                NavigationLink(destination: UpdateHearingTestScreen()) {
                    SettingRow(icon: "waveform.path.ecg", title: "Update Audiogram", subtitle: "Enter hearing test results")
                }
            }
        }
    }
}

// MARK: - Stem Action Card
struct StemActionCard: View {
    
    var body: some View {
        CardView(title: "Press and Hold") {
            NavigationLink(destination: LongPressScreen()) {
                HStack {
                    Text("Customize Stem Actions")
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - Microphone Card
struct MicrophoneCard: View {
    
    var body: some View {
        CardView(title: "Microphone & Calls") {
            VStack(spacing: 15) {
                Toggle("Head Gestures", isOn: .constant(false))
                
                Text("Use head gestures to answer or decline calls")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

// MARK: - Connection Card
struct ConnectionCard: View {
    
    var body: some View {
        CardView(title: "Connection") {
            VStack(spacing: 10) {
                Toggle("Automatic Ear Detection", isOn: .constant(true))
                
                NavigationLink(destination: RenameScreen()) {
                    SettingRow(icon: "pencil", title: "Rename", subtitle: "Change AirPods name")
                }
            }
        }
    }
}

// MARK: - About Card
struct AboutCard: View {
    
    var body: some View {
        CardView(title: "About") {
            VStack(spacing: 10) {
                NavigationLink(destination: VersionInfoScreen()) {
                    SettingRow(icon: "info.circle", title: "Version", subtitle: AppVersion.fullVersion)
                }
                
                NavigationLink(destination: DebugScreen()) {
                    SettingRow(icon: "ladybug", title: "Debug", subtitle: "View packet logs")
                }
                
                NavigationLink(destination: TroubleshootingScreen()) {
                    SettingRow(icon: "wrench.and.screwdriver", title: "Troubleshooting", subtitle: "Diagnostic tools")
                }
            }
        }
    }
}

// MARK: - Helper Views
struct CardView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                content
                    .padding()
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding(.horizontal)
    }
}

struct SettingRow: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview
struct AirPodsSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AirPodsSettingsScreen()
                .environmentObject(AirPodsService())
        }
    }
}
