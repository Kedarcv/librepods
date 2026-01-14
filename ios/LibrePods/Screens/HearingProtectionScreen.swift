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

struct HearingProtectionScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    @State private var loudSoundReduction = true
    @State private var threshold: Double = 85
    
    var body: some View {
        Form {
            Section {
                Toggle("Loud Sound Reduction", isOn: Binding(
                    get: { airPodsService.airPods?.loudSoundReduction ?? false },
                    set: { airPodsService.airPods?.loudSoundReduction = $0 }
                ))
            } footer: {
                Text("Reduce loud sounds to protect your hearing during extended listening sessions.")
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Threshold")
                        Spacer()
                        Text("\(Int(threshold)) dB")
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: $threshold, in: 75...100, step: 5)
                }
            } header: {
                Text("Sound Limit")
            } footer: {
                Text("Sounds above this level will be reduced to protect your hearing.")
            }
            
            Section {
                Text("The World Health Organization recommends keeping sound levels below 85 dB for extended listening.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("About Hearing Protection")
            }
        }
        .navigationTitle("Hearing Protection")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct HearingProtectionScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HearingProtectionScreen()
                .environmentObject(AirPodsService())
        }
    }
}
