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

@main
struct LibrePodsApp: App {
    
    @StateObject private var airPodsService = AirPodsService()
    
    init() {
        // Request notification permissions
        requestNotificationPermissions()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(airPodsService)
        }
    }
    
    private func requestNotificationPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
            print("Notification permissions granted: \(granted)")
        }
    }
}

struct ContentView: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    @State private var showOnboarding: Bool = true
    
    var body: some View {
        NavigationStack {
            if showOnboarding && !UserDefaults.standard.bool(forKey: "onboarding_completed") {
                OnboardingScreen(showOnboarding: $showOnboarding)
            } else if airPodsService.isConnected {
                AirPodsSettingsScreen()
            } else {
                ConnectionScreen()
            }
        }
    }
}

// MARK: - Connection Screen
struct ConnectionScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    @State private var isScanning: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image(systemName: "airpodspro")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                .foregroundColor(.blue)
            
            Text("LibrePods")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Connect your AirPods")
                .font(.title3)
                .foregroundColor(.secondary)
            
            Spacer()
            
            if isScanning {
                ProgressView("Scanning...")
                    .padding()
            }
            
            if !airPodsService.bluetoothManager.discoveredPeripherals.isEmpty {
                List(airPodsService.bluetoothManager.discoveredPeripherals, id: \.identifier) { peripheral in
                    Button(action: {
                        airPodsService.connect(to: peripheral)
                    }) {
                        HStack {
                            Image(systemName: "airpodspro")
                                .foregroundColor(.blue)
                            
                            VStack(alignment: .leading) {
                                Text(peripheral.name ?? "Unknown AirPods")
                                    .font(.headline)
                                Text(peripheral.identifier.uuidString)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(height: 200)
            }
            
            Button(action: {
                if isScanning {
                    airPodsService.stopScanning()
                    isScanning = false
                } else {
                    airPodsService.startScanning()
                    isScanning = true
                }
            }) {
                Text(isScanning ? "Stop Scanning" : "Scan for AirPods")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Connect")
    }
}
