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

struct AccessibilitySettingsScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    
    var body: some View {
        Form {
            Section {
                NavigationLink(destination: TransparencySettingsScreen()) {
                    SettingRow(
                        icon: "ear.fill",
                        title: "Transparency Mode",
                        subtitle: "Customize amplification and balance"
                    )
                }
                
                NavigationLink(destination: HearingAidScreen()) {
                    SettingRow(
                        icon: "waveform.path.ecg",
                        title: "Hearing Aid",
                        subtitle: "Personalized audio based on audiogram"
                    )
                }
                
                NavigationLink(destination: HearingProtectionScreen()) {
                    SettingRow(
                        icon: "speaker.wave.3.fill",
                        title: "Hearing Protection",
                        subtitle: "Loud sound reduction"
                    )
                }
            } header: {
                Text("Hearing Features")
            }
            
            Section {
                Toggle("Head Gestures", isOn: Binding(
                    get: { airPodsService.airPods?.headGestures ?? false },
                    set: { airPodsService.setHeadGestures(enabled: $0) }
                ))
                
                NavigationLink(destination: HeadTrackingScreen()) {
                    SettingRow(
                        icon: "figure.walk",
                        title: "Head Tracking",
                        subtitle: "View head orientation"
                    )
                }
            } header: {
                Text("Motion & Gestures")
            } footer: {
                Text("Use head gestures to answer or decline calls. Nod to accept, shake to decline.")
            }
        }
        .navigationTitle("Accessibility")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct AccessibilitySettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AccessibilitySettingsScreen()
                .environmentObject(AirPodsService())
        }
    }
}
