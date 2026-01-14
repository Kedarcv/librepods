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

struct HearingAidScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    
    var body: some View {
        Form {
            Section {
                Toggle("Enable Hearing Aid", isOn: Binding(
                    get: { airPodsService.airPods?.hearingAidEnabled ?? false },
                    set: { airPodsService.airPods?.hearingAidEnabled = $0 }
                ))
            } footer: {
                Text("Use your AirPods as a hearing aid with personalized audio settings based on your audiogram.")
            }
            
            Section {
                NavigationLink(destination: HearingAidAdjustmentsScreen()) {
                    HStack {
                        Image(systemName: "waveform.path.ecg")
                        Text("Adjustments")
                    }
                }
                
                NavigationLink(destination: UpdateHearingTestScreen()) {
                    HStack {
                        Image(systemName: "chart.bar.fill")
                        Text("Audiogram")
                    }
                }
            } header: {
                Text("Configuration")
            }
            
            Section {
                Text("Hearing aid features allow you to customize audio based on your hearing profile.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("About Hearing Aid")
            }
        }
        .navigationTitle("Hearing Aid")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct HearingAidScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HearingAidScreen()
                .environmentObject(AirPodsService())
        }
    }
}
