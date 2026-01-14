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

struct OpenSourceLicensesScreen: View {
    
    let licenses = [
        License(
            name: "LibrePods",
            license: "GPL-3.0",
            url: "https://github.com/kavishdevar/librepods"
        )
    ]
    
    var body: some View {
        List(licenses) { license in
            VStack(alignment: .leading, spacing: 8) {
                Text(license.name)
                    .font(.headline)
                
                Text(license.license)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if let url = URL(string: license.url) {
                    Link(destination: url) {
                        Text(license.url)
                            .font(.caption)
                            .foregroundColor(.blue)
                            .lineLimit(1)
                    }
                }
            }
            .padding(.vertical, 4)
        }
        .navigationTitle("Open Source Licenses")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct License: Identifiable {
    let id = UUID()
    let name: String
    let license: String
    let url: String
}

// MARK: - Preview
struct OpenSourceLicensesScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            OpenSourceLicensesScreen()
        }
    }
}
