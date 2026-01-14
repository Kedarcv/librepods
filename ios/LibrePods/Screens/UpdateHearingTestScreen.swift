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

struct UpdateHearingTestScreen: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var frequencies = [250, 500, 1000, 2000, 4000, 8000]
    @State private var leftEarLevels: [Int: Double] = [:]
    @State private var rightEarLevels: [Int: Double] = [:]
    
    var body: some View {
        Form {
            Section {
                Text("Enter your audiogram results to personalize your hearing aid settings.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Section {
                ForEach(frequencies, id: \.self) { freq in
                    VStack(alignment: .leading, spacing: 8) {
                        Text("\(freq) Hz")
                            .font(.headline)
                        
                        HStack {
                            Text("L:")
                            Slider(value: Binding(
                                get: { leftEarLevels[freq] ?? 0 },
                                set: { leftEarLevels[freq] = $0 }
                            ), in: -10...120)
                            Text("\(Int(leftEarLevels[freq] ?? 0)) dB")
                                .frame(width: 50)
                        }
                        
                        HStack {
                            Text("R:")
                            Slider(value: Binding(
                                get: { rightEarLevels[freq] ?? 0 },
                                set: { rightEarLevels[freq] = $0 }
                            ), in: -10...120)
                            Text("\(Int(rightEarLevels[freq] ?? 0)) dB")
                                .frame(width: 50)
                        }
                    }
                }
            } header: {
                Text("Audiogram Data")
            } footer: {
                Text("Enter the hearing threshold levels for each frequency in decibels (dB).")
            }
            
            Section {
                Button("Save Audiogram") {
                    saveAudiogram()
                    dismiss()
                }
                
                Button("Reset") {
                    leftEarLevels = [:]
                    rightEarLevels = [:]
                }
            }
        }
        .navigationTitle("Update Audiogram")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func saveAudiogram() {
        // Save audiogram data
        // This would be encoded and saved to UserDefaults or sent to AirPods
        print("Saving audiogram data...")
    }
}

// MARK: - Preview
struct UpdateHearingTestScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            UpdateHearingTestScreen()
        }
    }
}
