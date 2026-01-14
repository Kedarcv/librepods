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

struct VersionInfoScreen: View {
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Text("Version")
                    Spacer()
                    Text(AppVersion.version)
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Build")
                    Spacer()
                    Text(AppVersion.build)
                        .foregroundColor(.secondary)
                }
            } header: {
                Text("App Information")
            }
            
            Section {
                Link(destination: URL(string: "https://github.com/kavishdevar/librepods")!) {
                    HStack {
                        Image(systemName: "link")
                        Text("GitHub Repository")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
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
            
            Section {
                Text("LibrePods - AirPods liberated from Apple's ecosystem")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Copyright © 2025 LibrePods contributors")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Licensed under GPL-3.0")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Version")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Preview
struct VersionInfoScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            VersionInfoScreen()
        }
    }
}
