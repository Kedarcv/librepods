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

struct AdaptiveStrengthScreen: View {
    
    @State private var adaptiveStrength: Double = 0.5
    
    var body: some View {
        Form {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Strength")
                        Spacer()
                        Text(strengthLabel)
                            .foregroundColor(.secondary)
                    }
                    
                    Slider(value: $adaptiveStrength, in: 0...1, step: 0.1)
                }
            } header: {
                Text("Adaptive Audio Strength")
            } footer: {
                Text("Adjust how aggressively Adaptive Audio responds to your environment.")
            }
            
            Section {
                Text("Adaptive Audio automatically adjusts noise control based on your surroundings.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } header: {
                Text("About Adaptive Audio")
            }
        }
        .navigationTitle("Adaptive Strength")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private var strengthLabel: String {
        switch adaptiveStrength {
        case 0..<0.3:
            return "Light"
        case 0.3..<0.7:
            return "Moderate"
        default:
            return "Strong"
        }
    }
}

// MARK: - Preview
struct AdaptiveStrengthScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AdaptiveStrengthScreen()
        }
    }
}
