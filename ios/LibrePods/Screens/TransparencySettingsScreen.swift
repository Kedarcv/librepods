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

struct TransparencySettingsScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    
    var body: some View {
        Form {
            Section {
                Toggle("Enable Transparency Mode", isOn: Binding(
                    get: { airPodsService.airPods?.listeningMode == .transparency },
                    set: { if $0 { airPodsService.setListeningMode(.transparency) } }
                ))
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Amplification")
                    Slider(value: Binding(
                        get: { airPodsService.airPods?.transparencyAmplification ?? 0.5 },
                        set: { airPodsService.airPods?.transparencyAmplification = $0 }
                    ), in: 0...1)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Balance")
                    Slider(value: Binding(
                        get: { airPodsService.airPods?.transparencyBalance ?? 0.5 },
                        set: { airPodsService.airPods?.transparencyBalance = $0 }
                    ), in: 0...1)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Tone")
                    Slider(value: Binding(
                        get: { airPodsService.airPods?.transparencyTone ?? 0.5 },
                        set: { airPodsService.airPods?.transparencyTone = $0 }
                    ), in: 0...1)
                }
            } header: {
                Text("Transparency Customization")
            } footer: {
                Text("Adjust how much outside sound is amplified in Transparency mode.")
            }
            
            Section {
                Toggle("Conversation Boost", isOn: Binding(
                    get: { airPodsService.airPods?.conversationBoost ?? false },
                    set: { airPodsService.airPods?.conversationBoost = $0 }
                ))
                
                Toggle("Ambient Noise Reduction", isOn: Binding(
                    get: { airPodsService.airPods?.ambientNoiseReduction ?? false },
                    set: { airPodsService.airPods?.ambientNoiseReduction = $0 }
                ))
            } header: {
                Text("Enhanced Features")
            }
        }
        .navigationTitle("Transparency Mode")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct TransparencySettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TransparencySettingsScreen()
                .environmentObject(AirPodsService())
        }
    }
}
