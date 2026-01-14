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

struct HearingAidAdjustmentsScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    @State private var leftEarAmplification: Double = 0.5
    @State private var rightEarAmplification: Double = 0.5
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Left Ear")
                        .font(.headline)
                    
                    HStack {
                        Text("Low")
                            .font(.caption)
                        Slider(value: $leftEarAmplification, in: 0...1)
                        Text("High")
                            .font(.caption)
                    }
                }
                
                VStack(alignment: .leading, spacing: 12) {
                    Text("Right Ear")
                        .font(.headline)
                    
                    HStack {
                        Text("Low")
                            .font(.caption)
                        Slider(value: $rightEarAmplification, in: 0...1)
                        Text("High")
                            .font(.caption)
                    }
                }
            } header: {
                Text("Amplification")
            } footer: {
                Text("Adjust the amplification level for each ear based on your hearing profile.")
            }
            
            Section {
                Button("Reset to Default") {
                    leftEarAmplification = 0.5
                    rightEarAmplification = 0.5
                }
            }
        }
        .navigationTitle("Adjustments")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct HearingAidAdjustmentsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HearingAidAdjustmentsScreen()
                .environmentObject(AirPodsService())
        }
    }
}
