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

struct TroubleshootingScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    @State private var showingResetAlert = false
    @State private var showingExportLogs = false
    
    var body: some View {
        Form {
            Section {
                Button(action: {
                    airPodsService.disconnect()
                }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Reconnect AirPods")
                    }
                }
                
                Button(action: {
                    airPodsService.requestDeviceInfo()
                    airPodsService.requestBatteryStatus()
                }) {
                    HStack {
                        Image(systemName: "arrow.down.circle")
                        Text("Refresh Status")
                    }
                }
            } header: {
                Text("Connection")
            }
            
            Section {
                NavigationLink(destination: DebugScreen()) {
                    HStack {
                        Image(systemName: "doc.text")
                        Text("View Debug Logs")
                        Spacer()
                        Text("\(airPodsService.packetLogs.count)")
                            .foregroundColor(.secondary)
                    }
                }
                
                Button(action: {
                    showingExportLogs = true
                }) {
                    HStack {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Logs")
                    }
                }
                
                Button(action: {
                    airPodsService.packetLogs.removeAll()
                }) {
                    HStack {
                        Image(systemName: "trash")
                        Text("Clear Logs")
                    }
                }
            } header: {
                Text("Diagnostics")
            }
            
            Section {
                Button(role: .destructive, action: {
                    showingResetAlert = true
                }) {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                        Text("Reset All Settings")
                    }
                }
            } header: {
                Text("Reset")
            } footer: {
                Text("This will reset all app settings and saved AirPods data. Your AirPods will need to be re-paired.")
            }
        }
        .navigationTitle("Troubleshooting")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Reset All Settings?", isPresented: $showingResetAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                resetAllSettings()
            }
        } message: {
            Text("This action cannot be undone. All settings and saved data will be erased.")
        }
        .sheet(isPresented: $showingExportLogs) {
            ShareSheet(items: [exportLogsAsText()])
        }
    }
    
    private func resetAllSettings() {
        // Clear UserDefaults
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        
        // Disconnect AirPods
        airPodsService.disconnect()
    }
    
    private func exportLogsAsText() -> String {
        var logText = "LibrePods Debug Logs\n"
        logText += "Exported: \(Date())\n"
        logText += "Version: \(AppVersion.fullVersion)\n\n"
        
        for log in airPodsService.packetLogs {
            logText += "[\(log.timestamp)] \(log.direction == .sent ? "→" : "←") \(log.description)\n"
            logText += "Data: \(log.hexString)\n\n"
        }
        
        return logText
    }
}

struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No updates needed
    }
}

// MARK: - Preview
struct TroubleshootingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TroubleshootingScreen()
                .environmentObject(AirPodsService())
        }
    }
}
