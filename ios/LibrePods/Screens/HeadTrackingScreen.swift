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

struct HeadTrackingScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    @State private var pitch: Double = 0
    @State private var yaw: Double = 0
    @State private var roll: Double = 0
    @State private var lastGesture: HeadGesture = .none
    
    var body: some View {
        VStack(spacing: 30) {
            // Head visualization
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                    .frame(width: 200, height: 200)
                
                // Head indicator
                Circle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 20)
                    .offset(x: CGFloat(yaw) * 80, y: CGFloat(pitch) * 80)
                
                // Cross-hair
                Path { path in
                    path.move(to: CGPoint(x: 100, y: 0))
                    path.addLine(to: CGPoint(x: 100, y: 200))
                    path.move(to: CGPoint(x: 0, y: 100))
                    path.addLine(to: CGPoint(x: 200, y: 100))
                }
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            }
            .frame(width: 200, height: 200)
            
            // Orientation data
            VStack(spacing: 12) {
                HStack {
                    Text("Pitch:")
                        .frame(width: 80, alignment: .leading)
                    Text(String(format: "%.2f°", pitch * 90))
                        .font(.system(.body, design: .monospaced))
                }
                
                HStack {
                    Text("Yaw:")
                        .frame(width: 80, alignment: .leading)
                    Text(String(format: "%.2f°", yaw * 90))
                        .font(.system(.body, design: .monospaced))
                }
                
                HStack {
                    Text("Roll:")
                        .frame(width: 80, alignment: .leading)
                    Text(String(format: "%.2f°", roll * 90))
                        .font(.system(.body, design: .monospaced))
                }
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
            
            // Last gesture
            if lastGesture != .none {
                HStack {
                    Image(systemName: lastGesture == .nod ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(lastGesture == .nod ? .green : .red)
                    Text(lastGesture.displayName)
                        .font(.headline)
                }
                .padding()
                .background(Color(.tertiarySystemBackground))
                .cornerRadius(8)
            }
            
            Spacer()
            
            // Instructions
            Text("Move your head to see tracking in action")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
        .navigationTitle("Head Tracking")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // Simulate head tracking data for demo
            startSimulation()
        }
    }
    
    private func startSimulation() {
        // This would be replaced with actual head tracking data from AirPods
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            // Simulate small movements
            pitch = Double.random(in: -0.2...0.2)
            yaw = Double.random(in: -0.2...0.2)
            roll = Double.random(in: -0.1...0.1)
        }
    }
}

// MARK: - Preview
struct HeadTrackingScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            HeadTrackingScreen()
                .environmentObject(AirPodsService())
        }
    }
}
