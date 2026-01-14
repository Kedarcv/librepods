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

struct AppSettingsScreen: View {
    
    @AppStorage("auto_connect") private var autoConnect = true
    @AppStorage("show_battery_notification") private var showBatteryNotification = true
    @AppStorage("low_battery_threshold") private var lowBatteryThreshold = 20.0
    @AppStorage("act_as_apple_device") private var actAsAppleDevice = false
    
    var body: some View {
        Form {
            Section {
                Toggle("Auto Connect", isOn: $autoConnect)
                
                Toggle("Battery Notifications", isOn: $showBatteryNotification)
                
                if showBatteryNotification {
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text("Low Battery Threshold")
                            Spacer()
                            Text("\(Int(lowBatteryThreshold))%")
                                .foregroundColor(.secondary)
                        }
                        
                        Slider(value: $lowBatteryThreshold, in: 10...50, step: 5)
                    }
                }
            } header: {
                Text("Connection")
            }
            
            Section {
                Toggle("Act as Apple Device", isOn: $actAsAppleDevice)
            } header: {
                Text("Advanced")
            } footer: {
                Text("Enable this to access special features like hearing aid and multi-device connectivity. Requires Bluetooth device ID spoofing.")
            }
            
            Section {
                NavigationLink(destination: TroubleshootingScreen()) {
                    HStack {
                        Image(systemName: "wrench.and.screwdriver")
                        Text("Troubleshooting")
                    }
                }
                
                NavigationLink(destination: DebugScreen()) {
                    HStack {
                        Image(systemName: "ladybug")
                        Text("Debug Logs")
                    }
                }
            } header: {
                Text("Diagnostics")
            }
            
            Section {
                NavigationLink(destination: VersionInfoScreen()) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("About LibrePods")
                    }
                }
                
                NavigationLink(destination: OpenSourceLicensesScreen()) {
                    HStack {
                        Image(systemName: "doc.text")
                        Text("Open Source Licenses")
                    }
                }
            } header: {
                Text("About")
            }
        }
        .navigationTitle("App Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct AppSettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            AppSettingsScreen()
        }
    }
}
