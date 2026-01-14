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

struct BatteryView: View {
    let batteryStatus: BatteryStatus
    let model: AirPodsModel?
    
    var body: some View {
        VStack(spacing: 20) {
            // AirPods image
            if let model = model {
                Image(systemName: getImageName(for: model))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .foregroundColor(.primary)
            } else {
                Image(systemName: "airpodspro")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 150)
                    .foregroundColor(.primary)
            }
            
            // Battery indicators
            HStack(spacing: 30) {
                // Left bud
                if let left = batteryStatus.left {
                    BatteryIndicator(
                        percentage: left,
                        label: "L",
                        isCharging: batteryStatus.leftCharging
                    )
                }
                
                // Right bud
                if let right = batteryStatus.right {
                    BatteryIndicator(
                        percentage: right,
                        label: "R",
                        isCharging: batteryStatus.rightCharging
                    )
                }
                
                // Case
                if let case_ = batteryStatus.case_ {
                    BatteryIndicator(
                        percentage: case_,
                        label: "Case",
                        isCharging: batteryStatus.caseCharging
                    )
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
    }
    
    private func getImageName(for model: AirPodsModel) -> String {
        // Map model to SF Symbol
        switch model.name {
        case "AirPods Max":
            return "airpodsmax"
        case "AirPods Pro 2", "AirPods Pro 3":
            return "airpodspro.chargingcase.wireless.fill"
        default:
            return "airpodspro"
        }
    }
}

struct BatteryIndicator: View {
    let percentage: Int
    let label: String
    let isCharging: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                // Battery outline
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(batteryColor, lineWidth: 3)
                    .frame(width: 50, height: 80)
                
                // Battery fill
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .fill(batteryColor)
                        .frame(width: 44, height: CGFloat(percentage) * 0.7)
                }
                .frame(width: 50, height: 80)
                .clipped()
                
                // Percentage text
                Text("\(percentage)%")
                    .font(.caption2)
                    .fontWeight(.bold)
                    .foregroundColor(percentage > 50 ? .white : .primary)
            }
            
            // Label
            HStack(spacing: 4) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.medium)
                
                if isCharging {
                    Image(systemName: "bolt.fill")
                        .font(.caption2)
                        .foregroundColor(.yellow)
                }
            }
        }
    }
    
    private var batteryColor: Color {
        switch percentage {
        case 0...20:
            return .red
        case 21...50:
            return .orange
        default:
            return .green
        }
    }
}

// MARK: - Preview
struct BatteryView_Previews: PreviewProvider {
    static var previews: some View {
        let batteryStatus = BatteryStatus(
            left: 85,
            right: 78,
            case_: 92,
            leftCharging: false,
            rightCharging: false,
            caseCharging: true
        )
        
        BatteryView(batteryStatus: batteryStatus, model: .airPodsPro2)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
