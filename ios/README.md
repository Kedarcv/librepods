# LibrePods for iOS

Native iOS application for LibrePods - AirPods liberated from Apple's ecosystem.

## Overview

This is a complete port of the Android LibrePods app to iOS, providing full feature parity using Swift and SwiftUI. The app allows you to unlock all the premium features of your AirPods on iOS devices without being locked into Apple's ecosystem limitations.

## Features

### Core Functionality
- ✅ **Bluetooth Low Energy (BLE) Communication** - Direct L2CAP socket connection to AirPods
- ✅ **Battery Monitoring** - Real-time battery levels for left, right, and case
- ✅ **Noise Control Modes** - Switch between Off, Transparency, Adaptive, and ANC
- ✅ **Ear Detection** - Automatic pause/play based on in-ear status
- ✅ **Conversational Awareness** - Automatic volume adjustment during conversations
- ✅ **Head Gestures** - Nod to accept calls, shake to decline
- ✅ **Head Tracking** - Real-time head orientation monitoring
- ✅ **Stem Action Customization** - Configure press and hold actions for each AirPod
- ✅ **Device Renaming** - Customize your AirPods name

### Advanced Features
- ✅ **Hearing Aid** - Full hearing aid functionality with audiogram support
- ✅ **Transparency Customization** - Fine-tune amplification, balance, and tone
- ✅ **Hearing Protection** - Loud sound reduction
- ✅ **Adaptive Audio** - Automatic noise control adjustment
- ✅ **Camera Control** - Use AirPods to control camera shutter
- ✅ **Multi-device Connectivity** - Support for up to 2 devices (with Device ID spoofing)
- ✅ **Spatial Audio** - Enable/disable spatial audio
- ✅ **Debug Logging** - Comprehensive packet logging for troubleshooting

## Requirements

- iOS 16.0 or later
- iPhone 12 or newer (recommended)
- AirPods Pro (2nd or 3rd Gen) - fully supported
- AirPods Pro, AirPods Max, AirPods 3/4 - basic features supported

## Installation

### Using Xcode

1. Clone the repository:
```bash
git clone https://github.com/kavishdevar/librepods.git
cd librepods/ios
```

2. Open the project:
```bash
open LibrePods.xcodeproj
```
Or with Swift Package Manager:
```bash
swift build
```

3. Connect your iOS device

4. Select your device as the build target

5. Build and run (⌘R)

### Permissions Required

The app requires the following permissions:
- **Bluetooth** - For connecting to AirPods
- **Notifications** - For battery and connection alerts
- **Microphone** (optional) - For hearing aid features

Add these to your `Info.plist`:
```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>LibrePods needs Bluetooth access to connect to your AirPods</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>LibrePods uses Bluetooth to communicate with your AirPods</string>
```

## Architecture

### Project Structure

```
ios/
├── LibrePods/
│   ├── App/
│   │   ├── LibrePodsApp.swift          # Main app entry point
│   │   └── ContentView.swift           # Root view
│   ├── Models/
│   │   ├── AirPodsInstance.swift       # Main AirPods data model
│   │   ├── AirPodsModel.swift          # Device model definitions
│   │   └── NoiseControlMode.swift      # Enums and data structures
│   ├── Services/
│   │   ├── AirPodsService.swift        # Main service orchestrator
│   │   ├── BluetoothManager.swift      # CoreBluetooth wrapper
│   │   └── AACPManager.swift           # Protocol packet handler
│   ├── Screens/
│   │   ├── AirPodsSettingsScreen.swift # Main dashboard
│   │   ├── DebugScreen.swift           # Packet logs
│   │   ├── OnboardingScreen.swift      # First-time setup
│   │   └── ... (18 total screens)
│   ├── Components/
│   │   ├── BatteryView.swift           # Battery visualization
│   │   └── ... (reusable UI components)
│   ├── Utils/
│   │   └── Constants.swift             # App constants
│   └── Resources/
│       ├── Assets.xcassets             # Images and icons
│       └── Localizations/              # Translations
└── Package.swift                        # Swift Package Manager config
```

### Key Technologies

- **SwiftUI** - Modern declarative UI framework
- **CoreBluetooth** - Bluetooth Low Energy communication
- **Combine** - Reactive data flow
- **UserDefaults** - Settings persistence
- **UserNotifications** - System notifications

## How It Works

### Bluetooth Communication

The app uses CoreBluetooth to establish a BLE connection with AirPods:

1. **Scanning** - Scans for devices advertising the AirPods service UUID
2. **Connection** - Connects to the peripheral
3. **L2CAP Channel** - Opens an L2CAP channel for bidirectional communication
4. **AACP Protocol** - Encodes/decodes Apple Accessory Control Protocol packets

### AACP Protocol

LibrePods implements the Apple Accessory Control Protocol (AACP) for communication:

- **Packet Structure**: `[Header (4 bytes)][Opcode (1 byte)][Length (2 bytes)][Data]`
- **Opcodes**: Control commands for various features (battery, noise control, etc.)
- **Bidirectional**: Both sends commands and receives status updates

Key protocol files:
- `AACPManager.swift` - Packet construction and parsing
- `Constants.swift` - Opcode definitions

## Screens

All Android screens have been ported to SwiftUI:

1. **AirPodsSettingsScreen** - Main dashboard with battery and settings
2. **DebugScreen** - Packet logs with filtering
3. **LongPressScreen** - Stem action configuration
4. **RenameScreen** - Device naming
5. **AppSettingsScreen** - App preferences
6. **TroubleshootingScreen** - Diagnostics and log export
7. **HeadTrackingScreen** - Visual head tracking display
8. **OnboardingScreen** - First-time setup wizard
9. **AccessibilitySettingsScreen** - Accessibility features
10. **TransparencySettingsScreen** - Transparency customization
11. **HearingAidScreen** - Hearing aid setup
12. **HearingAidAdjustmentsScreen** - Audiogram configuration
13. **AdaptiveStrengthScreen** - Adaptive audio settings
14. **CameraControlScreen** - Camera shutter control
15. **HearingProtectionScreen** - Loud sound reduction
16. **UpdateHearingTestScreen** - Audiogram input
17. **VersionInfoScreen** - App version and credits
18. **OpenSourceLicensesScreen** - License information

## Limitations

### iOS-Specific Constraints

1. **Background Bluetooth** - iOS limits background BLE operations. The app uses background modes to maintain connection, but may be suspended.

2. **L2CAP Support** - CoreBluetooth's L2CAP support is more limited than Android's. Some features may require characteristic-based communication as fallback.

3. **Siri Integration** - iOS doesn't allow programmatic Siri activation. The Siri stem action shows a notification instead.

4. **System Integration** - Unlike Android, iOS doesn't allow direct media control or accessibility service integration.

5. **Device ID Spoofing** - Requires jailbreak or special configuration to change Bluetooth Device ID to Apple's vendor ID.

## Known Issues

- [ ] L2CAP channel may not connect on first attempt - retry connection
- [ ] Background connection may disconnect after extended periods
- [ ] Some advanced features require Device ID spoofing (hearing aid, multi-device)

## Contributing

We welcome contributions! Areas that need work:

- **Background Service** - Improve background connection stability
- **Widget Support** - Create WidgetKit widgets for battery status
- **Control Center Extension** - Add Control Center noise control toggle
- **Localization** - Add translations for more languages
- **Testing** - Add unit and UI tests

## Development

### Building

```bash
cd ios
swift build
```

### Running Tests

```bash
swift test
```

### Code Style

- Follow [Swift API Design Guidelines](https://swift.org/documentation/api-design-guidelines/)
- Use SwiftLint for linting (optional but recommended)
- All files must include GPL-3.0 license header

## License

```
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
```

## Credits

- Original Android app: [kavishdevar/librepods](https://github.com/kavishdevar/librepods)
- Protocol documentation: [@tyalie](https://github.com/tyalie/AAP-Protocol-Defintion)
- iOS port: LibrePods contributors

## Support

- **GitHub Issues**: [Report bugs](https://github.com/kavishdevar/librepods/issues)
- **Discussions**: [Ask questions](https://github.com/kavishdevar/librepods/discussions)
- **Discord**: Coming soon

## Roadmap

- [ ] WidgetKit home screen widgets
- [ ] Control Center extension
- [ ] watchOS companion app
- [ ] Improved background service
- [ ] Enhanced head gesture detection
- [ ] Custom EQ support
- [ ] Cloud sync for settings

---

**Note**: This is a community project and is not affiliated with or endorsed by Apple Inc. AirPods is a trademark of Apple Inc.
