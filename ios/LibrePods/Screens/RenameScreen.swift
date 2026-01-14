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

struct RenameScreen: View {
    
    @EnvironmentObject var airPodsService: AirPodsService
    @Environment(\.dismiss) var dismiss
    
    @State private var newName: String = ""
    @State private var showingAlert = false
    
    var body: some View {
        Form {
            Section {
                TextField("AirPods Name", text: $newName)
                    .textInputAutocapitalization(.words)
            } header: {
                Text("Device Name")
            } footer: {
                Text("You'll need to re-pair your AirPods with your device for the name change to take effect.")
            }
            
            Section {
                Button("Save") {
                    if !newName.isEmpty {
                        airPodsService.rename(to: newName)
                        showingAlert = true
                    }
                }
                .disabled(newName.isEmpty)
            }
        }
        .navigationTitle("Rename AirPods")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            newName = airPodsService.airPods?.name ?? "AirPods"
        }
        .alert("Name Updated", isPresented: $showingAlert) {
            Button("OK") {
                dismiss()
            }
        } message: {
            Text("Your AirPods have been renamed to \"\(newName)\". Please re-pair them for the change to take effect.")
        }
    }
}

// MARK: - Preview
struct RenameScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            RenameScreen()
                .environmentObject(AirPodsService())
        }
    }
}
