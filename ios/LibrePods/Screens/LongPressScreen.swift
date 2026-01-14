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

struct LongPressScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    
    var body: some View {
        Form {
            Section {
                Picker("Left AirPod", selection: Binding(
                    get: { airPodsService.airPods?.leftStemAction ?? .noiseControl },
                    set: { airPodsService.airPods?.leftStemAction = $0 }
                )) {
                    ForEach(StemAction.allCases, id: \.self) { action in
                        Text(action.displayName).tag(action)
                    }
                }
                
                Picker("Right AirPod", selection: Binding(
                    get: { airPodsService.airPods?.rightStemAction ?? .noiseControl },
                    set: { airPodsService.airPods?.rightStemAction = $0 }
                )) {
                    ForEach(StemAction.allCases, id: \.self) { action in
                        Text(action.displayName).tag(action)
                    }
                }
            } header: {
                Text("Press and Hold Actions")
            } footer: {
                Text("Choose what happens when you press and hold the stem on each AirPod.")
            }
            
            Section {
                Picker("Double Tap", selection: Binding(
                    get: { airPodsService.airPods?.longPressAction ?? .siri },
                    set: { airPodsService.airPods?.longPressAction = $0 }
                )) {
                    ForEach(StemAction.allCases, id: \.self) { action in
                        Text(action.displayName).tag(action)
                    }
                }
            } header: {
                Text("Double Tap Action")
            } footer: {
                Text("Customize what happens when you double tap the stem.")
            }
        }
        .navigationTitle("Press and Hold")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct LongPressScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LongPressScreen()
                .environmentObject(AirPodsService())
        }
    }
}
