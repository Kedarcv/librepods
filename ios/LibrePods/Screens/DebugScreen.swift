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

struct DebugScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    @State private var autoScroll = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Controls
            HStack {
                Button(action: {
                    airPodsService.packetLogs.removeAll()
                }) {
                    Label("Clear", systemImage: "trash")
                }
                
                Spacer()
                
                Toggle("Auto Scroll", isOn: $autoScroll)
                    .labelsHidden()
                
                Text("Auto Scroll")
                    .font(.caption)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            
            // Packet logs
            ScrollViewReader { proxy in
                List {
                    ForEach(airPodsService.packetLogs) { log in
                        PacketLogRow(log: log)
                            .id(log.id)
                    }
                }
                .onChange(of: airPodsService.packetLogs.count) { _ in
                    if autoScroll, let lastLog = airPodsService.packetLogs.last {
                        withAnimation {
                            proxy.scrollTo(lastLog.id, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct PacketLogRow: View {
    let log: AirPodsService.PacketLog
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: log.direction == .sent ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                    .foregroundColor(log.direction == .sent ? .blue : .green)
                
                Text(log.description)
                    .font(.headline)
                
                Spacer()
                
                Text(timeString(from: log.timestamp))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Text(log.hexString)
                .font(.system(.caption, design: .monospaced))
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding(.vertical, 4)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Preview
struct DebugScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DebugScreen()
                .environmentObject(AirPodsService())
        }
    }
}
